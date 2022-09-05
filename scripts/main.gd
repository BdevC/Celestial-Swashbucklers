# main.gd
extends Node
func _ready():
	add_child(Game.MyScene.instance())
