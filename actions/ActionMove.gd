class_name ActionMove
extends BaseAction

@export var actor : Node3D
@export var animationPlayer : AnimationPlayer
@export var animationName : String

@export var start : Vector3
@export var end : Vector3
@export var duration : float

var _active : bool = false
var _time : float = 0.0

func play() -> void:
	_active = true
	_time = 0.0
	animationPlayer.play(animationName)

func stop() -> void:
	finished.emit()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if _active:
		_time += delta
		actor.position = start + (end - start)/duration * _time
