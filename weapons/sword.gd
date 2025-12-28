class_name Sword extends Weapon

var enabled: bool = false


func enableWeapon(facing : Vector3) -> void:
	faceTowards(facing)
	enabled = true

func disableWeapon() -> void:
	enabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled = false
	$AttackArea.initialize(5.0, self)
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
