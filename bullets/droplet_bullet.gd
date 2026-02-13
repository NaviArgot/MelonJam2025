class_name DropletBullet extends Bullet

func getScene() -> Node:
	return get_tree().root.get_children()[-1]

func _physics_process(delta: float) -> void:
	lifetime += delta
	updatePos()
	if lifetime != 0.0 and lifetime >= maxLifeTime:
		_spawn()
		queue_free()

func _onBodyEntered (body : Node3D):
	_spawn()


func _spawn():
	print("MIAU")
	var spawner = BS_Ring.new()
	spawner.global_position = global_position
	spawner.process_mode =Node.PROCESS_MODE_ALWAYS
	spawner.active = true
	spawner.movementFunc = MovementFactory.sinoidal.bind(4.0, 3.0)
	spawner.repetitions = 10
	spawner.spawnCooldown = 0.2
	spawner.arms = 8
	getScene().add_child(spawner)
