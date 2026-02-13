class_name BS_Sides extends BulletSpawner

@export var bulletSpeed : float = 3.0
@export var bulletCooldown : float = 0.1
@export var amplitude : float = 0.0

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

func computeForward():
	if global_position.distance_squared_to(prevPos) < 0.1: return
	forward = global_position - prevPos
	prevPos = global_position
	forward = forward.normalized()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bulletScene = preload("res://bullets/bouncy_bullet.tscn")
	spawnCool = TimedCount.new(bulletCooldown)
	prevPos = global_position

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	time += delta
	computeForward()
	if not active: return
	if spawnCool.isReady():
		spawnCool.reset()
		var rad = deg_to_rad(amplitude)
		spawnBullet(
			Basis.looking_at(forward)
				.rotated(Vector3.UP, TAU/4)
				.rotated(Vector3.UP, rad)
				* Vector3.RIGHT
		)
		spawnBullet(
			Basis.looking_at(forward)
				.rotated(Vector3.UP, TAU/4)
				.rotated(Vector3.UP, -rad)
				* Vector3.RIGHT
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
