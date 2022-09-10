# main.gd
extends Node
func _ready():
	add_child(Game.levelzero.instance())
