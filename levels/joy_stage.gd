extends Node3D

enum STATE {BEFORE, START, HALF, END}
var state = STATE.BEFORE

var bgIntro =preload("res://assets/realmusics/joy intro.wav")
var bgLoop =preload("res://assets/realmusics/joy loop.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transitions.fadeIn()
	$BattleStart.body_entered.connect(_on_body_entered)
	$Boss.half_life.connect(_on_half_life)
	$Boss.death.connect(_on_boss_death)
	pass # Replace with function body.

func playMusic():
	GlobalAudio.playMusicWithLoop(bgIntro, bgLoop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func battleStart():
	DialogueSystem.showDialogueCharacter(
		[
			"This is terrifying.",
			"Hellooo my friend! You’re the one who locked me here, you don’t remember?",
			"Why are you so shocked?",
			"I have never seen you before.",
			"Haaa indeed it’s been so long my friend... I guess it’s time for you to go anyway!",
			"Let’s play a bit before I kill you! It will be so much fun!!",
			"Wait... Wait!!!"
		],
		[
			"player",
			"joy",
			"joy",
			"player",
			"joy",
			"joy",
			"player"
		]
	)
	await DialogueSystem.dialogue_finished
	playMusic()
	$Boss.start()
	state = STATE.START

func battleEnd():
	DialogueSystem.showDialogueCharacter(
		[
			"Haha... Hahaha... You did it...",
			"If you were locked, why are you always so happy?",
			"There’s no happiness in living in a hellhole like this.",
			"My friend... You will always find happiness... ",
			"Everywhere... You just need... To accept being happy... Hahahahaha!",
			"No... There is no happiness. You’re useless.",
			"You still believe this after all these years my friend?",
			"You had a hard time dealing with your childhood, I know it.",
			"How-",
			"But you don’t have... to mutilate your happiness...",
			"for people that aren’t even here anymore!",
			"Smile my friend... it’s over! Life is great!",
			"Life is... Great?",
			"Yes! Hahahahaha!"
		],
		[
			"joy",
			"player",
			"player",
			"joy",
			"joy",
			"player",
			"joy",
			"joy",
			"player",
			"joy",
			"joy",
			"joy",
			"player",
			"joy"
		]
	)
	state = STATE.HALF

func middleFight() :
	DialogueSystem.showDialogueCharacter(
		[
			"So you’re able to fight my friend! Oh, I’m so happy, I’m so happy!!",
			"You’re... Happy?",
		],
		[
			"joy",
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
	PlayerManager.flags["ACCEPTED_JOY"] = true
	await DialogueSystem.dialogue_finished
	Transitions.fadeOut()
	$Boss.queue_free()
	await Transitions.transition_finished
	get_tree().change_scene_to_file("res://levels/protoscene.tscn")
