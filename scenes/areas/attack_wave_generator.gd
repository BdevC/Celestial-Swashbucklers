extends Area

export (PackedScene) var ship
export var waveSpeed:float = 1500


func makeattack():
	var new_ship = ship.instance()
	new_ship.global_transform = $wave_start.global_transform
	new_ship.attack_speed = waveSpeed
	var scene_root = get_tree().get_root().get_children()[0]		#TODO update
	scene_root.add_child(new_ship)
	pass

func _on_attack_wave_generator_body_exited(body):
	print ("checking playership")
	if (body.is_in_group("Player")):
#		print ("yep, it's the player ship")
		makeattack()
		pass
#	print ("not player ship")
	pass # Replace with function body.
