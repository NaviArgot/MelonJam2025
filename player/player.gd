class_name Player
extends CharacterBody3D

var weaponScenes : Array[PackedScene] = [
	preload("res://weapons/sword.tscn"),
	preload("res://weapons/slingshot.tscn")
]

enum STATE {IDLE, WALKING, ATTACKING}
enum TURNING {LEFT, RIGHT}

@export var maxSpeed: float = 1.0

var maxHealth : float = 10.0
var health : float

var facing: Vector3 = Vector3(0.0, 0.0, -1.0)
var state: STATE = STATE.IDLE
var sprites: Array[Sprite3D] = []
var weapons : Array[Weapon] = []
var currWeapon : int  = 0
var onScene : bool = false

func receiveInput () -> void:
	if Input.is_action_pressed("attack"):
		weapons[currWeapon].enableWeapon(facing)
	else:
		weapons[currWeapon].disableWeapon()
	if Input.is_action_just_pressed("weapon_change"):
		weapons[currWeapon].disableWeapon()
		currWeapon = (currWeapon + 1) % weapons.size()
	if Input.is_action_just_pressed("roll"):
		DialogueSystem.showDialogues([
			"Hello",
			"This is the dialogue system",
			"There are multiple dialogues"
		])

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

func takeDamage(damage : float):
	health -= damage
	# TODO show animation or particles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	onScene = true
	health = maxHealth
	for child in $Animations.get_children():
		if child.is_class("Sprite3D"):
			sprites.append(child)
	for scene in weaponScenes:
		var weapon = scene.instantiate()
		weapon.scale = Vector3(0.6, 0.6, 0.6)
		weapon.distance = 0.8
		add_child(weapon)
		weapons.append(weapon)
	$DamageArea.area_entered.connect(_onDamageAreaEntered)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
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
	
	# TODO Death state
	$Label3D.text = "HP: %d"%[health]
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
	
