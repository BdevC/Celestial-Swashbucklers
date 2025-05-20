extends RigidBody#KinematicBody

signal fire_left()
signal fire_right()
signal fire_forward()
signal fire_lost_ammo()
signal update_health(value)
signal update_ammo_count(count)
signal generatorExited(id)
#signal update_boost_count(value)
signal contact_obstacle(player_position)

# How fast the player moves in meters per second.
export var forward_speed = 20
export var lateral_speed = 30
#export var min_forward_speed = 1.5
export var min_movement_distance = 0.1
export var starting_health_count:int = 8
export var max_health:int = 12
export var max_ammo:int = 16
export var show_catch_ammo_times:int = 2

export var acceleration_rate:float = 300
export var acceleration_slowdown:float = 0.99 #should be < 1
export var MAX_LINEAR_VELOCITY:Vector3 = Vector3(1000,1000,1000)

export var roation_rate:float = 500
export var angular_velocity_slowdown:float = 0.9 #should be < 1
export var MAX_ANGULAR_VELOCITY:float = 1000

export var dodge_force:float = 30000
export var DODGE_TIME:float = 2.0
const DODGE_TIME_ROATION_WAIT:float = 0.5

export var dash_force:float = 30000
export var DASH_TIME:float = 2.0

export var max_boosts:int = 10
export var boost_count:int = 8

const health_capsule = preload("../scenes/items/health_capsule.tscn")
const ammo_capsule = preload("../scenes/items/ammo_capsule.tscn")
const boost_capsule = preload("../scenes/items/boost_capsule.tscn")


var show_catch_ammo_count:int = 0 
var ammoCount:int = 11
var health:int = starting_health_count
var health_capsules = []
var ammo_capsules = []
var boost_capsules = []
# The downward acceleration when in the air, in meters per second squared.
#export var fall_acceleration = 75
var hitCount = 0
var isPaused:bool = false

#var _path_follow: PathFollow
#action area information this could be written better
var _sceneRotation: float

func _ready():
	connect("update_health", get_node("/root/main/main/level_gui"), "_on_health_updated")
#	connect("update_boost_count", get_node("/root/main/main/level_gui"), "_on_boost_updated")
	emit_signal("update_health", health)
	emit_signal("update_ammo_count", ammoCount)
	connect("fire_left",get_node("port_cannon"), "_on_fire_order_received")
	connect("fire_lost_ammo",get_node("lost_ammo_cannon"), "_on_fire_order_received")
	connect("fire_forward",get_node("forward_cannon"), "_on_fire_order_received")
	connect("fire_right",get_node("starboard_cannon"), "_on_fire_order_received")
	$safeTimer.connect("timeout",self,"_respond_to_safeTimer")
	connect("body_entered", self,"_on_hit")
	build_health_indicator()
	build_ammo_indicator()
	build_boost_indicator()
	update_ammo_indicator()
	update_boost_indicator()
	update_health_indicator()
	connect("contact_obstacle", get_node("/root/main/main/obstacle_map"), "on_player_contact")
	linear_velocity_change -= global_transform.basis.z * 30000
	add_central_force(linear_velocity_change)

func build_health_indicator():
	var cap = health_capsule.instance()
	for i in max_health:
		$health_path/health_follow.unit_offset = (i * 1.0 ) / (max_health - 1)
		cap = health_capsule.instance()
		cap.translation = $health_path/health_follow.translation
		cap.rotation = $health_path/health_follow.rotation
		$health_path.add_child(cap)
		health_capsules.push_back(cap)

func build_ammo_indicator():
	var cap
	for i in max_ammo:
		$ammo_path/ammo_follow.unit_offset = (i * 1.0 ) / (max_ammo - 1)
		cap = ammo_capsule.instance()
		cap.translation = $ammo_path/ammo_follow.translation
		cap.rotation = $ammo_path/ammo_follow.rotation
		$ammo_path.add_child(cap)
		ammo_capsules.push_back(cap)

func build_boost_indicator():
	var cap
	for i in max_boosts:
		$boost_path/boost_follow.unit_offset = (i * 1.0 ) / (max_boosts - 1)
		cap = boost_capsule.instance()
		cap.translation = $boost_path/boost_follow.translation
		cap.rotation = $boost_path/boost_follow.rotation
		$boost_path.add_child(cap)
		boost_capsules.push_back(cap)


func _on_hit(body):
	#the player contected something.
	if body.is_in_group("attackCraft"):
		$player_hit.play()
		incrementHitCount()
		contact_attack_craft()
		$safeTimer.start(3)
	if body.is_in_group("obstacles"):
		$player_hit.play()
		incrementHitCount()
		contact_obstacle()
		emit_signal("contact_obstacle", global_translation)
		$safeTimer.start(3)
	if body.is_in_group("enemy_ammo"):
		incrementHitCount()
		contact_obstacle()
		$safeTimer.start(3)

