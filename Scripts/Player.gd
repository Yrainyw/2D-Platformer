extends KinematicBody2D

var gravity = 1000 # 重力大小，越大下落越快
var velocity = Vector2.ZERO

var maxHorizontalSpeed = 140 # 水平移动最大速度(跑多快)
var horizontalAcceleration = 2000 # 水平加速度(多快能跑到最大速度,越大起步越快)

var jumpSpeed = 360 # 跳跃初速度(跳多高)
var jumpTerminationMultiplier = 4  # 松开跳跃键后,重力加倍的倍数(控制"跳跃高度可变":点一下跳得低,按住跳得高)


func _ready():
	pass # Replace with function body.
	
	
func _process(delta):
	var moveVector = get_movement_vector()

	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		velocity.x = lerp(velocity.x, 0, .1)
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)

	if (moveVector.y < 0 && is_on_floor()):
		velocity.y = moveVector.y * jumpSpeed
		
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	updateAnimation()
	

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
	
