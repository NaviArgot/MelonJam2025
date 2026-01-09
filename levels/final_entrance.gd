extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Entrance.visible = false
	$Entrance.process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerManager.hasAcceptedAll():
		$Entrance.visible = true
		$Entrance.process_mode = Node.PROCESS_MODE_INHERIT
	pass
