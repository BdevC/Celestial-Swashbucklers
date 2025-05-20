extends Spatial

signal decrementPlayerHealth()
signal restart_game()

var RamShipsEncountered:int = 0
var RamShipsDodged:int = 0
var EnemiesDestroyed:int = 0
var RamShipList:PoolIntArray=PoolIntArray()
var treasure:int = 0
var score:int = 0

func _on_level_gui_restart_level():
	$playerShip.global_transform = $ShipStartPosition.global_transform
	$playerShip.reset()
	pass # Replace with function body.


func _on_playerShip_decrementHealth():
	emit_signal("decrementPlayerHealth")

func _on_level_gui_togglePause():
	get_tree().paused = !get_tree().paused
	pass # Replace with function body.

func _on_RamShip_created(bodyID):
	RamShipsEncountered += 1
	RamShipsDodged += 1
	RamShipList.append(bodyID)
	print("adding ID: ",bodyID)

func _on_RamShip_Collide(bodyID):
	var idx=RamShipList.find(bodyID)
	if (idx != -1):
		print("removing ID: ",bodyID)
		RamShipsDodged = RamShipsDodged - 1
		RamShipList.remove(idx)
	print("Ramship Hit. ships dodged: ",RamShipsDodged)

func _on_ramship_shot_down(bodyID):
	EnemiesDestroyed += 1
	print("shot down: ", EnemiesDestroyed, " Enemies")

func _handle_coin_pickup(worth):
	$coin_pickup.play()
	treasure = treasure + worth
	score += worth
	$level_gui/score_treasure/treasure/Label.text = str(treasure)
	$level_gui/score_treasure/score/Label.text = str(score)

func _handle_bonus_area():
	score = score + 25
	$level_gui/score_treasure/score/Label.text = str(score)
	print("bonus area gives score")

var is_first_boss:bool = true

func handle_boss_defeated():
	if is_first_boss:
		is_first_boss = false
		$back_to_gate.play()
	score += 500

func _ready():
	$level_gui.connect("start_approach_music", self, "music_manager")
	$enter_boss_area.connect("body_entered", self, "haldle_boss_area")
	$level_gui.connect("restart_game",self,"handle_restart")
	$level_gui.connect("deploy_fleet", self, "handle_fleet_arrival")
	$playerShip.connect("generatorExited",self,"_on_RamShip_created")

func handle_fleet_arrival():
	var fleet = $spawn_fleet.get_children()
	var capital_ship
	for ship in fleet:
		capital_ship = preload("res://scenes/enemies/boss.tscn").instance()
		capital_ship.global_transform = ship.global_transform
		capital_ship.connect("boss_defeated",self,"_handle_boss_defeated")
		add_child(capital_ship)
	$landed_ship.queue_free()
	$playerShip.spawn_fighters = true
	music_manager(3)
	

func handle_restart():
	emit_signal("restart_game")
	get_tree().paused = true

var boss = preload("res://scenes/enemies/boss.tscn")
var create_one:bool = false

func haldle_boss_area(body):
	print("body detected:")
	if body.is_in_group("Player"):
		var b_rotation:Vector3 = body.global_rotation
		print("rotation: ",b_rotation)
		if b_rotation.y > deg2rad(-170) && b_rotation.y < deg2rad(-10):
			#headed to boss
			if (!create_one):
				create_one = true
				music_manager(2)
				boss = boss.instance()
				boss.global_transform = $boss_spawn_location.global_transform
				boss.connect("boss_defeated",self,"_handle_boss_defeated")
				add_child(boss)
#		elif b_rotation.y < deg2rad(170) && b_rotation.y > deg2rad(10):
#			#headed away from the boss 
#			music_manager(3)
#		else:
#			print("doing nothing")

var treasure_box = preload("res://scenes/items/chest.tscn")

func _handle_boss_defeated():
	score += 100
	$level_gui/score_treasure/score/Label.text = str(score)
	var box 
	var treasures = $spawn_treasure.get_children()
	for t in treasures:
		box = treasure_box.instance()
		box.global_transform = t.global_transform
		add_child(box)

func music_manager(stage):
	match stage:
		1 :
			$approach.play()
			$boss.stop()
			$escape.stop()
		2 :
			$boss.play()
			$approach.stop()
			$escape.stop()
		3 :
			$escape.play()
			$approach.stop()
			$boss.stop()