func contact_attack_craft():
	if ($safeTimer.is_stopped()): #reset timer give user a chance to move away)
		print("new health value: ", health)
		health = health - 1
		update_health_indicator()
		emit_signal("update_health", health)

func contact_obstacle():
	if ($safeTimer.is_stopped()):
		health = health - 3
		update_health_indicator()
		emit_signal("update_health", health)

func update_health_indicator():
	for n in range(max_health-1,health-1,-1):
		health_capsules[n].visible = false
	if health >=0:
		for n in range (0, health, +1):
			health_capsules[n].visible = true

func update_ammo_indicator():
	for n in ammo_capsules:
		n.visible = false
	print("ammoCount: ", ammoCount)
	if ammoCount == max_ammo:
		for n in ammo_capsules:
			n.visible = true
	elif ammoCount >0:
		for n in range (0, ammoCount, +1):
			ammo_capsules[n].visible = true

func update_boost_indicator():
	print("boost_count: ",boost_count, "max_boosts: ",max_boosts)
	$use_boost.play()
	for n in range(max_boosts-1,boost_count-1,-1):
		boost_capsules[n].visible = false
	if boost_count >=0:
		for n in range (0, boost_count, +1):
			boost_capsules[n].visible = true

func y_rotation_update(rotation):
	_sceneRotation = rotation

func incrementHitCount():
	if ($safeTimer.is_stopped()):
		#tell system the ship has lost a hitpoint and start timer
		ammoCount = ammoCount - 1
		emit_signal("fire_lost_ammo", linear_velocity_change, true)
		update_ammo_indicator()
		emit_signal("update_ammo_count", ammoCount)
		if show_catch_ammo_count < show_catch_ammo_times :
			$catch_the_ammo_txt.visible = true
			show_catch_ammo_count += 1

func _respond_to_safeTimer():
	$catch_the_ammo_txt.visible = false

func _on_playerShip_body_entered(body):
	incrementHitCount()
	

# Called during every input event.
#func _unhandled_input(event):
#	match event.get_class():
#		"InputEventKey":
#			if Input.is_action_pressed("move_back"):
#				
#				print(get_process_delta_time())
const ROTATION_AMOUNT:float = 0.5
const POSITION_SPACE:int = 300

var positionIndex:int = POSITION_SPACE
var stoppingIndex:int = 0
var positionHistory:PoolVector3Array = PoolVector3Array()
var count:int = 0
var isTrackingCounts:bool = true
var lastPosition:Vector3 = Vector3.ZERO
var isBackTracking:bool = false
var linear_velocity_change:Vector3 = Vector3.ZERO
var angular_velocity_change:float = 0.0
var is_zero_rotation:bool = false
var is_zero_movement:bool = false
var is_dodging_right:bool = false
var is_dodging_left:bool = false
var is_dashing_forward:bool = false
var is_dashing_backward:bool = false

#func isShipMoving() -> bool:
#	if (isBackTracking):
#		return false
#	var xdist:float = abs(global_transform.origin.x - lastPosition.x)
#	var ydist:float = abs(global_transform.origin.z - lastPosition.z)
#	var flatDist = sqrt(pow(xdist,2) + pow(ydist,2))
#	lastPosition = global_transform.origin
#	if flatDist > min_movement_distance:
#		return true
#	else:
#		stoppingIndex = 0 if positionHistory.size() < POSITION_SPACE + 1 else positionIndex
#		isBackTracking = true
#		return false

#func updatePositionHistory():
#	if (positionHistory.size() < POSITION_SPACE + 1):
#		positionHistory.push_back(global_transform.origin)
#		positionIndex = positionHistory.size() -1
#	else:
#		positionHistory[positionIndex] = global_transform.origin
#		positionIndex += 1
#	if ( positionIndex >= POSITION_SPACE ) :
#		positionIndex = 0

#func backtrack():					# TODO: There is a bug in here somewhere.
#	positionIndex -= 1
#	if (positionIndex < 0):
#		positionIndex = POSITION_SPACE
#	if (positionIndex == stoppingIndex):
#		isBackTracking = false
#		return
#	global_transform.origin = positionHistory[positionIndex]

func _physics_process(delta):
	is_zero_rotation = false
	is_zero_movement = false
	if Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("modifier") && $dodge_timer.is_stopped() && boost_count > 0:
#			is_zero_rotation = false
			is_dodging_right = true
