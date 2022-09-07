extends PathFollow

func _process(delta):
	offset += 0.4
	get_tree().call_group("actionAreaVars", "y_rotation_update", rotation.y)



