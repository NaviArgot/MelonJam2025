class_name BossJoy extends CharacterBody3D

signal half_life
signal death

enum STATE {IDLE, BASE, ATTACK1, ATTACK2}

@export var speed : float = 1.0
@export var maxHealth : float = 50.0 

var health: float = 0.0
var zigzagPos : Array[Vector3] = []
var lapsPos : Array[Vector3] = []

func getPlayerDir():
	var playerPos = PlayerManager.getPosition()
	return -(global_position - playerPos).normalized()

func takeDamage(damage: float):
	health -= damage

func init(zigzag: Array[Vector3], laps: Array[Vector3]):
	zigzagPos = zigzag
	lapsPos = laps

func start():
	$RopeAttack.active = true

func _ready() -> void:
	health = maxHealth
	$DamageArea.area_entered.connect(_onDamageAreaEntered)
	
func _physics_process(delta: float) -> void:
	if health <= maxHealth/2:
		half_life.emit()
	
	if health <= 0.0:
		death.emit()
	move_and_slide()

func _onDamageAreaEntered(area: Area3D) -> void:
	if "ATTACKAREA" in area:
		if area.originator != self:
			takeDamage(area.damage)
