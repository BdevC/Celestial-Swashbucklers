extends KinematicBody

signal fire_left()
signal fire_right()


# How fast the player moves in meters per second.
export var forward_speed = 20
export var lateral_speed = 30
export var min_forward_speed = 1.5
# The downward acceleration when in the air, in meters per second squared.
#export var fall_acceleration = 75

var velocity = Vector3.ZERO
var hitCount = 0

#var _path_follow: PathFollow
#action area information this could be written better
var _sceneRotation: float

func _ready():
	print("Starting hit count: ")
	print(hitCount)



func y_rotation_update(rotation):
	_sceneRotation = rotation

func incrementHitCount():
	hitCount += 1


func _on_playerShip_body_entered(body):
	incrementHitCount()
	

# Called during every input event.
#func _unhandled_input(event):
#	match event.get_class():
#		"InputEventKey":
#			if Input.is_action_pressed("move_back"):
#				
#				print(get_process_delta_time())

func _physics_process(delta):
	# TODO MAKE MOVEMENT RELATIVE TO SHIP
	if Input.is_action_just_pressed("fireLeft"):
		emit_signal("fire_left")
	if Input.is_action_just_pressed("fireRight"):
		emit_signal("fire_right")
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
	

