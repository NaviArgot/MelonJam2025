class_name SpawnerRing
extends ProjectileSpawner

@export var data : SpawnerRingData

var time : float = 0.0
var spawnCool: TimedCount
var totalReps: int = 0

func reset() -> void:
	time = 0.0
	spawnCool.reset()
	totalReps = 0
	_emitted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnCool = TimedCount.new(data.spawnCooldown)

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	if not active: return
	if data.repetitions > 0 and totalReps >= data.repetitions:
		emit_finished_once()
		return
	time += delta
	if spawnCool.isReady():
		spawnCool.reset()
		for i in range(data.arms):
			var angle = deg_to_rad(data.deltaAngle) * totalReps
			var initRad = deg_to_rad(data.initialAngle)
			var dir = Vector3(
				cos(TAU/data.arms * i + angle + initRad),
				0.0,
				sin(TAU/data.arms * i + angle + initRad),
				)
			spawnProjectile(global_position, dir)
		totalReps += 1
	if data.lifetime > 0 and time >= data.lifetime:
		emit_finished_once()
