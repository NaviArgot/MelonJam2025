class_name BS_Directed extends BulletSpawner

@export var bulletSpeed : float = 3.0
@export var bulletCooldown : float = 0.1

var time : float = 0.0
var spawnCool: TimedCount
var prevPos: Vector3 = Vector3(0.0, 0.0, 0.0)
var forward: Vector3 = Vector3.FORWARD


func spawnBullet(dir: Vector3):
	var bullet : BouncyBullet = bulletScene.instantiate()
	bullet.init(
		originator,
		global_position,
		dir,
		bulletSpeed,
		1.0,
		5.0,
		func (): queue_free()
		)
	getScene().add_child(bullet)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bulletScene = preload("res://bullets/bouncy_bullet.tscn")
	spawnCool = TimedCount.new(bulletCooldown)

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	time += delta
	if not active: return
	if spawnCool.isReady():
		spawnCool.reset()
		var dir: Vector3 = (PlayerManager.getPosition() - global_position).normalized()
		dir.y = 0.0
		spawnBullet(dir)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
