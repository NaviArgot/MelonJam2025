class_name SpawnerRope
extends ProjectileSpawner

@export var data : SpawnerRopeData

var time : float = 0.0
var currArm : int = 0
var angle: float = 0.0
var spawnCool: TimedCount
var rotationPerSec : float

func reset() -> void:
	time = 0.0
	spawnCool.reset()
	currArm = 0
	angle = 0.0
	_emitted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnCool = TimedCount.new(1.0 / data.bulletsPerSec)
	rotationPerSec = data.twirlsPerSec * TAU

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	angle += rotationPerSec * delta
	if not active: return
	time += delta
	if spawnCool.isReady():
		spawnCool.reset()
		var pos = global_position
		if data.arcAmplitude != 0.0:
			pos.y += max(
				sin(time * PI * 1/data.arcAmplitude),
				0.0
				) * data.arcHeight
		var initRad = deg_to_rad(data.initialAngle)
		var dir = Vector3(
			cos(TAU/data.arms * currArm + angle + initRad),
			0.0,
			sin(TAU/data.arms * currArm + angle + initRad),
			)
		spawnProjectile(pos, dir)
		currArm = (currArm + 1) % data.arms
	if data.lifetime > 0.0 and time >= data.lifetime:
		emit_finished_once()
