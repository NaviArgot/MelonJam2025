class_name Bullet extends Node3D

var pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var rot : Basis = Basis.IDENTITY
var damage : float = 1.0
var maxLifeTime : float = 5.0
var textureOverride : Texture2D = null

var lifetime : float = 0.0
var originator : Node3D = null

var moveFunc: Callable = func (time) : return Vector3(0.0, 0.0, 0.0)
var deathCallback: Callable = func () : queue_free()

func init(
	originator_: Node3D,
	pos_: Vector3,
	rot_: Basis,
	damage_: float,
	lifetime_: float,
	moveFunc_: Callable,
	deathCallback_: Callable = func (): return
	):
		pos = pos_
		rot = rot_
		damage = damage_
		maxLifeTime = lifetime_
		moveFunc = moveFunc_
		deathCallback = deathCallback_
		originator = originator_

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updatePos()
	if textureOverride: $Sprite3D.texture = textureOverride
	$AttackArea.initialize(damage, originator)
	$DamageArea.area_entered.connect(_onDamageAreaEntered)

func updatePos():
	position = pos + rot * moveFunc.call(lifetime)

func _physics_process(delta: float) -> void:
	lifetime += delta
	updatePos()
	if lifetime != 0.0 and lifetime >= maxLifeTime:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _onDamageAreaEntered(area : Area3D) -> void:
	if "ATTACKAREA" in area and area.originator != self:
		queue_free()
