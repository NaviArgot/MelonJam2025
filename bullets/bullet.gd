class_name Bullet extends Node3D

@export var speed : float = 1.0
@export var direction : Vector3 = Vector3(1.0, 0.0, 0.0)
@export var damage : float = 1.0
@export var maxLifeTime : float = 5.0

var lifetime : float = 0.0
var originator : Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AttackArea.initialize(damage, originator)
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	lifetime += delta
	if lifetime >= maxLifeTime:
		queue_free()
	position += speed * direction * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
