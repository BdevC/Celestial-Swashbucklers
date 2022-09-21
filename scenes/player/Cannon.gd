extends Spatial

export (PackedScene) var projectile

export var fire_speed = 30


func shoot():
	var new_projectile = projectile.instance()
	new_projectile.global_transform = $muzzle.global_transform
	new_projectile.speed = fire_speed
	var scene_root = get_tree().get_root().get_children()[0]		#TODO update
	scene_root.add_child(new_projectile)
	pass


func _on_playerShip_fire_left():
	shoot()
	pass # Replace with function body.


func _on_playerShip_fire_right():
	shoot()
	pass # Replace with function body.
