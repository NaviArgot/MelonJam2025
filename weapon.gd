class_name Weapon
extends StaticBody3D

@export var distance: float = 0.0
@export var damage: float = 1.0

var enabled: bool = false

func attack(facing: Vector3) -> void:
	enabled = true
	position = (facing * distance)
	var angle = -atan2(facing.z, facing.x) + PI*3/2
	$Mesh.rotation.y = angle

func disable() -> void:
	enabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled = false


func _physics_process(delta: float) -> void:
	if enabled:
		visible = true
		$Collision.disabled = false
	else:
		visible = false
		$Collision.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
