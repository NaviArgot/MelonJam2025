extends Node3D

var bgIntro = preload("res://assets/realmusics/intro intro.wav")
var bgLoop = preload("res://assets/realmusics/intro loop.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transitions.fadeIn()
	GlobalAudio.playMusicWithLoop(bgIntro, bgLoop)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
