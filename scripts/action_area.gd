extends Spatial

var _path_follow: PathFollow

var attack_craft = preload("res://scenes/enemies/craft_miner.tscn")

func _ready():
	$attack_path.add_child(attack_craft.instance())
