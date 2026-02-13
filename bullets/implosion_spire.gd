class_name ImplosionSpire extends Node3D

var damage : float = 1.0
var maxLifeTime : float = 5.0
var originator : Node3D = null
var lifetime : float = 0.0

func init(
	originator_: Node3D,
	pos_: Vector3,
	damage_: float,
	lifetime_: float,
	):
		global_position = pos_
		damage = damage_
		maxLifeTime = lifetime_
		originator = originator_

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AttackArea.initialize(damage, originator)
	$AnimationPlayer.speed_scale = 1 / maxLifeTime
	$AnimationPlayer.play("implosion")
	
func _physics_process(delta: float) -> void:
	lifetime += delta
	if lifetime >= maxLifeTime:
		queue_free()
