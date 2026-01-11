class_name Player
extends CharacterBody3D

var weaponScenes : Dictionary[String, PackedScene] = {
	"noodle_sword": preload("res://weapons/sword.tscn"),
	"slingshot": preload("res://weapons/slingshot.tscn")
}

enum STATE {IDLE, WALKING, ATTACKING}
enum TURNING {LEFT, RIGHT}

@export var maxSpeed: float = 1.0

var maxHealth : float = 10.0
var health : float

var facing: Vector3 = Vector3(0.0, 0.0, -1.0)
var state: STATE = STATE.IDLE
var sprites: Array[Sprite3D] = []
var weapons : Array[Weapon] = []
var weaponNames : Array[String] = []
var currWeapon : int  = 0
var onScene : bool = false
var executingDying : bool  =false

func receiveInput () -> void:
	if Input.is_action_pressed("attack"):
		weapons[currWeapon].enableWeapon(facing)
	else:
		weapons[currWeapon].disableWeapon()
	if Input.is_action_just_pressed("weapon_change"):
		weapons[currWeapon].disableWeapon()
		currWeapon = (currWeapon + 1) % weapons.size()
		PlayerManager.currWeapon = currWeapon
		Hud.setWeapon(weaponNames[currWeapon])
		

func computeFacingTarget() -> void:
	var mousePos = get_viewport().get_mouse_position()
	var center = get_viewport().get_visible_rect().size/2
	var target = mousePos - center
	facing.x = target.x
	facing.y = 0.0
	facing.z = target.y
	facing = facing.normalized()


func enableAnim(animation: String) -> void:
	if $AnimationPlayer.current_animation != animation:
		for sprite in sprites:
			sprite.visible = false
	$AnimationPlayer.play(animation)

func showDamageAnim():
	var sprite : Sprite3D
	match state:
		STATE.IDLE:
			sprite = $Animations/Idle
		STATE.WALKING:
			sprite = $Animations/Run
		_ : 
			sprite = $Animations/Idle
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.2)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)

func takeDamage(damage : float):
	health -= damage
	Hud.setHealth(health)
	showDamageAnim()
	if $Damage.finished:
		$Damage.play()


func selfDestruction() :
	if executingDying: return
	executingDying = true
	Transitions.fadeOut()
	await  Transitions.transition_finished
	get_tree().change_scene_to_file("res://levels/protoscene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currWeapon = PlayerManager.currWeapon
	onScene = true
	health = PlayerManager.maxHealth
	for child in $Animations.get_children():
		if child.is_class("Sprite3D"):
			sprites.append(child)
	for key in weaponScenes:
		var weapon = weaponScenes[key].instantiate()
		weapon.scale = Vector3(0.6, 0.6, 0.6)
		weapon.distance = 0.8
		weapon.originator = self
		add_child(weapon)
		weapons.append(weapon)
		weaponNames.append(key)
	Hud.setWeapon(weaponNames[currWeapon])
	Hud.setHealth(health)
	$DamageArea.area_entered.connect(_onDamageAreaEntered)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$Jump.play()
		velocity.y = 5

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		state = STATE.WALKING
		velocity.x = direction.x * maxSpeed
		velocity.z = direction.z * maxSpeed
	else:
		state = STATE.IDLE
		velocity.x = move_toward(velocity.x, 0, maxSpeed)
		velocity.z = move_toward(velocity.z, 0, maxSpeed)
	
	# Decide where the sprite will be facing based on velocity
	if velocity.x < -0.1:
		$Animations.rotation.y = PI
	elif velocity.x > 0.1:
		$Animations.rotation.y = 0.0
	
	if health <= 0.0:
		selfDestruction()
	
	match state:
		STATE.IDLE:
			enableAnim("idle")
		STATE.WALKING:
			enableAnim("run")
	computeFacingTarget()
	receiveInput()
	move_and_slide()
	if onScene:
		PlayerManager.setPosition(global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _onDamageAreaEntered(area : Area3D) -> void:
	if "ATTACKAREA" in area and area.originator != self:
		takeDamage(area.damage)
	
