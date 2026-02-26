class_name SpawnerConsecutiveLine
extends ProjectileSpawner

@export var data : SpawnerLineData

var _spawnCool: TimedCount
var _currBullet: int = 0
var _maxBullets: int
var _time : float = 0.0

func reset() -> void:
	_time = 0.0
	_spawnCool.reset()
	_currBullet = 0
	_emitted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawnCool = TimedCount.new(data.spawnCooldown)
	_maxBullets = int(data.distance/data.gapLength) + 1
	reset()

func _physics_process(delta: float) -> void:
	_spawnCool.update(delta)
	if not active: return
	_time += delta
	if _currBullet >= _maxBullets:
		if data.repeat: _currBullet = 0
		else: emit_finished_once()
	if _spawnCool.isReady() and _currBullet < _maxBullets:
		_spawnCool.reset()
		var pos := Vector3(
			(data.gapLength * _currBullet) * cos(deg_to_rad(data.lineAngle)),
			0.0,
			(data.gapLength * _currBullet) * sin(deg_to_rad(data.lineAngle))
		) + global_position
		var shotAngle := deg_to_rad(
			 data.lineAngle + data.initialShotAngle + _currBullet * data.shotAngleDelta
			)
		var dir := Vector3(
			cos(shotAngle),
			0.0,
			sin(shotAngle)
		)
		spawnProjectile(pos, dir)
		_currBullet += 1
	if data.lifetime > 0.0 and _time >= data.lifetime:
		emit_finished_once()
