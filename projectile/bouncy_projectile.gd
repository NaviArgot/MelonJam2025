class_name BouncyProjectile
extends Projectile

var _neotime : float = 0.0

func _quatRotate(pos : Vector3):
	var point = Quaternion(pos.x, pos.y, pos.z, 0)
	var rotated = quatRot.inverse() * point * quatRot
	var end = Vector3(rotated.x, rotated.y, rotated.z)
	return end * Vector3(1.0, -1.0, -1.0)


func _physics_process(delta: float) -> void:
	_time += delta
	_updatePos(_time - _neotime)
	
	var space_state = get_world_3d().direct_space_state
	var start : Vector3 = global_position
	var disp = _quatRotate(data.movement.getPosition(_time - _neotime + delta))
	var end : Vector3 = origin + disp
	var query = PhysicsRayQueryParameters3D.create(start, end)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.collision_mask = 0b10000

	var result = space_state.intersect_ray(query)
	if result:
		_neotime = _time
		origin = global_position
		var dir = (end - origin).bounce(result.normal).normalized()
		faceTowards(dir)
	if data.lifetime > 0.0 and _time >= data.lifetime:
		queue_free()
