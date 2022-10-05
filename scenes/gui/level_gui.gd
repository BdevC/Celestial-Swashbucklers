extends Control

#signals for GUI
signal end_of_level()

signal player_lost(hit_count)

#signals for game
signal restart_level()



func _on_level_end_body_entered(body):
	if (body.is_in_group("Player")):
		emit_signal("end_of_level", body.hitCount)
		print("displaying restart page")


func _on_you_win_yes():
	reset()
	emit_signal("restart_level")


func _on_you_win_no():
	emit_signal("end_of_level")



func _on_main_decrementPlayerHealth():
	$healthbar.value -= 1		# TODO reference object in main instead of using the UI as datastore


func _on_healthbar_value_changed(value):
	print("new health value: ",value)
	if (value <= 0):
		emit_signal("player_lost", value)
	pass # Replace with function body.


func _on_you_lose_yes():
	reset()
	emit_signal("restart_level")

func reset():
	$healthbar.value = $healthbar.max_value


func _on_playerShip_update_ammo_count(count):
	$ammoCountLabel/ammoCountNumber.text = String(count)

