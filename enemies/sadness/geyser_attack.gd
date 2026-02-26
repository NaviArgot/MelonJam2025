extends Node3D

signal finished

@export var damageSpire : float
@export var damageBullets : float

func play():
	$AnimationPlayer.play("attack")

func reset():
	$SpawnerRing.reset()
	$SpireSpawn.reset()
	$SpawnerRing.active = false
	$SpireSpawn.active = false
	$AnimationPlayer.play("RESET")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpireSpawn.projectileData.damage = damageSpire
	$SpawnerRing.projectileData.damage = damageBullets
	$SpireSpawn.finished.connect(_on_finish.bind($SpireSpawn))
	$SpawnerRing.finished.connect(_on_finish.bind($SpawnerRing))
	$AnimationPlayer.animation_finished.connect(_on_anim_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_finish(spawner : ProjectileSpawner):
	spawner.active = false

func _on_anim_finished(anim_name):
	finished.emit()
