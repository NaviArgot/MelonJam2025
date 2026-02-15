class_name SpawnerRope
extends ProjectileSpawner

@export var bulletsPerSec : int = 50
@export var twirlsPerSec : float = 0.0
@export var arms : int = 1
@export var initialAngle : float = 0.0
@export var arcHeight : float
@export var arcAmplitude : float

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
		if arcAmplitude != 0.0:
			pos.y += max(
				sin(time * PI * 1/arcAmplitude),
				0.0
				) * arcHeight
		var initRad = deg_to_rad(initialAngle)
		var dir = Vector3(
			cos(TAU/arms * currArm + angle + initRad),
			0.0,
			sin(TAU/arms * currArm + angle + initRad),
			)
		spawnProjectile(pos, dir)
		currArm = (currArm + 1) % arms
