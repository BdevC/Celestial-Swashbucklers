extends Control

#signals for GUI
signal end_of_level()

signal player_lost(hit_count)

#signals for game
signal restart_level()

signal togglePause()
signal start_approach_music(stage)

signal restart_game()

signal deploy_fleet()

func _on_level_end_body_entered(body):
	if (body.is_in_group("Player")):
		emit_signal("end_of_level", body.hitCount)
		print("displaying restart page")


func _on_you_win_yes():
	emit_signal("restart_level")


func _on_you_win_no():
	emit_signal("end_of_level")

func _on_you_lose_yes():
	emit_signal("restart_level")

func _on_playerShip_update_ammo_count(count):
	$ammoCountLabel/ammoCountNumber.text = String(count)

func  _on_health_updated(value):
	if (value <= 0):
		emit_signal("player_lost", value)
		display_end_screen()

func _unhandled_input(event):
	match event.get_class():
		"InputEventKey":
			if Input.is_action_just_pressed("ExitMenu"):
				$PauseMenu.show()
				$open_menu.play()
				emit_signal("togglePause")
				print("Escape Pressed")
				t.stop()

const RESUME:int = 2
func _on_PauseMenu_index_pressed(index):
	print("pauseIndex: ",index)
	if(index == RESUME):
		$close_menu.play()
		emit_signal("togglePause")
		if minutes != 0 && seconds != 0:
			t.start()
	else:
		get_tree().quit()

func _on_boost_updated(value):
	print("new boost count: ", value)

func _ready():
	$instruction_timer.connect("timeout",self,"show_instructions")
#	$introduction.connect("confirmed",self,"hide_instructions")
	t.set_wait_time(1)  # set time here
	t.set_one_shot(false)
	self.add_child(t)
	t.connect("timeout", self, "update_fleet_clock" )
	update_fleet_clock()
	get_node("/root/main/main/end_level").connect("body_entered",self,"handle_end_of_level")
	$end_of_level.connect("restart_game",self,"handle_restart")
	$introduction/Label/Button.connect("pressed", self, "hide_instructions")

func handle_restart():
	emit_signal("restart_game")

func handle_end_of_level(body):
	if is_showing_instructions && body.is_in_group("Player"):
		display_end_screen()

func display_end_screen():
	print("showing eol popup")
	emit_signal("togglePause")
	get_tree().paused = true
	$end_of_level/eol_music.play()
	$end_of_level/score/value.text = str(get_node("/root/main/main").score)
	$end_of_level/treasure/value.text = str(get_node("/root/main/main").treasure)
	$end_of_level.show()


var t = Timer.new()
var minutes:int = 4
var seconds:int = 01

func update_fleet_clock():
	seconds = seconds - 1
	if seconds < 0:
		seconds = 59
		minutes = minutes - 1
	if seconds < 10:
		$fleet_timer.text = "fleet arrives: " + str(minutes) + ":0" + str(seconds)
	else:
		$fleet_timer.text = "fleet arrives: " + str(minutes) + ":" + str(seconds)
	
	if minutes < 1 && seconds < 6:
		if seconds % 2 == 0:
			$count_even.play()
		else:
			$count_odd.play()
	if minutes == 0 && seconds == 0:
		t.stop()
		emit_signal("deploy_fleet")
		# ALERT THE PLAYER THE FLEET HAS ARRIVED


var is_showing_instructions:bool = false

func show_instructions():
	is_showing_instructions = true
	$open_menu.play()
	$introduction.show()
	$introduction/voiceover.play()
	emit_signal("togglePause")
	t.stop()

func hide_instructions():
	$close_menu.play()
	$introduction.hide()
	emit_signal("togglePause")
	emit_signal("start_approach_music", 1)
	t.start()
