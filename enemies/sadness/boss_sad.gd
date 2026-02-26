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
var tunnelingTween : Tween

var _halfEmitted : bool = false
var _deatEmitted : bool = false

func getScene():
	return get_tree().root.get_children()[-1]

func startAttackRain(center: Vector3, radius: float, laps : int):
	if rainTween: return
	var begin := randf()
	var end := begin + laps
	rainTween = create_tween()
	rainTween.tween_property(self, "position", _circle(begin, center, radius), 1.0)
	rainTween.tween_callback(func (): rain_attack_start.emit())
	rainTween.tween_method(_moveCircle.bind(center, radius), begin, end, laps * 5.0)
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

func startAttackTunneling(start_: Vector3, end_: Vector3, cooldown: float, reps: int):
	if tunnelingTween: return
	tunnelingTween = create_tween()
	tunnelingTween.tween_callback(
		func ():
			tunneling_attack_start.emit()
			$AnimationPlayer.play("dig")
	)
	tunnelingTween.tween_interval(1.2)
	for i in range(reps):
		tunnelingTween.tween_callback(
			func ():
				position.x = randf_range(start_.x, end_.x)
				position.z = randf_range(start_.z, end_.z)
				tunneling_attack_trigger.emit(position.x, position.z)
		)
		tunnelingTween.tween_interval(3.0)
		tunnelingTween.tween_interval(cooldown)
	tunnelingTween.tween_callback(
		func ():
			position.x = randf_range(start_.x, end_.x)
			position.z = randf_range(start_.z, end_.z)
			$AnimationPlayer.play("undig")
	)
	tunnelingTween.tween_interval(1.0)
	tunnelingTween.tween_callback(
		func ():
			tunnelingTween = null
			$AnimationPlayer.play("RESET")
			tunneling_attack_finished.emit()
	)

func _moveCircle(weight: float, center: Vector3, radius: float):
	position = _circle(weight, center, radius)

func _circle(weight: float, center: Vector3, radius: float) -> Vector3:
	var newpos := Vector3.ZERO
	newpos.x = cos(weight * TAU) * radius
	newpos.z = sin(weight * TAU) * radius
	return newpos + center

func start():
	while true:
		print("WAVE ATTACK")
		startAttackWave(Vector3(0.0, 2.0, -14.5), 8)
		await wave_attack_finished
		await get_tree().create_timer(4.0).timeout
		print("TUNNELING ATTACK")
		startAttackTunneling(
			Vector3(-10, 0, -19.5),
			Vector3(10, 0, -9.5),
			1.0,
			5
		)
		await tunneling_attack_finished
		await get_tree().create_timer(2.0).timeout
		print("RAIN")
		startAttackRain(Vector3(0.0, 2.0, -14.5), 5.0, 3)
		await rain_attack_finished

func getPlayerDir():
	var playerPos = PlayerManager.getPosition()
	return -(global_position - playerPos).normalized()

func takeDamage(damage: float):
	health -= damage


func _ready() -> void:
	health = maxHealth
	$DamageArea.area_entered.connect(_onDamageAreaEntered)
	
func _physics_process(delta: float) -> void:
	#if not is_on_fwloor():
		#velocity = get_gravity() * delta
	
	$Label3D.text = "HP: %d"%[health]
	
	if health <= maxHealth/2:
		if not _halfEmitted:
			half_life.emit()
			_halfEmitted = true
	
	if health <= 0.0 and not _deatEmitted:
		death.emit()
		_deatEmitted = true

func _onDamageAreaEntered(area: Area3D) -> void:
	if "ATTACKAREA" in area:
		if area.originator != self:
			takeDamage(area.damage)
