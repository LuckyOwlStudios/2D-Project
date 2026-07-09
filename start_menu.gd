extends Control

@onready var start_button: Button = %StartButton
@onready var exit_button: Button = %ExitButton
@onready var beacon_light: Sprite2D = %BeaconLight


#starting value for beacon light's modulate:a property
@export var starting_light_strength : float
#ending value for beacon light's modulate:a property
@export var ending_light_strength : float
#duration range for beacon light growing and beacon light fading tween
@export_range(0.8, 2.0) var tween_duration : float

#keeps track of the state of beacon light, is set to false first beacuse animation plays from 
#starting light strength value
#May need to redefine name for this variable for more straightforward context 
var beacon_light_can_fade : bool = false
#reference to main game world scene
const WORLD = preload("uid://bulm60oi6osn7")

func _ready() -> void:
	start_button.pressed.connect(get_tree().change_scene_to_packed.bind(WORLD))
	exit_button.pressed.connect(get_tree().quit)
	beacon_light.modulate.a = 0.5
	
func _process(delta: float) -> void:
	if beacon_light_can_fade == false:
		beacon_light_growing()
	else:
		beacon_light_fading()
	
func beacon_light_growing():
	var light_blinking_tween := create_tween()
	light_blinking_tween.tween_property(beacon_light, "modulate:a", ending_light_strength, 1.3)
	light_blinking_tween.finished.connect(func(): beacon_light_can_fade = true)
	
func beacon_light_fading():
	var light_fading_tween := create_tween()
	light_fading_tween.tween_property(beacon_light, "modulate:a", starting_light_strength, 1.3)
	light_fading_tween.finished.connect(func():beacon_light_can_fade = false)
	
	
