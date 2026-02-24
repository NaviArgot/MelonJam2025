class_name BossSad extends CharacterBody3D

signal rain_attack_start
signal rain_attack_finished
signal wave_attack_start
signal wave_attack_finished
signal tunneling_attack_start
signal tunneling_attack_trigger (x: float, z: float)
signal tunneling_attack_finished
signal half_life
signal death

enum STATE {IDLE, BASE, ATTACK1, ATTACK2}

@export var speed : float = 1.0
@export var maxHealth : float = 50.0 

var health: float = 0.0

var rainTween : Tween
var waveTween : Tween

func getScene():
	return get_tree().root.get_children()[-1]

func startAttackRain(center: Vector3, radius: float, laps : int):
	if rainTween: return
	rainTween = create_tween()
	rainTween.tween_property(self, "position", center, 1.0)
	rainTween.tween_property(self, "position", _circle(0.0, center, radius), 1.0)
	rainTween.tween_callback(func (): rain_attack_start.emit())
	rainTween.tween_method(_moveCircle.bind(center, radius), 0.0, 2.0, 10.0)
	rainTween.tween_callback(
		func ():
			rainTween = null
			rain_attack_finished.emit()
	)
	
func startAttackWave(pos: Vector3, duration: float):
	if waveTween: return
	waveTween = create_tween()
	waveTween.tween_property(self, "position", pos, 1.0)
	waveTween.tween_callback(func (): wave_attack_start.emit())
	waveTween.tween_interval(duration)
	waveTween.tween_callback(
		func ():
			waveTween = null
			wave_attack_finished.emit()
	)

func startAttackTunneling(start: Vector3, end: Vector3, cooldown: float):
	pass


func _moveCircle(weight: float, center: Vector3, radius: float):
	position = _circle(weight, center, radius)

func _circle(weight: float, center: Vector3, radius: float) -> Vector3:
	var newpos := Vector3.ZERO
	newpos.x = cos(weight * TAU) * radius
	newpos.z = sin(weight * TAU) * radius
	return newpos + center

func start():
	startAttackRain(Vector3(0.0, 2.0, -14.5), 5.0, 1)

func getPlayerDir():
	var playerPos = PlayerManager.getPosition()
	return -(global_position - playerPos).normalized()

func takeDamage(damage: float):
	health -= damage


func _ready() -> void:
	health = maxHealth
	$DamageArea.area_entered.connect(_onDamageAreaEntered)
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity = get_gravity() * delta
	
	$Label3D.text = "HP: %d"%[health]
	
	if health <= maxHealth/2:
		half_life.emit()
	
	if health <= 0.0:
		death.emit()
	move_and_slide()

func _onDamageAreaEntered(area: Area3D) -> void:
	if "ATTACKAREA" in area:
		if area.originator != self:
			takeDamage(area.damage)
