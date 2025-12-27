extends CharacterBody3D

var health: float = 10.0
var maxSpeed = 5.2

var count : float = 0.0

var bulletScene = preload("res://bullet.tscn")

func takeDamage(damage: float):
	health -= damage

func spawnBullets(amount : int):
	for i in range(amount):
		var dir :=  Vector3(0.0, 0.0, 0.0)
		var bullet := bulletScene.instantiate()
		dir.x = cos(TAU/amount * i )
		dir.z = sin(TAU/amount * i )
		bullet.direction = dir
		bullet.speed = 3.0
		bullet.damage = 2.0
		bullet.originator = self
		add_child(bullet)

func _ready() -> void:
	$DamageArea.area_entered.connect(_onDamageAreaEntered)

func _physics_process(delta: float) -> void:
	$Label3D.text = "HP: %d"%[health]
	
	count += delta
	if count >= 3.0:
		count = 0.0
		spawnBullets(8)
	
	if health < 0.0:
		queue_free()
	move_and_slide()

func _onDamageAreaEntered(area: Area3D) -> void:
	if "ATTACKAREA" in area:
		if area.originator != self:
			takeDamage(area.damage)
		print("Momimi Entered: ", area.name)
