class_name SpawnerPlayerDirected
extends ProjectileSpawner

@export var bulletCooldown : float = 0.1

var time : float = 0.0
var spawnCool: TimedCount
var prevPos: Vector3 = Vector3(0.0, 0.0, 0.0)
var forward: Vector3 = Vector3.FORWARD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnCool = TimedCount.new(bulletCooldown)

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	time += delta
	if not active: return
	if spawnCool.isReady():
		spawnCool.reset()
		var dir: Vector3 = (PlayerManager.getPosition() - global_position).normalized()
		dir.y = 0.0
		spawnProjectile(global_position, dir)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
