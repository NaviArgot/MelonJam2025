class_name Projectile
extends Node3D

@export var data : ProjectileData
@export var originator : Node3D
@export var origin : Vector3
@export var moveDirection : Vector3 = Vector3(1.0, 0.0, 0.0)

## Collision used by other entities to receive damage
@onready var attackArea : AttackArea = %AttackArea

## Collision used by the bullet to allow it to be destroyed
## by the player's sword attacks
@onready var damageArea : Area3D = %DamageArea

var _time : float = 0.0
var initialRotation : Basis

func faceTowards(dir : Vector3) -> void:
	if dir.length_squared() < 0.01: dir = Vector3.FORWARD
	var theta := atan2(dir.z, dir.x) # rotation in y axis
	var phi := atan2(dir.y, dir.x) # rotation in z axis
	initialRotation = Basis.from_euler(Vector3(0, theta, phi))

func _updatePos(time):
	position = origin + initialRotation * data.movement.getPosition(time)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	faceTowards(moveDirection)
	_updatePos(0.0)
	attackArea.initialize(data.damage, originator)
	damageArea.area_entered.connect(_onDamageAreaEntered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_time += delta
	_updatePos(_time)
	if data.lifetime > 0.0 and _time >= data.lifetime:
		queue_free()


func _onDamageAreaEntered(area : Area3D) -> void:
	if "ATTACKAREA" in area and area.originator != self:
		queue_free()
