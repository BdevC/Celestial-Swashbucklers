extends Spatial

signal decrementPlayerHealth()

func _on_level_gui_restart_level():
	$playerShip.global_transform = $ShipStartPosition.global_transform
	$playerShip.reset()
	pass # Replace with function body.


func _on_playerShip_decrementHealth():
	emit_signal("decrementPlayerHealth")