#		elif $dodge_timer.time_left < (DODGE_TIME - DODGE_TIME_ROATION_WAIT):
		else:
			linear_velocity_change += global_transform.basis.x * acceleration_rate
	if Input.is_action_pressed("move_left"):
		if Input.is_action_pressed("modifier") && $dodge_timer.is_stopped() && boost_count > 0:
#			is_zero_rotation = false
			is_dodging_left = true
#		elif $dodge_timer.time_left < (DODGE_TIME - DODGE_TIME_ROATION_WAIT):
		else:
			linear_velocity_change -= global_transform.basis.x * acceleration_rate

	if Input.is_action_pressed("rotate_right"):
		angular_velocity_change -= roation_rate
	if Input.is_action_pressed("rotate_left"):
		angular_velocity_change += roation_rate
	if !Input.is_action_pressed("rotate_right") && !Input.is_action_pressed("rotate_left"):
		is_zero_rotation = true

	if Input.is_action_pressed("move_forward"):
		if Input.is_action_pressed("modifier") && $dash_timer.is_stopped() && boost_count > 0:
			is_dashing_forward = true
#			is_zero_movement = false
		else: 
			linear_velocity_change += global_transform.basis.z * acceleration_rate
	if Input.is_action_pressed("move_back"):
		if Input.is_action_pressed("modifier") && $dash_timer.is_stopped() && boost_count > 0:
			is_dashing_backward = true
#			is_zero_movement = false
		linear_velocity_change -= global_transform.basis.z * acceleration_rate
	if !Input.is_action_pressed("move_forward") && !Input.is_action_pressed("move_back")&& !Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left"):
		is_zero_movement = true
	
	if ammoCount > 0 :
		if Input.is_action_just_pressed("fireLeft"):
			emit_signal("fire_left", linear_velocity, false)
			ammoCount -= 1
			emit_signal("update_ammo_count", ammoCount)
			update_ammo_indicator()
		if Input.is_action_just_pressed("fireRight"):
			emit_signal("fire_right", linear_velocity, false)
			ammoCount -= 1
			emit_signal("update_ammo_count", ammoCount)
			update_ammo_indicator()
		if Input.is_action_just_pressed("fire_forward"):
			emit_signal("fire_forward", linear_velocity, false)
			ammoCount -= 1
			emit_signal("update_ammo_count", ammoCount)
			update_ammo_indicator()
	if is_zero_movement && is_zero_rotation:
		$player_move.stop()
	elif (!is_zero_movement || !is_zero_rotation) && !$player_move.playing:
		$player_move.play()
	add_fleet_fighter()
	

func _integrate_forces(_state):
#	print("Linear Velocity change", linear_velocity_change)
	if (linear_velocity.x >= MAX_LINEAR_VELOCITY.x || linear_velocity.z >= MAX_LINEAR_VELOCITY.z):
		linear_velocity.x = min(MAX_LINEAR_VELOCITY.x, linear_velocity.x)
		linear_velocity.z = min(MAX_LINEAR_VELOCITY.z, linear_velocity.z)
#		print("linear_velocity cap up")
	elif linear_velocity.x <= -MAX_LINEAR_VELOCITY.x || linear_velocity.z <= -MAX_LINEAR_VELOCITY.z:
		linear_velocity.x = max(MAX_LINEAR_VELOCITY.x, linear_velocity.x)
		linear_velocity.z = max(MAX_LINEAR_VELOCITY.z, linear_velocity.z)
#		print("linear_velocity cap down")
#	elif is_zero_movement == true && !is_dodging_right && !is_dodging_left && !linear_velocity.is_equal_approx(Vector3.ZERO):
#		linear_velocity.x = linear_velocity.x * acceleration_slowdown
#		linear_velocity.z = linear_velocity.z * acceleration_slowdown
#		print("zeroing movement")
	else:
		if is_dodging_right:
			linear_velocity_change += global_transform.basis.x * dodge_force
			is_dodging_right = false
			$dodge_timer.start(DODGE_TIME)
			boost_count = boost_count - 1
#			emit_signal("update_boost_count", boost_count)
			update_boost_indicator()
		elif is_dodging_left:
			linear_velocity_change -= global_transform.basis.x * dodge_force
			is_dodging_left = false
			$dodge_timer.start(DODGE_TIME)
			boost_count = boost_count - 1
#			emit_signal("update_boost_count", boost_count)
			update_boost_indicator()
		if is_dashing_forward:
			linear_velocity_change += global_transform.basis.z * dash_force
			is_dashing_forward = false
			$dash_timer.start(DASH_TIME)
			boost_count = boost_count - 1
#			emit_signal("update_boost_count", boost_count)
			update_boost_indicator()
		elif is_dashing_backward:
			linear_velocity_change -= global_transform.basis.z * dash_force
			is_dashing_backward = false
			$dash_timer.start(DASH_TIME)
			boost_count = boost_count - 1
