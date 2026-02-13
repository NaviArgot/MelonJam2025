class_name BS_Ring extends BulletSpawner

@export var repetitions : int = 1
@export var bulletSpeed : float = 3.0
@export var spawnCooldown : float = 1.0
@export var deltaAngle : float = 0.0
@export var arms : int = 1

var movementFunc : Callable

var time : float = 0.0
var angle: float = 0.0
var spawnCool: TimedCount
var totalReps: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnCool = TimedCount.new(spawnCooldown)
	if not movementFunc:
		movementFunc = MovementFactory.linear.bind(bulletSpeed)

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	time += delta
	if not active or totalReps > repetitions: return
	if spawnCool.isReady():
		spawnCool.reset()
		for i in range(arms):
			var pos = global_position
			var rot = Vector3(0.0, TAU/arms * i + angle, 0.0)
			var bullet : Bullet = bulletScene.instantiate()
			bullet.init(
				originator,
				pos,
				Basis.from_euler(rot),
				1.0,
				15.0,
				movementFunc,
				func (): queue_free()
				)
			angle += deg_to_rad(deltaAngle)
			getScene().add_child(bullet)
		totalReps += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
