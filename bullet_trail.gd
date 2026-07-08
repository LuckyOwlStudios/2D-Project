class_name BulletTrail
extends Line2D

const BULLET_TRAIL_FADE = preload("uid://cyvmr2x1ejs85")

## How long, in seconds, for the trail to fully fade out
var max_lifetime: float = 2

var fading: bool

static func create(_origin: Vector2, _target: Vector2, _color: Color, _width: float) -> BulletTrail:
	var new_trail: BulletTrail = BulletTrail.new()
	new_trail.points = PackedVector2Array([_origin, _target])
	new_trail.default_color = _color
	new_trail.width = _width
	new_trail.end_cap_mode = Line2D.LINE_CAP_BOX
	return new_trail

func _ready() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, max_lifetime)
	tween.tween_property(self, "width", 0.0, max_lifetime * 0.0625)
	tween.tween_callback(_go_white).set_delay(max_lifetime * 0.0625)
	tween.chain().tween_callback(queue_free)

func _go_white() -> void:
	fading = true
	gradient = BULLET_TRAIL_FADE
	width = 3
	default_color = Color.WHITE
