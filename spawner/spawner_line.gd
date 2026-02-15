class_name SpawnerConsecutiveLine
extends ProjectileSpawner

@export var spawnCooldown : float = 0.1
@export var distance : float = 1.0
@export var lineAngle : float = 0.0
@export var gapLength : float = 0.1
@export var initialShotAngle : float = 0.0
@export var shotAngleDelta : float = 0.0
@export var repeat : bool = true

var _spawnCool: TimedCount
var _currBullet: int = 0
var _maxBullets: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawnCool = TimedCount.new(spawnCooldown)
	_maxBullets = int(distance/gapLength) + 1

func _physics_process(delta: float) -> void:
	_spawnCool.update(delta)
	if not active: return
	if repeat and _currBullet >= _maxBullets:
		_currBullet = 0
	if _spawnCool.isReady() and _currBullet < _maxBullets:
		_spawnCool.reset()
		var pos := Vector3(
			(gapLength * _currBullet) * cos(deg_to_rad(lineAngle)),
			0.0,
			(gapLength * _currBullet) * sin(deg_to_rad(lineAngle))
		) + global_position
		var shotAngle := deg_to_rad(
			 lineAngle + initialShotAngle + _currBullet * shotAngleDelta
			)
		var dir := Vector3(
			cos(shotAngle),
			0.0,
			sin(shotAngle)
		)
		spawnProjectile(pos, dir)
		_currBullet += 1
