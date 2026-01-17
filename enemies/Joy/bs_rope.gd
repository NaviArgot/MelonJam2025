class_name BS_Rope extends BulletSpawner

@export var bulletSpeed : float = 3.0
@export var bulletsPerSec : int = 50
@export var twirlsPerSec : float = 0.0
@export var arms : int = 1

var time : float = 0.0
var currArm : int = 0
var angle: float = 0.0
var spawnCool: TimedCount
var rotationPerSec : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnCool = TimedCount.new(1.0 / bulletsPerSec)
	rotationPerSec = twirlsPerSec * TAU

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	angle += rotationPerSec * delta
	time += delta
	if not active: return
	if spawnCool.isReady():
		spawnCool.reset()
		var pos = global_position
		pos.y += max(sin(time*2), 0.0) * 2.0
		var rot = Vector3(0.0, TAU/arms * currArm + angle, 0.0)
		var bullet : Bullet = bulletScene.instantiate()
		bullet.init(
			originator,
			pos,
			Basis.from_euler(rot),
			1.0,
			5.0,
			MovementFactory.linear.bind(bulletSpeed),
			func (): queue_free()
			)
		currArm = (currArm + 1) % arms
		getScene().add_child(bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
