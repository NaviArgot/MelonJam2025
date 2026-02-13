class_name BossMirror extends CharacterBody3D

signal attack_finished
signal half_life
signal death

enum STATE {IDLE, BASE, ATTACK1, ATTACK2}

@export var speed : float = 1.0
@export var maxHealth : float = 50.0 

var health: float = 0.0
var zigzagPos : Array[Vector3] = []
var lapsPos : Array[Vector3] = []
var ropePos: Vector3 = Vector3(0.0, 0.0, 0.0)

var ropeTween : Tween = null
var zigzagTween : Tween = null
var lapsTween : Tween = null

func init(
		rope: Vector3,
		zigzag: Array[Vector3],
		laps: Array[Vector3]
	):
	ropePos = rope
	zigzagPos = zigzag
	lapsPos = laps

func getPlayerDir():
	var playerPos = PlayerManager.getPosition()
	return -(global_position - playerPos).normalized()

func takeDamage(damage: float):
	health -= damage

func startRopeAttack():
	if ropeTween: return
	ropeTween = create_tween()
	ropeTween.tween_property(self, "position", ropePos, 1.0)
	ropeTween.tween_callback(func (): $RopeAttack.active = true)
	ropeTween.tween_interval(15.0)
	ropeTween.tween_callback(
		func ():
			$RopeAttack.active = false
			ropeTween = null
			attack_finished.emit()
	)

func startZigzagAttack():
	if zigzagTween or zigzagPos.size() == 0: return
	zigzagTween = create_tween()
	zigzagTween.tween_property(self, "position", zigzagPos[0], 1.0)
	zigzagTween.tween_callback(func (): $BS_Sides.active = true)
	for i in range(1, zigzagPos.size()):
		zigzagTween.tween_callback(func (): $BS_Sides.active = true)
		zigzagTween.tween_property(self, "position", zigzagPos[i], 2.0)
		zigzagTween.tween_callback(func (): $BS_Sides.active = false)
		zigzagTween.tween_interval(3.0)
	zigzagTween.tween_callback(
		func ():
			zigzagTween = null
			attack_finished.emit()
	)

func startLapsAttack():
	if lapsTween or lapsPos.size() == 0: return
	lapsTween = create_tween()
	lapsTween.tween_property(self, "position", lapsPos[0], 1.0)
	lapsTween.tween_callback(func (): $BS_Directed.active = true)
	for i in range(1, lapsPos.size() * 4):
		lapsTween.tween_property(self, "position", lapsPos[i % lapsPos.size()], 2.0)
	lapsTween.tween_callback(
		func ():
			$BS_Directed.active = false
			lapsTween = null
			attack_finished.emit()
	)
	
func start():
	while true:
		startRopeAttack()
		await  attack_finished
		startZigzagAttack()
		await  attack_finished
		startLapsAttack()
		await  attack_finished

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
