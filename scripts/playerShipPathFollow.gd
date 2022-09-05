extends PathFollow

func _process(delta):
	offset += 0.2
	print(self.rotation)
	get_tree().call_group("actionAreaVars", "y_rotation_update", rotation.y)



