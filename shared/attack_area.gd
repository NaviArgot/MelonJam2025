class_name AttackArea
extends Area3D

# A const for checking if it's an AttackArea and making my life easier
const ATTACKAREA: bool  = true


var damage: float = 0.0
var originator: Node = null

func initialize(damage_: float, originator_: Node) -> void:
	damage = damage_
	originator = originator_


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
