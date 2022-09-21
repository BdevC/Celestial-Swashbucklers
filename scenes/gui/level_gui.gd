extends Control

#signals for GUI
signal end_of_level()

#signals for game
signal restart_level()



func _on_level_end_body_entered(body):
	if (body.is_in_group("Player")):
		emit_signal("end_of_level", body.hitCount)
		print("displaying restart page")


func _on_you_win_yes():
	emit_signal("restart_level")


func _on_you_win_no():
	emit_signal("end_of_level")

