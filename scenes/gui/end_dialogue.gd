extends PopupPanel

signal yes()
signal no()

func _on_YES_button_up():
	emit_signal("yes")
	self.hide()
	print("YES PRESSED")


func _on_NO_button_up():
	get_tree().quit()
	print("NO PRESSED")


func _on_level_gui_end_of_level(hit_count):
	$hitcountinfo.text = "You were hit " + String(hit_count) + " times."
	self.show()
