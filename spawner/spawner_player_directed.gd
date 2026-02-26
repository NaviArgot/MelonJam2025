class_name SpawnerPlayerDirected
extends ProjectileSpawner

@export var data : SpawnerPlayerDirectedData

var time : float = 0.0
var spawnCool: TimedCount
var prevPos: Vector3 = Vector3(0.0, 0.0, 0.0)
var forward: Vector3 = Vector3.FORWARD

func reset() -> void:
	time = 0.0
	spawnCool.reset()
	_emitted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnCool = TimedCount.new(data.bulletCooldown)

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	if not active: return
	time += delta
	if spawnCool.isReady():
		spawnCool.reset()
		var dir: Vector3 = (PlayerManager.getPosition() - global_position).normalized()
		dir.y = 0.0
		spawnProjectile(global_position, dir)
	if data.lifetime > 0.0 and time >= data.lifetime:
		emit_finished_once()
