class_name Slingshot extends Weapon

@export var cooldownTime : float = 1.0
@export var projectile : PackedScene
@export var projectileData : ProjectileData

var cooldownCount : float = 0.0
var facing : Vector3 = Vector3.FORWARD

func spawnAttack(pos: Vector3, dir: Vector3):
	var instance : Projectile = projectile.instantiate()
	instance.origin = pos
	instance.originator = originator
	instance.faceTowards(dir)
	instance.data = projectileData
	instance.data.damage = damage
	get_tree().root.get_children()[-1].add_child(instance)

func faceTowards (direction: Vector3) -> void:
	super.faceTowards(direction)
	facing = direction

func enableWeapon() -> void:
	visible = true
	if cooldownCount <= 0.0:
		$AudioStreamPlayer.play()
		cooldownCount = cooldownTime
		spawnAttack(global_position, facing)

func disableWeapon() -> void:
	visible = false

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	cooldownCount -= delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
