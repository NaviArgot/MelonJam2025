extends Control

@export var weapons : Dictionary[String, Texture] = {}

var defaultWeaponTex = preload("res://assets/textures/hud/weapon_default.png")

func setHealth(value: float):
	var percent: float = value / PlayerManager.maxHealth * 100
	$HealthBar.value = percent
	

func setWeapon(type: String):
	if not type in weapons:
		$WeaponFrame/Weapon.texture = defaultWeaponTex
	else:
		$WeaponFrame/Weapon.texture = weapons[type]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WeaponFrame/Weapon.texture_filter = TEXTURE_FILTER_NEAREST
	$WeaponFrame/Weapon.texture = defaultWeaponTex


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
