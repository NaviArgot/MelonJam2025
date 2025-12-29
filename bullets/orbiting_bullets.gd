class_name OrbitingBullets extends Node3D

var amount : int = 1
var bullets : Array[Bullet] = []
var velocity : Vector3 = Vector3(0.0, 0.0, 0.0)
var dispersion : float = 0.0
var radius : float = 0.0
var angle : float = 0.0
var angularVelocity : float = 0.0

func setBulletPlace(bullet : Bullet, index : int) -> void:
	var pos = global_position
	var newpos = Vector3(0.0, 0.0, 0.0)
	newpos.x = cos(TAU/amount * index + angle) * radius
	newpos.z = sin(TAU/amount * index + angle) * radius
	bullet.position = pos + newpos

func initialize(
	spawner_ : Callable,
	amount_ : int,
	velocity_ : Vector3,
	dispersion_ : float,
	radius_ : float,
	angle_ : float,
	angularVelocity_ : float
) -> void:
	for i in range(amount_):
		var bullet = BulletManager.spawnBullet(spawner_)
		bullet.lifetime = 0.0
		bullets.append(bullet)
	amount = amount_ 
	velocity = velocity_
	radius = radius_
	dispersion = dispersion_
	angle = angle_
	angularVelocity = angularVelocity_
		

func _physics_process(delta: float) -> void:
	position += velocity * delta
	radius += dispersion * delta
	angle += angularVelocity * delta
	for i in range(bullets.size()):
		setBulletPlace(bullets[i], i)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
