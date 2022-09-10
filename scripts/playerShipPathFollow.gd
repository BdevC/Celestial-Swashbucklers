extends PathFollow

export var level_progress:float = 0.4
export var level_end:float = 1.0

signal end_level()

func _process(delta):
	offset += level_progress
	
	if (unit_offset >= level_end): # && !main.has_node("YouWin")):
		emit_signal("end_level")
	
	get_tree().call_group("actionAreaVars", "y_rotation_update", rotation.y)



