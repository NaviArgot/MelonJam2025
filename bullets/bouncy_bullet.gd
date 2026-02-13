class_name BouncyBullet
extends Node3D

var pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var dir: Vector3 = Vector3.FORWARD
var speed: float = 1.0
var damage : float = 1.0
var maxLifeTime : float = 5.0
var textureOverride : Texture2D = null

var lifetime : float = 0.0
var originator : Node3D = null

var deathCallback: Callable = func () : queue_free()

var neotime : float = 0.0

func init(
	originator_: Node3D,
	pos_: Vector3,
	dir_: Vector3,
	speed_: float,
	damage_: float,
	lifetime_: float,
	deathCallback_: Callable = func (): return
	):
		pos = pos_
		damage = damage_
		maxLifeTime = lifetime_
		deathCallback = deathCallback_
		originator = originator_
		dir = dir_
		speed = speed_

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updatePos()
	if textureOverride: $Sprite3D.texture = textureOverride
	$AttackArea.initialize(damage, originator)
	$DamageArea.area_entered.connect(_onDamageAreaEntered)
	#$WallCollision.body_entered.connect(_onWallEntered)

func updatePos():
	position = pos + dir * speed * (lifetime - neotime)

func _physics_process(delta: float) -> void:
	lifetime += delta
	updatePos()
	
	var space_state = get_world_3d().direct_space_state
	var origin : Vector3 = global_position
	var end : Vector3 = origin + dir * speed * delta
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.collision_mask = 0b1

	var result = space_state.intersect_ray(query)
	if result:
		neotime = lifetime
		dir = (end - origin).bounce(result.normal).normalized()
		pos = global_position
	if lifetime != 0.0 and lifetime >= maxLifeTime:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _onDamageAreaEntered(area : Area3D) -> void:
	if "ATTACKAREA" in area and area.originator != self:
		queue_free()
