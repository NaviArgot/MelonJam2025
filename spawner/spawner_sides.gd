class_name SpawnerSides
extends ProjectileSpawner

@export var bulletCooldown : float = 0.1
@export var amplitude : float = 0.0

var time : float = 0.0
var spawnCool: TimedCount
var prevPos: Vector3 = Vector3(0.0, 0.0, 0.0)
var forward: Vector3 = Vector3.FORWARD

func computeForward():
	if global_position.distance_squared_to(prevPos) < 0.1: return
	forward = global_position - prevPos
	prevPos = global_position
	forward = forward.normalized()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		var theta = atan2(forward.z, forward.x)
		var dir = Vector3(cos(theta + rad), 0.0, sin(theta + rad))
		spawnProjectile(
			global_position,
			Vector3(
				cos(theta + rad),
				0.0,
				sin(theta + rad)
			)
		)
		spawnProjectile(
			global_position,
			Vector3(
				cos(theta - rad),
				0.0,
				sin(theta - rad)
			)
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
