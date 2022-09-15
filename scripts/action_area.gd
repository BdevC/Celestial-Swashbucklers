extends Spatial

var _path_follow: PathFollow

var attack_craft = preload("res://scenes/enemies/craft_miner.tscn")

func _on_ship_attack_area_body_exited(body):
	print("sending attack wave")
	$attack_path.add_child(attack_craft.instance())
