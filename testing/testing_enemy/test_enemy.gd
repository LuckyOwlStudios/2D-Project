class_name TestEnemy 
extends CharacterBody2D


@export var speed := 300.0
@export var jump_velocity := -300.0
@export var acceleration : float = 500.0
@export var decceleration : float

@onready var health: Health = $Health
# gets reference to player node in WORLD scene
@onready var player := $"/root/TestWorld/Player"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var line_of_sight: RayCast2D = %LineOfSight
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hurt_box: HurtBox = $HurtBox
@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	health.health_depleted.connect(queue_free)
	progress_bar.value = health.current_health
	hurt_box.damaged.connect(func():
		animated_sprite_2d.play("take_damage")
		animated_sprite_2d.animation_finished.connect(func():
			animated_sprite_2d.play("idle")
			)
		var tween := create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUART)
		tween.tween_property(self, "modulate:a", 0.5, 0.3)
		tween.finished.connect(timer.start)
		timer.timeout.connect(func():
			var tween_reappear := create_tween()
			tween_reappear.set_ease(Tween.EASE_IN)
			tween_reappear.tween_property(self, "modulate:a", 1.0, 0.3)
			)
		)
	
	
func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(player.global_position)
	var desired_velocity := direction * speed
	#velocity = velocity.move_toward(desired_velocity, speed * delta)
	velocity.x = move_toward(velocity.x, desired_velocity.x, acceleration * delta)
	
	# for testing, doesn't do anything currently
	var distance := global_position.distance_to(player.global_position)
	if distance < 30.0:
		#velocity = Vector2.ZERO
		pass
		
	# refactor with early return? 
	# flips sprite and line of sight if player is either left or right of enemy 	
	if global_position.x > player.global_position.x and line_of_sight.target_position.x > 1.0:
		#sprite_2d.flip_h = true
		animated_sprite_2d.scale.x = 1.0
		line_of_sight.target_position.x *= -1.0
		
	elif global_position.x < player.global_position.x and line_of_sight.target_position.x < 1.0:
		#sprite_2d.flip_h = false	
		animated_sprite_2d.scale.x = -1.0
		line_of_sight.target_position.x *= -1.0
	
	# gives a sudden movement boost/lunge in the direction of the player when we add or subtract to 
	# the x velocity, change for stronger or weaker effect 
	# should disable after "lunging" and give it a cooldown before it can proc again 
	# need to rework
	if line_of_sight.is_colliding():
		if velocity.x > 1:
			velocity.x = desired_velocity.x + 100.0
			#line_of_sight.enabled = false
		else:
			velocity.x = desired_velocity.x - 100.0
			#line_of_sight.enabled = false
		#print(velocity.x)	
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()


	
	
	
		
