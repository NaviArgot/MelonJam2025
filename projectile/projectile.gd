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
var quatRot : Quaternion

func faceTowards(dir : Vector3) -> void:
	if dir.is_zero_approx(): dir = Vector3.FORWARD
	moveDirection = dir
	var qua := Quaternion(Vector3.RIGHT, dir)
	quatRot = qua

func _updatePos(time):
	var pos = data.movement.getPosition(time)
	var point = Quaternion(pos.x, pos.y, pos.z, 0)
	var rotated = quatRot.inverse() * point * quatRot
	var end = Vector3(rotated.x, rotated.y, rotated.z)
	position = origin + end * Vector3(1.0, -1.0, 1.0)

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
