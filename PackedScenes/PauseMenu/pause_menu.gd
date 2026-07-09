extends Control


@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	visible = false
	
	# pressing resume ensures process functions for all world scenes resumes running
	# visible set to false when pressed to toggle pause menu off
	resume_button.pressed.connect(func():
		get_tree().paused = false
		visible = false
		)
	quit_button.pressed.connect(func(): get_tree().quit())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause_menu()

func toggle_pause_menu() -> void:
	#This toggles pause menu ON and pauses game
	if visible == false:
		visible = true
		get_tree().paused = true
	#This toggles pause menu OFF and unpauses game	
	elif visible == true:
		visible = false
		get_tree().paused = false
