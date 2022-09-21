extends Spatial

var _path_follow: PathFollow

var attack_craft = preload("res://scenes/enemies/craft_miner.tscn")
var cannon_ball = preload("res://scenes/player/cannonball.tscn")

func _on_ship_attack_area_body_exited(body):
	print("sending attack wave")
	$attack_path.add_child(attack_craft.instance())


func _physics_process(delta):
#	get_tree().call_group("actionAreaVars", "y_rotation_update", rotation.y)
	pass


#	var ball = cannon_ball.instance()
#	ball.translation = $"ship_dark_8angles2/cannon_left".translation
#	ball.target = $ship_dark_8angles2/cannon_left/LeftTarget
#	self.connect("fire_left",ball,"_onfire")
#	add_child(ball)
#	emit_signal("fire_left")
