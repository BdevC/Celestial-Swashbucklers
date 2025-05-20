extends RigidBody

const collidable_groups = ["Player"]	#maybe some future enemy will steal health from the map

const HEALTH_ADDITION = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",self,"_on_something_hit")

func _on_something_hit(body):
	for group in collidable_groups:
		if body.is_in_group(group):
			print("something hit health pickup")
			#I don't like that this isn't explicit.
			body.add_health(HEALTH_ADDITION)
			queue_free()
