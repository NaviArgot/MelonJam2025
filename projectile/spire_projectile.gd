class_name SpireProjectile
extends Projectile

var tween : Tween
var deathTween : Tween
var deathAnimCalled : bool = false

func resize(weight: float, height: float) -> void:
	$Mesh.mesh.height = height * weight
	$AttackArea/Shape.shape.height = height * weight
	$Mesh.position.y = weight * height / 2
	$AttackArea.position.y = weight * height / 2

func animate() -> void:
	tween = create_tween()
	tween.tween_method(
		resize.bind(data.height),
		0.0,
		1.0,
		data.lifetime * data.animProportion
	)

func deathAnim() -> void:
	deathAnimCalled = false
	deathTween = create_tween()
	deathTween.tween_property($Mesh, "mesh:top_radius", 0.0, 0.2)
	deathTween.parallel().tween_property($Mesh, "mesh:bottom_radius", 0.0, 0.2)
	deathTween.tween_callback(func(): queue_free())

func _setInitialVals() -> void:
	$Mesh.mesh.top_radius = data.radius
	$Mesh.mesh.bottom_radius = data.radius
	$AttackArea/Shape.shape.radius = data.radius * 0.9
	$Mesh.set_instance_shader_parameter("ColorParameter", data.color)

func _ready() -> void:
	_setInitialVals()
	faceTowards(moveDirection)
	_updatePos(0.0)
	attackArea.initialize(data.damage, originator)
	animate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_time += delta
	_updatePos(_time)
	if data.lifetime > 0.0 and _time >= data.lifetime and not deathAnimCalled:
		deathAnim()
