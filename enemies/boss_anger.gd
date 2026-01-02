class_name BossAnger extends CharacterBody3D

signal half_life
signal death

enum STATE {IDLE, BASE, ATTACK1, ATTACK2}

@export var speed : float = 1.0
@export var rammingSpeed : float = 5.0
@export var maxHealth : float = 50.0 

var health: float = 0.0

var bulletScene = preload("res://bullets/bullet.tscn")

var count = 0.0
var state : STATE = STATE.IDLE

var proximityRecharge := TimedCount.new(2.0)
var proximityBulletCD := TimedCount.new(0.2)
var baseBulletCooldown := TimedCount.new(0.8)
var ramCooldown := TimedCount.new(10.0)

func getScene():
	return get_tree().root.get_children()[-1]

func start():
	state = STATE.BASE

func getPlayerDir():
	var playerPos = PlayerManager.getPosition()
	return -(global_position - playerPos).normalized()

func ramPlayer():
	velocity = getPlayerDir() * rammingSpeed

func takeDamage(damage: float):
	health -= damage

func spawnBulletCircle(amount: int, angle: float, speed: float):
	for i in range(amount):
		var dir = Vector3(0.0, 0.0, 0.0)
		dir.x = cos(TAU/amount * i + angle)
		dir.y = 0.0
		dir.z = sin(TAU/amount * i + angle)
		var bullet : Bullet = bulletScene.instantiate()
		bullet.direction = dir
		bullet.position = global_position
		bullet.speed = speed
		bullet.damage = 1.0
		bullet.maxLifeTime = 5.0
		bullet.originator = self
		getScene().add_child(bullet)
		
func finishAttack2():
	await get_tree().create_timer(2).timeout
	state = STATE.BASE

func spawnCircle():
	pass
	
func baseState(delta : float):
	velocity = getPlayerDir() * speed
	velocity += get_gravity()
	if baseBulletCooldown.isReady():
		baseBulletCooldown.reset()
		var angle = atan2(velocity.y, velocity.x)
		spawnBulletCircle(3, angle, 5.0)
	if (PlayerManager.getPosition() - global_position)\
		.length_squared() < 4 and proximityRecharge.isReady():
		proximityRecharge.reset()
		state = STATE.ATTACK2
		finishAttack2()
	if ramCooldown.isReady() and randf() > 0.5:
		ramCooldown.reset()
		state = STATE.ATTACK1
		endRamming()

func attack2():
	if proximityBulletCD.isReady():
		proximityBulletCD.reset()
		spawnBulletCircle(8, 0.0, 10.0)

func _ready() -> void:
	health = maxHealth
	$AttackArea.initialize(5.0, self)
	$DamageArea.area_entered.connect(_onDamageAreaEntered)

func endRamming():
	await get_tree().create_timer(1.0).timeout
	state = STATE.BASE
	
	
func _physics_process(delta: float) -> void:
		
	match state:
		STATE.IDLE:
			pass
		STATE.BASE:
			baseState(delta)
		STATE.ATTACK1:
			ramPlayer()
		STATE.ATTACK2:
			attack2()
	
	$Label3D.text = "HP: %d"%[health]
	
	if state == STATE.ATTACK1:
		$AttackArea.monitorable = true
	else:
		$AttackArea.monitorable = false
	
	baseBulletCooldown.update(delta)
	ramCooldown.update(delta)
	proximityBulletCD.update(delta)
	
	if health <= maxHealth/2:
		half_life.emit()
	
	if health <= 0.0:
		death.emit()
	move_and_slide()

func _onDamageAreaEntered(area: Area3D) -> void:
	if "ATTACKAREA" in area:
		if area.originator != self:
			takeDamage(area.damage)
