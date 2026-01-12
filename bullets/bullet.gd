class_name Bullet extends Node3D

@export var speed : float = 1.0
@export var direction : Vector3 = Vector3(1.0, 0.0, 0.0)
@export var damage : float = 1.0
@export var maxLifeTime : float = 5.0
@export var textureOverride : Texture2D = null

var lifetime : float = 0.0
var originator : Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if textureOverride: $Sprite3D.texture = textureOverride
	$AttackArea.initialize(damage, originator)
	$DamageArea.area_entered.connect(_onDamageAreaEntered)


func _physics_process(delta: float) -> void:
	lifetime += delta
	if lifetime != 0.0 and lifetime >= maxLifeTime:
		queue_free()
	position += speed * direction * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _onDamageAreaEntered(area : Area3D) -> void:
	if "ATTACKAREA" in area and area.originator != self:
		queue_free()
