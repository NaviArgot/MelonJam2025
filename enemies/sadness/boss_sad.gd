class_name BossSad extends CharacterBody3D

signal half_life
signal death

enum STATE {IDLE, BASE, ATTACK1, ATTACK2}

@export var speed : float = 1.0
@export var maxHealth : float = 50.0 

var health: float = 0.0


func getScene():
	return get_tree().root.get_children()[-1]

func start():
	state = STATE.BASE

func getPlayerDir():
	var playerPos = PlayerManager.getPosition()
	return -(global_position - playerPos).normalized()

func takeDamage(damage: float):
	health -= damage


func _ready() -> void:
	health = maxHealth
	$DamageArea.area_entered.connect(_onDamageAreaEntered)
	coolSelection.reset()
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity = get_gravity() * delta
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
