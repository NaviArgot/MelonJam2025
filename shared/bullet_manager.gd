extends Node3D

func spawnBullet(spawner : Callable):
	var scene = get_tree().root.get_children()[-1]
	var bullet = spawner.call()
	scene.add_child(bullet)
	return bullet
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
