extends RigidBody

const collidable_groups = ["Player"]	#maybe some future enemy will steal coins from the map

signal pickup_coin()

export var SCORE_ADDITION = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",self,"_on_something_hit")
	connect("pickup_coin",get_node("/root/main/main"), "_handle_coin_pickup")

func _process(delta):
	rotate_y(delta)

func _on_something_hit(body):
	for group in collidable_groups:
		if body.is_in_group(group):
			emit_signal("pickup_coin", SCORE_ADDITION)
			queue_free()
