extends Spatial

export (PackedScene) var projectile

export var fire_speed = 6000
var is_catchable:bool = false

func shoot(linearVelocity):
	$fire_sound.play()
	var new_projectile = projectile.instance()
	new_projectile.global_transform = $muzzle.global_transform
	new_projectile.speed = fire_speed
	new_projectile.linear_velocity = linearVelocity
	if is_catchable:
		new_projectile.contact_monitor = true
		new_projectile.contacts_reported = 1
	var scene_root = get_tree().get_root().get_children()[0]		#TODO update
	scene_root.add_child(new_projectile)
	pass


func _on_fire_order_received(linearVelocity, is_catchable):
	self.is_catchable = is_catchable
	shoot(linearVelocity)
	
