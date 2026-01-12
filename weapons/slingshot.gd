class_name Slingshot extends Weapon

@export var cooldownTime : float = 1.0
@export var bulletSpeed : float = 10.0

var bulletScene = preload("res://bullets/bullet.tscn")
var cooldownCount : float = 0.0
var facing : Vector3 = Vector3.FORWARD

func spawnBullet(dir: Vector3):
	var bullet = bulletScene.instantiate()
	bullet.position = global_position
	bullet.direction = dir
	bullet.speed = bulletSpeed
	bullet.damage = damage
	bullet.originator = originator
	get_tree().root.get_children()[-1].add_child(bullet)

func faceTowards (direction: Vector3) -> void:
	super.faceTowards(direction)
	facing = direction

func enableWeapon() -> void:
	visible = true
	if cooldownCount <= 0.0:
		$AudioStreamPlayer.play()
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
