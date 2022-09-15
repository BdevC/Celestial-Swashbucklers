extends RigidBody

func _ready():
	add_central_force(Vector3(0,300,0))

#func _physics_process(delta):
#	add_central_force(Vector3(0,5000,0))
