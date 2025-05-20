extends RigidBody


var l_direction:Vector3
var l_force:float


func _ready():
	add_central_force(l_direction * l_force)
	$death_timer.start(5)
	$death_timer.connect("timeout", self, "handle_death")
	connect("body_entered", self, "handle_contact")
	add_to_group("enemy_ammo")

func handle_death():
	queue_free()

func handle_contact(body):
	if body.is_in_group("Player"):
		queue_free()
