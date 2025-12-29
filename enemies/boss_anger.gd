class_name BossAnger extends CharacterBody3D

signal death

const RAM_SPEED = 5.0

var health: float = 10.0
var maxSpeed = 5.2

var count : float = 0.0
var bulletAngle : int = 0

var bulletScene = preload("res://bullets/bullet.tscn")

func ramPlayer():
	var playerPos = PlayerManager.getPosition()
	var dir = -(global_position - playerPos).normalized()
	velocity = dir * RAM_SPEED

func takeDamage(damage: float):
	health -= damage

func spawnBullets(amount : int, angle : float):
	for i in range(amount):
		var dir :=  Vector3(0.0, 0.0, 0.0)
		var bullet := bulletScene.instantiate()
		bullet.position = global_position
		bullet.position.y = PlayerManager.getPosition().y
		dir.x = cos(TAU/amount * i + angle)
		dir.z = sin(TAU/amount * i + angle)
		bullet.direction = dir
		bullet.speed = 3.0
		bullet.damage = 2.0
		bullet.originator = self
		get_tree().root.add_child(bullet)

func _ready() -> void:
	$DamageArea.area_entered.connect(_onDamageAreaEntered)

func _physics_process(delta: float) -> void:
	if randf() > 0.8:
		pass
		#ramPlayer()
	$Label3D.text = "HP: %d"%[health]
	
	count += delta
	bulletAngle = (bulletAngle + 1) % 100
	if count >= 0.5:
		count = 0.0
		spawnBullets(8, float(bulletAngle)/100 * TAU)
	
	if health < 0.0:
		death.emit()
	move_and_slide()

func _onDamageAreaEntered(area: Area3D) -> void:
	print(area)
	if "ATTACKAREA" in area:
		if area.originator != self:
			takeDamage(area.damage)
