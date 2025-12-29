extends Node

func playMusic(song : AudioStream):
	stop()
	$AudioLoop.set_stream(song)
	$AudioLoop.play()

func playMusicWithLoop(intro : AudioStream, loop : AudioStream):
	stop()
	$AudioIntro.set_stream(intro)
	$AudioLoop.set_stream(loop)
	$AudioIntro.play()
	await  $AudioIntro.finished
	$AudioLoop.play()

func stop() :
	$AudioIntro.stop()
	$AudioLoop.stop()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
