extends Control

signal transition_finished

func fadeOut():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	transition_finished.emit()
	

func fadeIn():
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	transition_finished.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
