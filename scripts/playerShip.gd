extends KinematicBody

signal fire_left()
signal fire_right()
signal decrementHealth()
signal update_ammo_count(count)


# How fast the player moves in meters per second.
export var forward_speed = 20
export var lateral_speed = 30
export var min_forward_speed = 1.5
export var min_movement_distance = 0.1
export var startingAmmoCount:int = 16
var ammoCount:int = startingAmmoCount
# The downward acceleration when in the air, in meters per second squared.
#export var fall_acceleration = 75

var velocity = Vector3.ZERO
var hitCount = 0
var isPaused:bool = false

#var _path_follow: PathFollow
#action area information this could be written better
var _sceneRotation: float

func _ready():
	emit_signal("update_ammo_count", ammoCount)



func y_rotation_update(rotation):
	_sceneRotation = rotation

func incrementHitCount():
	if ($safeTimer.is_stopped()):
		#tell system the ship has lost a hitpoint and start timer
		emit_signal("decrementHealth")
		$safeTimer.start(0.5) #reset timer give user a chance to move away


func _on_playerShip_body_entered(body):
	incrementHitCount()
	

# Called during every input event.
#func _unhandled_input(event):
#	match event.get_class():
#		"InputEventKey":
#			if Input.is_action_pressed("move_back"):
#				
#				print(get_process_delta_time())
const POSITION_SPACE:int = 300
var positionIndex:int = POSITION_SPACE
var stoppingIndex:int = 0
var positionHistory:PoolVector3Array = PoolVector3Array()
var count:int = 0
var isTrackingCounts:bool = true
var lastPosition:Vector3 = Vector3.ZERO
var isBackTracking:bool = false

func isShipMoving() -> bool:
	if (isBackTracking):
		return false
	var xdist:float = abs(global_transform.origin.x - lastPosition.x)
	var ydist:float = abs(global_transform.origin.z - lastPosition.z)
	var flatDist = sqrt(pow(xdist,2) + pow(ydist,2))
	lastPosition = global_transform.origin
	if flatDist > min_movement_distance:
		return true
	else:
		stoppingIndex = 0 if positionHistory.size() < POSITION_SPACE + 1 else positionIndex
		isBackTracking = true
		return false

func updatePositionHistory():
	if (positionHistory.size() < POSITION_SPACE + 1):
		positionHistory.push_back(global_transform.origin)
		positionIndex = positionHistory.size() -1
	else:
		positionHistory[positionIndex] = global_transform.origin
		positionIndex += 1
	if ( positionIndex >= POSITION_SPACE ) :
		positionIndex = 0

func backtrack():					# TODO: There is a bug in here somewhere.
	positionIndex -= 1
	if (positionIndex < 0):
		positionIndex = POSITION_SPACE
	if (positionIndex == stoppingIndex):
		isBackTracking = false
		return
	global_transform.origin = positionHistory[positionIndex]

func _physics_process(delta):
	if (isPaused):
		return
	if (isShipMoving()):
		updatePositionHistory()
	else:
		backtrack()
		return
	# TODO MAKE MOVEMENT RELATIVE TO SHIP
	if (Input.is_action_just_pressed("fireLeft") && ammoCount > 0):
		emit_signal("fire_left")
		ammoCount -= 1
		emit_signal("update_ammo_count", ammoCount)
	if Input.is_action_just_pressed("fireRight") && ammoCount > 0:
		emit_signal("fire_right")
		ammoCount -= 1
		emit_signal("update_ammo_count", ammoCount)
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.z += Vector3.RIGHT.x # 1
	if Input.is_action_pressed("move_left"):
		direction.z += Vector3.LEFT.x #1
	if Input.is_action_pressed("move_back"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.x += 1
	if Input.is_action_pressed("move_forward"):
		direction.x -= 1
	direction = direction.rotated(Vector3.UP, _sceneRotation).normalized()
	
	direction.x += min_forward_speed
	
	# Ground velocity
	velocity.x = direction.x * forward_speed
	velocity.z = direction.z * lateral_speed
	# Vertical velocity
	#velocity.y -= fall_acceleration * delta
	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP)

	for index in range(get_slide_count()):
		# We check every collision that occurred this frame.
		var collision = get_slide_collision(index)
		# If we collide with a monster...
		if collision.collider.is_in_group("obstacles"):
			#var obstacle = collision.collider
			#obstacle.impact()
			#velocity.y = bounce_impulse
			_on_playerShip_body_entered(self)
	

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
	ammoCount = startingAmmoCount
