class_name Slingshot extends Weapon

@export var cooldownTime : float = 1.0
@export var bulletSpeed : float = 10.0

var bulletScene = preload("res://bullet.tscn")
var cooldownCount : float = 0.0

func spawnBullet(dir: Vector3):
	var bullet = bulletScene.instantiate()
	bullet.position = global_position
	bullet.direction = dir
	bullet.speed = bulletSpeed
	bullet.damage = damage
	bullet.originator = self
	get_tree().root.add_child(bullet)

func enableWeapon(facing : Vector3) -> void:
	visible = true
	faceTowards(facing)
	if cooldownCount <= 0.0:
		cooldownCount = cooldownTime
		spawnBullet(facing)

func disableWeapon() -> void:
	visible = false

func _ready() -> void:
	super._ready()
	damage = 5.0

func _physics_process(delta: float) -> void:
	cooldownCount -= delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
