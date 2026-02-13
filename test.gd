extends Node3D

@export var speed : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Bullet")
	var bullet = load("res://bullets/bullet.tscn").instantiate()
	for child in bullet.get_children():
		print(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		position.z += speed * delta
	if Input.is_action_pressed("down"):
		position.z -= speed * delta
	if Input.is_action_pressed("right"):
		position.x += speed * delta
	if Input.is_action_pressed("left"):
		position.x -= speed * delta
