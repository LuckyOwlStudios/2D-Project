extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	#var direction := Input.get_axis("move_left", "move_right")
	#if direction:	
	#	velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * delta)
	var _direction := Input.get_vector("move_left", "move_right", "jump", "reload")
	var desired_velocity := _direction * SPEED
	velocity = velocity.move_toward(desired_velocity, 1000 * delta)
	
	
	if Input.is_action_just_pressed("sprint"):
		position.y = 100.0
	if Input.is_action_just_pressed("jump"):
		position.y = 50.0
		
	
	
	move_and_slide()
	pass
	
	
	
