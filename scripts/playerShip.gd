extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
#export var fall_acceleration = 75

var velocity = Vector3.ZERO
var hitCount = 0

#var _path_follow: PathFollow
#action area information this could be written better
var _sceneRotation: float
var cannon_ball = preload("res://scenes/player/cannonball.tscn")

func _ready():
	print("Starting hit count: ")
	print(hitCount)
	$"ship_dark_8angles2/cannon_left/cannon_left2/ballStart".add_child(cannon_ball.instance())

func y_rotation_update(rotation):
	_sceneRotation = rotation



func _on_playerShip_body_entered(body):
	hitCount += 1
	print("new hit count: ")
	print(hitCount)

# Called during every input event.
#func _unhandled_input(event):
#	match event.get_class():
#		"InputEventKey":
#			if Input.is_action_pressed("move_back"):
#				
#				print(get_process_delta_time())



func _physics_process(delta):
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

	# Ground velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
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
