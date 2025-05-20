extends RigidBody

signal boss_defeated()
var player_ship

var health:int = 10


func _ready():
	player_ship = get_node("/root/main/main/playerShip")
	connect("body_entered",self,"handle_body_entered")
	connect("boss_defeated", get_node("/root/main/main"), "handle_boss_defeated")

func handle_body_entered(body):
	print("something hit the boss")
	if body.is_in_group("playerAmmo"):
		print("it was player ammo")
		health = health - 1
		print("boss_health: ", health)
	if health == 0: 
		emit_signal("boss_defeated")
		queue_free()

func look_follow(state, current_transform, target_position):
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)

	state.set_angular_velocity(up_dir * (rotation_angle / state.get_step()))

func _integrate_forces(state):
	var target_position = player_ship.get_global_transform().origin
	look_follow(state, get_global_transform(), target_position)

var blue_lazer = preload("res://scenes/items/blue_lazer.tscn")
var lazer_force = 100

func _physics_process(delta):
	if (global_transform.origin.y < 3):
		axis_lock_linear_y = true
	if $fire_timer.is_stopped() && global_transform.origin.distance_to(player_ship.global_transform.origin) < 300:
		print("firing_lazer")
		$fire_timer.start(3)
		var lazer = blue_lazer.instance()
		lazer.global_transform = global_transform
		var player_correction:Vector3 = Vector3(0,5,0)
		var player_position:Vector3 = player_ship.global_transform.origin + player_correction
		var direction:Vector3 = player_position - global_transform.origin
		lazer.l_direction = direction 
		lazer.l_force = lazer_force
		get_node("/root/main/main").add_child(lazer)
		$firing.play()
	if !$firing.playing && !$charging.playing && global_transform.origin.distance_to(player_ship.global_transform.origin) < 300:
		$charging.play()

