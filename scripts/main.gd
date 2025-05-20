# main.gd
extends Node

var is_restarting:bool = false

func _ready():
	add_child(Game.levelzero.instance())
	get_node("/root/main/main").connect("restart_game", self, "handle_restart")

#func start_game():
#	add_child(Game.levelzero.instance())
#	get_node("/root/main/main").connect("restart_game", self, "handle_restart")

func handle_restart():
	is_restarting = true
	get_node("/root/main/main").queue_free()

func _physics_process(delta):
	if is_restarting:
		if get_child_count() > 0:
			print("waiting for queue")
		else:
			is_restarting = false
			get_tree().paused = false
			add_child(Game.levelzero.instance())
			get_node("/root/main/main").connect("restart_game", self, "handle_restart")
			
			
