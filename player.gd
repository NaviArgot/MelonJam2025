class_name Player
extends CharacterBody3D

@export var maxSpeed: float = 1.0
var speed: Vector3 = Vector3(0.0, 0.0, 0.0)

func receiveInput () -> void:
	speed.x = 0.0
	speed.z = 0.0
	if Input.is_action_pressed("up"):
		speed.z = -maxSpeed
	if Input.is_action_pressed("down"):
		speed.z = +maxSpeed
	if Input.is_action_pressed("right"):
		speed.x = maxSpeed
	if Input.is_action_pressed("left"):
		speed.x = -maxSpeed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	receiveInput()
	move_and_collide(speed * delta)
	print(position)
