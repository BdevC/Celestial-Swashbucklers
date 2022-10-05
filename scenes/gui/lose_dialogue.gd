extends PopupPanel

signal yes()

func _on_YES_button_up():
	emit_signal("yes")
	self.hide()
	print("YES PRESSED")


func _on_NO_button_up():
	get_tree().quit()
	print("NO PRESSED")


func _on_level_gui_player_lost(hit_count):
	$hitcountinfo.text = "You were hit " + String(8 - hit_count) + " times."	# super brittle - fix it.
	self.show()

