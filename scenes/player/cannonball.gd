extends RigidBody

#var target: Spatial
#var cannon: KinematicBody
export var speed:float = 2000.0

#func _ready():
#	var orient = global_transform.basis.z.normalized()
#	orient.x = 1
#	#orient = orient.rotated(Vector3.UP, cannon.rotation.y).normalized()
#	orient.x = orient.x * speed
#	orient.z = orient.z * speed
#	add_central_force(orient)

func _ready():
	var forward_direction = global_transform.basis.z.normalized()
	add_central_force(forward_direction * speed)

#func _physics_process(delta):
#	var forward_direction = global_transform.basis.z.normalized()
#	add_central_force(forward_direction * speed * delta)
#	global_translate(forward_direction * speed * delta)

#func _physics_process(delta):
#	add_central_force(Vector3(0,5000,0))


#func _onfire():
##	look_at(target.get_global_transform().origin, Vector3.UP)
##	add_central_force(Vector3(0,0,-500))
#	print("shooting ball")


#func look_follow(state, current_transform, target_position):
#	var up_dir = Vector3(0, 1, 0)
#	var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
#	var target_dir = (target_position - current_transform.origin).normalized()
#	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
#
#	state.set_angular_velocity(up_dir * (rotation_angle / state.get_step()))
#
#func _integrate_forces(state):
#	if (target != null):
#		var target_position = target.get_global_transform().origin
#		look_follow(state, get_global_transform(), target_position)



func _on_Timer_timeout():
	print("free ball")
	queue_free()
