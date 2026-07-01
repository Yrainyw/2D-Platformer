extends KinematicBody2D

signal died

enum State { NORMAL, DASHING }

var gravity = 1000 # 重力大小，越大下落越快
var velocity = Vector2.ZERO

var maxHorizontalSpeed = 140 # 水平移动最大速度(跑多快)
var horizontalAcceleration = 2000 # 水平加速度(多快能跑到最大速度,越大起步越快)

var maxDashSpeed = 500
var minDashSpeed = 200

var jumpSpeed = 360 # 跳跃初速度(跳多高)
var jumpTerminationMultiplier = 4  # 松开跳跃键后,重力加倍的倍数(控制"跳跃高度可变":点一下跳得低,按住跳得高)
var hasDoubleJump = false

var currentState = State.NORMAL
var isStateNew = true


func _ready():
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	
	
func _process(delta):
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
	isStateNew = false
			
			
func change_state(newState):
	currentState = newState
	isStateNew = true
	
	
func process_normal(delta):
	var moveVector = get_movement_vector()

	velocity.x += moveVector.x * horizontalAcceleration * delta
	
	if (moveVector.x == 0):
		velocity.x = lerp(velocity.x, 0, .1)
		velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)

	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump)):
		velocity.y = moveVector.y * jumpSpeed
		if (!is_on_floor() && $CoyoteTimer.is_stopped()):
			hasDoubleJump = false
		$CoyoteTimer.stop()
		
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
		
	var wasOnFloor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
		
	if (is_on_floor()):
		hasDoubleJump = true
		
	if (Input.is_action_just_pressed("dash")):
		call_deferred("change_state", State.DASHING)
	
	updateAnimation()


func process_dash(delta):
	if (isStateNew):
		$AnimatedSprite.play("jump")
		var moveVector = get_movement_vector()
		var velocityMod = 1
		
		if (moveVector.x != 0):
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else -1
			
		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
	
	if (abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.NORMAL)
		

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector
	
	
func updateAnimation():
	var moveVector = get_movement_vector()
	
	if (!is_on_floor()):
		$AnimatedSprite.play("jump")
	elif (moveVector.x != 0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")

	if (moveVector.x != 0):
		$AnimatedSprite.flip_h = true if moveVector.x > 0 else false
	

func on_hazard_area_entered(_area2d):
	emit_signal("died")
