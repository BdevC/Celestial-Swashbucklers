extends Control

signal end_of_level()

func _on_ShipFollow_end_level():
	emit_signal("end_of_level")


