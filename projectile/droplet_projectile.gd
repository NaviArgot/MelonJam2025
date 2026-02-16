class_name DropletProjectile
extends Projectile

@export var visuals : Node3D
@export var spawner : ProjectileSpawner

enum STATES {MOVING, COLLIDED}
var _state : STATES = STATES.MOVING

func _ready() -> void:
	super._ready()
	spawner.active = false
	spawner.finished.connect(func (): queue_free())

func _enable_spawner():
	spawner.active = true
	_state = STATES.COLLIDED
	attackArea.monitorable = false
	attackArea.monitoring = false
	damageArea.monitorable = false
	visuals.visible = false

func _moving_process(delta: float):
	_time += delta
	_updatePos(_time)
	
	var space_state = get_world_3d().direct_space_state
	var start : Vector3 = global_position
	var disp = initialRotation * data.movement.getPosition(_time + delta)
	var end : Vector3 = origin + disp
	var query = PhysicsRayQueryParameters3D.create(start, end)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.collision_mask = 0b1

	var result = space_state.intersect_ray(query)
	if result:
		_enable_spawner()
	if data.lifetime > 0.0 and _time >= data.lifetime:
		queue_free()

func _physics_process(delta: float) -> void:
	match _state:
		STATES.MOVING:
			_moving_process(delta)
		STATES.COLLIDED:
			pass
