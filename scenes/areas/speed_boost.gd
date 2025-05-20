extends Area

const collidable_groups = ["Player"]	#maybe some future enemy will steal ammo from the map

export var boost_impulse = 50000

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",self,"_on_something_hit")

func _on_something_hit(body):
	for group in collidable_groups:
		if body.is_in_group(group):
			print("something hit ammo pickup")
			#I don't like that this isn't explicit.
			body.add_central_force(-global_transform.basis.z * boost_impulse)
