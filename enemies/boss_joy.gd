class_name BossJoy extends CharacterBody3D

signal half_life
signal death

enum STATE {IDLE, BASE, ATTACK1, ATTACK2}

@export var speed : float = 1.0
@export var maxHealth : float = 50.0 

var health: float = 0.0

var bulletScene = preload("res://bullets/bullet.tscn")

var state : STATE = STATE.IDLE
var isAttacking : bool = false

var coolChangeTarget = TimedCount.new(2.5)
var coolBaseBullet = TimedCount.new(1.5)
var coolSelection = TimedCount.new(15.0)

func getScene():
	return get_tree().root.get_children()[-1]

func start():
	state = STATE.BASE

func getPlayerDir():
	var playerPos = PlayerManager.getPosition()
	return -(global_position - playerPos).normalized()

func takeDamage(damage: float):
	health -= damage

func spawnBulletDirected(angle : float, offset: float, speed_ : float):
	var dir = Vector3(0.0, 0.0, 0.0)
	dir.x = cos(angle+ offset)
	dir.y = 0.0
	dir.z = sin(angle+ offset)
	var bullet : Bullet = bulletScene.instantiate()
	bullet.direction = dir
	bullet.position = global_position
	bullet.speed = speed_
	bullet.damage = 1.0
	bullet.maxLifeTime = 5.0
	bullet.originator = self
	getScene().add_child(bullet)

func spawnBulletCircle(amount: int, angle: float, speed_: float):
	for i in range(amount):
		var dir = Vector3(0.0, 0.0, 0.0)
		dir.x = cos(TAU/amount * i + angle)
		dir.y = 0.0
		dir.z = sin(TAU/amount * i + angle)
		var bullet : Bullet = bulletScene.instantiate()
		bullet.direction = dir
		bullet.position = global_position
		bullet.speed = speed_
		bullet.damage = 1.0
		bullet.maxLifeTime = 5.0
		bullet.originator = self
		getScene().add_child(bullet)

func base():
	if coolChangeTarget.isReady():
		coolChangeTarget.reset()
		velocity = getPlayerDir() * speed
	if coolBaseBullet.isReady():
		coolBaseBullet.reset()
		for i in range(5):
			spawnBulletCircle(6, 0.0,  3.5 + (2.0/5.0) * i)
	if not isAttacking and coolSelection.isReady():
		coolSelection.reset()
		if randf() > 0.7:
			#state = STATE.ATTACK1
			attack1()
		else:
			#state = STATE.ATTACK2
			attack2()

func attack1():
	if isAttacking: return
	state = STATE.ATTACK1
	isAttacking = true
	velocity = Vector3(0.0, 0.0, 0.0)
	var nBullets = 100
	await get_tree().create_timer(1.0).timeout
	for i in range(nBullets):
		spawnBulletCircle(4, (TAU/nBullets) * i, 6.0)
		await get_tree().create_timer(0.06).timeout
	isAttacking = false
	state = STATE.BASE

func attack2():
	if isAttacking: return
	state = STATE.ATTACK2
	velocity = Vector3(0.0, 0.0, 0.0)
	isAttacking = true
	var target = getPlayerDir()
	var playerAngle = atan2(target.z, target.x)
	var nBullets = 10
	var amplitude = PI/2
	await get_tree().create_timer(0.5).timeout
	for i in range(nBullets):
		for j in range(i/2):
			spawnBulletDirected(playerAngle, (amplitude/nBullets) * j, 6.0)
		for j in range(i/2):
			spawnBulletDirected(playerAngle, -(amplitude/nBullets) * j, 6.0)
		await get_tree().create_timer(0.2).timeout
	isAttacking = false
	state = STATE.BASE
	

func _ready() -> void:
	health = maxHealth
	$DamageArea.area_entered.connect(_onDamageAreaEntered)
	coolSelection.reset()
	
func _physics_process(delta: float) -> void:
	#velocity = get_gravity() * delta
	match state:
		STATE.IDLE:
			pass
		STATE.BASE:
			base()
		STATE.ATTACK1:
			pass
			#attack1()
		STATE.ATTACK2:
			pass
			#attack2()
	
	$Label3D.text = "HP: %d"%[health]
	
	coolChangeTarget.update(delta)
	coolBaseBullet.update(delta)
	if not isAttacking:
		coolSelection.update(delta)
	
	if health <= maxHealth/2:
		half_life.emit()
	
	if health <= 0.0:
		death.emit()
	move_and_slide()

func _onDamageAreaEntered(area: Area3D) -> void:
	if "ATTACKAREA" in area:
		if area.originator != self:
			takeDamage(area.damage)
