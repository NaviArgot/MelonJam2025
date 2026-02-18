class_name SpawnerArea
extends ProjectileSpawner

@export var data : SpawnerAreaData

var time : float = 0.0
var aabb : AABB
var collisionMesh : TriangleMesh
var spawnCool: TimedCount

var _tool_mesh : MeshInstance3D

func isInside(point : Vector3) -> bool:
	var result := collisionMesh.intersect_ray(
		point, Vector3(0.0, 0.0, 0.0)
		)
	return result.is_empty()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnCool = TimedCount.new(data.spawnCooldown)
	aabb = data.area.get_aabb()
	collisionMesh = data.area.generate_triangle_mesh()

func _physics_process(delta: float) -> void:
	spawnCool.update(delta)
	if not active: return
	time += delta
	if spawnCool.isReady():
		spawnCool.reset()
		var spawned : bool = false
		for i in range(5):
			var pos = Vector3(
				randf_range(aabb.position.x, aabb.end.x),
				randf_range(aabb.position.y, aabb.end.y),
				randf_range(aabb.position.z, aabb.end.z)
				)
			if isInside(pos):
				spawnProjectile(
					pos + global_position,
					data.direction
					)
				spawned = true
				break
		if not spawned:
			spawnProjectile(aabb.get_center(), data.direction)
	if data.lifetime > 0.0 and time >= data.lifetime:
		emit_finished_once()
