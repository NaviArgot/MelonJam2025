class_name Player
extends CharacterBody3D

enum STATE {IDLE, WALKING, ATTACKING}
enum TURNING {LEFT, RIGHT}

@export var maxSpeed: float = 1.0

var facing: Vector3 = Vector3(0.0, 0.0, -1.0)
var speed: Vector3 = Vector3(0.0, 0.0, 0.0)
var state: STATE = STATE.IDLE
var sprites: Array[Sprite3D] = []

func receiveInput () -> void:
	speed.x = 0.0
	speed.z = 0.0
	state = STATE.IDLE
	if Input.is_action_pressed("up"):
		speed.z = -maxSpeed
	if Input.is_action_pressed("down"):
		speed.z = +maxSpeed
	if Input.is_action_pressed("right"):
		speed.x = maxSpeed
		$Animations.rotation.y = 0
	if Input.is_action_pressed("left"):
		speed.x = -maxSpeed
		$Animations.rotation.y = PI
	if speed.length_squared() > 0:
		state = STATE.WALKING
	if Input.is_action_pressed("attack"):
		$Weapon.attack(facing)
		state = STATE.ATTACKING
	else:
		$Weapon.disable()

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $Animations.get_children():
		if child.is_class("Sprite3D"):
			sprites.append(child)


func _physics_process(delta: float) -> void:
	match state:
		STATE.IDLE:
			enableAnim("idle")
		STATE.WALKING:
			enableAnim("run")
		STATE.ATTACKING:
			enableAnim("run")
	computeFacingTarget()
	receiveInput()
	move_and_collide(speed * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
