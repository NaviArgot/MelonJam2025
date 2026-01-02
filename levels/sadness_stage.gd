extends Node3D

enum STATE {BEFORE, START, HALF, END}
var state = STATE.BEFORE

var bgIntro =preload("res://assets/realmusics/sadness.wav")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transitions.fadeIn()
	$BattleStart.body_entered.connect(_on_body_entered)
	$Boss.half_life.connect(_on_half_life)
	$Boss.death.connect(_on_boss_death)
	pass # Replace with function body.

func playMusic():
	await DialogueSystem.dialogue_finished
	GlobalAudio.playMusic(bgIntro)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func battleStart():
	DialogueSystem.showDialogueCharacter(
		[
			"…What the hell are you?",
			"I’m... I’m nothing *sniff*",
			"Why are you crying? You’re so annoying.",
			"It’s been so long since I’m locked in this room",
			"*sniff*... Let me make you feel my sadness.",
			"Wait… Wait!!!",
		],
		[
			"player",
			"sadness",
			"player",
			"sadness",
			"sadness",
			"player"
		]
	)
	playMusic()
	$Boss.start()
	state = STATE.START

func battleEnd():
	DialogueSystem.showDialogueCharacter(
		[
			"I lost… This is so sad…",
			"So you never stop crying? It’s so weird, it makes me want to hit you even more!",
			"That’s what they were telling you *sniff*",
			"So I stopped. They were right.",
			"They were wrong *sniff*... They were always wrong.",
			"But... But crying is for the weak!",
			"If you don’t want to cry… It’s because you are afraid to show how you feel *sniff*",
			"So who is the weak now?",
			"I’m... afraid? Refrain from crying makes me weak?",
			"Yes *sniff*, of course.",
		],
		[
			"sadness",
			"player",
			"sadness",
			"player",
			"sadness",
			"player",
			"sadness",
			"sadness",
			"player",
			"sadness",
		]
	)
	state = STATE.HALF

func middleFight() :
	DialogueSystem.showDialogueCharacter(
		[
			"Stop beating me, why are you doing that? Oh, I’m so sad…",
			"You’re… Sad?",
		],
		[
			"sadness",
			"player",
		]
	)
	state = STATE.HALF

func _on_body_entered(body : Node3D):
	if body.name == "Player" && state == STATE.BEFORE:
		battleStart()

func _on_half_life():
	if state == STATE.START:
		middleFight()

func _on_boss_death():
	battleEnd()
	PlayerManager.flags["ACCEPTED_SADNESS"] = true
	await DialogueSystem.dialogue_finished
	Transitions.fadeOut()
	$Boss.queue_free()
	await Transitions.transition_finished
	get_tree().change_scene_to_file("res://levels/protoscene.tscn")
