class_name BS_ImplosionLine extends BulletSpawner

const projectile = preload("res://bullets/implosion_spire.tscn")

@export var angle : float = 0.0
@export var offsetForward : float = 0.4
@export var bulletLifetime : float = 1.0
@export var bulletCooldown : float = 0.1
@export var distance : float = 4.0

var row : int = 0
var time : float = 0.0
var spawnCool: TimedCount
var prevPos: Vector3 = Vector3(0.0, 0.0, 0.0)
var forward: Vector3 = Vector3.FORWARD

func _spawnAttack():
	if row * offsetForward > distance: return
	var attack : ImplosionSpire = projectile.instantiate()
	var rad = deg_to_rad(angle)
	var pos = Vector3(
		row * offsetForward * sin(rad),
		0.0,
		row * offsetForward * cos(rad)
	)
	attack.init(
		originator,
		pos + global_position,
		5.0,
		bulletLifetime,
		)
	row += 1
	getScene().add_child(attack)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnCool = TimedCount.new(bulletCooldown)
	prevPos = global_position

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	time += delta
	if not active: return
	if spawnCool.isReady():
		spawnCool.reset()
		_spawnAttack()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
