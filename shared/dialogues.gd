extends Control

signal receivedConfirmation
signal dialogue_finished

@export var characterColors : Dictionary[String, Color] = {}
var dialogueQueue : Array[String] = []
var enabled : bool = false
var cooldown : float = 0.1

func _activate() -> void:
	enabled = true
	visible = true
	get_tree().paused = true

func _deactivate() -> void:
	get_tree().paused = false
	visible = false
	enabled = false


func showDialogue(text : String, disableOnceFinished : bool) -> void:
	if not enabled:
		_activate()
	$DialogueBox/Label.text = text
	await get_tree().create_timer(cooldown).timeout
	await receivedConfirmation
	if disableOnceFinished:
		_deactivate()
	dialogue_finished.emit()

func showDialogues(script : Array[String]) -> void:
	if not enabled:
		_activate()
	#print("SHOWING STUFF")
	for text in script:
		$DialogueBox/MarginContainer/Label.text = text
		await get_tree().create_timer(cooldown).timeout
		await receivedConfirmation
	_deactivate()
	dialogue_finished.emit()

func showDialogueCharacter(
	script : Array[String],
	character : Array[String]
	) -> void:
	assert(script.size() == character.size(), "Arrays must be equal size")
	if not enabled:
		_activate()
	#print("SHOWING STUFF")
	for i in range(script.size()):
		var color = characterColors.get(character[i], Color(1.0, 1.0, 1.0, 1.0))
		$DialogueBox/MarginContainer/Label.label_settings.font_color = color
		$DialogueBox/MarginContainer/Label.text = script[i]
		await get_tree().create_timer(cooldown).timeout
		await receivedConfirmation
	$DialogueBox/MarginContainer/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
	_deactivate()
	dialogue_finished.emit()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("any") and enabled:
		receivedConfirmation.emit()