#			emit_signal("update_boost_count", boost_count)
			update_boost_indicator()
#		if (!linear_velocity_change.is_equal_approx(Vector3.ZERO)):
	add_central_force(linear_velocity_change)
#			print ("Applying linear force:", linear_velocity_change)
	
	if (angular_velocity.y >= MAX_ANGULAR_VELOCITY):
		angular_velocity.y = MAX_ANGULAR_VELOCITY
	elif angular_velocity.y <= -MAX_ANGULAR_VELOCITY:
		angular_velocity.y = -MAX_ANGULAR_VELOCITY
#	elif is_zero_rotation == true:
#		angular_velocity.y = angular_velocity.y * angular_velocity_slowdown
	else:
		apply_torque_impulse(Vector3(0,angular_velocity_change,0))
	linear_velocity_change = Vector3.ZERO
	angular_velocity_change = 0.0
	is_zero_rotation = false
	is_zero_movement = false

#	if (isPaused):		TODO REMOVE
#		return
#	if (isShipMoving()):
#		updatePositionHistory()
#	else:
#		backtrack()
#		return
	# TODO MAKE MOVEMENT RELATIVE TO SHIP
#	linear_velocity_change = linear_velocity_change.rotated(Vector3.UP, _sceneRotation).normalized()
	# Ground velocity
#	velocity.x = direction.x * forward_speed
#	velocity.z = direction.z * lateral_speed
	# Vertical velocity
	#velocity.y -= fall_acceleration * delta
	# Moving the character
#	linear_velocity_change = move_and_slide(linear_velocity_change, Vector3.UP)

#	for index in range(get_slide_count()):
#		# We check every collision that occurred this frame.
#		var collision = get_slide_collision(index)
#		# If we collide with a monster...
#		if collision.collider.is_in_group("obstacles"):
#			#var obstacle = collision.collider
#			#obstacle.impact()
#			#velocity.y = bounce_impulse
#			_on_playerShip_body_entered(self)



func _on_level_gui_player_lost(hit_count):
	isPaused = true

func _on_level_end_body_entered(body):
	if (body.is_in_group("Player")):
		isPaused = true

func reset():
	positionIndex = POSITION_SPACE
	stoppingIndex = 0
	positionHistory = PoolVector3Array()
	isPaused = false
	emit_signal("update_ammo_count", ammoCount)
	update_ammo_indicator()

func update_ammo_count(value):
	if value >= 0:
		ammoCount = value
		emit_signal("update_ammo_count", ammoCount)
		update_ammo_indicator()

func add_ammo(amount:int):
	print("adding ammo: ",amount, "max_ammo: ", max_ammo, "current ammo: ", ammoCount)
	$ammo_pickup.play()
	if amount > 0:
		ammoCount = ammoCount + amount
	if ammoCount > max_ammo:
		ammoCount = max_ammo
	print("max_ammo: ", max_ammo, "current ammo: ", ammoCount)
	update_ammo_indicator()

func add_health(amount:int):
	$health_pickup.play()
	if amount > 0:
		health = health + amount
		if health > max_health:
			health = max_health 
	update_health_indicator()
	emit_signal("update_health",health)

func add_boosts(amount:int):
	print("adding: ", amount, "to boosts: ",boost_count)
	$boost_pickup.play()
	if amount > 0:
		boost_count = boost_count + amount
	if boost_count > max_boosts:
		boost_count = max_boosts 
	update_boost_indicator()

var fleet_fighter = preload("res://scenes/enemies/craft_miner.tscn")
var fighter_index = 0
var wait_time:int = 10
var spawn_fighters:bool = false
const min_wait_time:int = 1
const max_fighters:int = 1

func add_fleet_fighter():
	if $fleet_timer.is_stopped() && spawn_fighters == true:
		$fleet_timer.start(wait_time)
		var new_ship
		var scene_root = get_node("/root/main/main/fighters")		#TODO update
		if scene_root.get_children().size() > max_fighters:
			print("total_fighters: ",scene_root.get_children().size())
			#only allow max fighters at one time
		else:
			var fighter_starts = [] 
			fighter_starts = $fighter_locations.get_children()
			fighter_index += 1
			if (fighter_index >= fighter_starts.size()-1):
				fighter_index = 0
			new_ship = fleet_fighter.instance()
			new_ship.global_transform = fighter_starts[fighter_index].global_transform
			new_ship.attack_speed = 75
			new_ship.max_speed = 25
			new_ship.target = self
			emit_signal("generatorExited", new_ship.get_instance_id() )
			print("adding fighter")
			scene_root.add_child(new_ship)
			wait_time = wait_time - 1
			if (wait_time < min_wait_time):
				wait_time = min_wait_time
