extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal restart_game()

# Called when the node enters the scene tree for the first time.
func _ready():
	$exit.connect("pressed", self, "handle_exit")
	$replay.connect("pressed", self, "handle_restart")
	pass # Replace with function body.

func handle_exit():
	get_tree().quit()

func handle_restart():
	emit_signal("restart_game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
