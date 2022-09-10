extends PopupPanel



func _on_YES_button_up():
	$Label2.text = "YES PRESSED"


func _on_NO_button_up():
	$Label2.text = "NO PRESSED"


func _on_level_gui_end_of_level():
	self.show()
