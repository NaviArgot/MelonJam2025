extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Bullet");
	var bullet = load("res://bullets/bullet.tscn").instantiate()
	for child in bullet.get_children():
		print(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
