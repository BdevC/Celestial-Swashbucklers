extends Area

signal generatorExited(body,id)

export (PackedScene) var ship
export var waveSpeed:float = 500
export var wave_max_speed:float = 25

var starting_locations=[]

func _ready():
	starting_locations.push_back($wave_start)
	starting_locations.push_back($wave_start2)
	starting_locations.push_back($wave_start3)
	starting_locations.push_back($wave_start4)
	self.connect("generatorExited",get_node("/root/main/main"),"_on_RamShip_created")
	

func makeattack(player):
	var new_ship
	var scene_root = get_tree().get_root().get_children()[0]		#TODO update
	for s in starting_locations:
		new_ship = ship.instance()
		new_ship.global_transform = s.global_transform
		new_ship.attack_speed = waveSpeed
		new_ship.max_speed = wave_max_speed
		new_ship.target = player
		emit_signal("generatorExited", new_ship.get_instance_id() )
		scene_root.add_child(new_ship)
	queue_free()

func _on_attack_wave_generator_body_exited(body):
	if (body.is_in_group("Player")):
#		print ("yep, it's the player ship")
		makeattack(body)
		pass
#	print ("not player ship")
	pass # Replace with function body.
