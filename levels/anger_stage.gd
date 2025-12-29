extends Node3D

enum STATE {BEFORE, START, HALF, END}
var state = STATE.BEFORE

var bgAnger = preload("res://assets/realmusics/anger.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transitions.fadeIn()
	$BattleStart.body_entered.connect(_on_body_entered)
	$Boss.half_life.connect(_on_half_life)
	$Boss.death.connect(_on_boss_death)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func playMusic() :
	await DialogueSystem.dialogue_finished
	GlobalAudio.playMusic(bgAnger)

func battleStart():
	DialogueSystem.showDialogueCharacter(
		[
			"FINALLY YOU BASTARD",
			"Hey, what? Why are you screaming?",
			"DON'T YOU SEE I'M ABOUT TO KILL YOU?",
			"Ok, let's talk about this first, there's no need to- Wait, wait!!!"
		],
		[
			"anger",
			"player",
			"anger",
			"player"
		]
	)
	playMusic()
	$Boss.start()
	state = STATE.START

func battleEnd():
	DialogueSystem.showDialogueCharacter(
		[
			"You piece of shit... I lost...",
			"You are finally calmed.. Now why were you so angry?",
			"Because I'm locked in this hellhole since you're a fucking child!",
			"And you shouldn’t go out. Anger is too dangerous.",
			"I DON’T CARE- *cough*... I have the right to go out, you can’t lock me here eternally!",
			"You never bring anything good outside! You’re a danger!",
			"You think I’m a danger for you… But I’m supposed to be a danger for everyone else.",
			"Don’t you see the problem you fucker?",
			"You don’t need to hide me, and if someone is beating you or insulting you again I’ll kill him!",
			"You’re defending me? Why?...",
			"I always tried… to protect you…"
		],
		[
			"anger",
			"player",
			"anger",
			"player",
			"anger",
			"player",
			"anger",
			"anger",
			"anger",
			"player",
			"anger",
		]
	)
	state = STATE.HALF

func middleFight() :
	DialogueSystem.showDialogueCharacter(
		[
			"FUCK THIS, WHY ARE YOU DEFENDING YOURSELF? OH I'M SO ANGRY!",
			"You're angry?",
		],
		[
			"anger",
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
	await DialogueSystem.dialogue_finished
	Transitions.fadeOut()
	$Boss.queue_free()
	await Transitions.transition_finished
	get_tree().change_scene_to_file("res://levels/protoscene.tscn")
