class_name Sword extends Weapon

@export var usageTime : float = 0.1
@export var cooldownTime : float = 0.1

var enabled: bool = false

var usageTimer : SceneTreeTimer = null
var cooldownTimer : SceneTreeTimer = null

func faceTowards (direction: Vector3) -> void:
	position = (direction * distance)
	$Pivot/Mesh.rotation.y = -atan2(direction.z, direction.x) + deg_to_rad(angle)

func enableWeapon() -> void:
	if usageTimer or cooldownTimer: return
	usageTimer = get_tree().create_timer(usageTime)
	enabled = true
	$AudioStreamPlayer.play()
	await usageTimer.timeout
	enabled = false
	usageTimer = null
	cooldownTimer = get_tree().create_timer(cooldownTime)
	await  cooldownTimer.timeout
	cooldownTimer = null
	

func disableWeapon() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled = false
	$AttackArea.initialize(damage, originator)
	$AttackArea.body_entered.connect(_on_body_entered)
	$AttackArea.area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	if enabled:
		visible = true
		$AttackArea/Collision.disabled = false
	else:
		visible = false
		$AttackArea/Collision.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body : Node) -> void:
	return

func _on_area_entered(area : Area3D) -> void:
	return
