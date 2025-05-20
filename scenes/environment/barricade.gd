extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("obstacles")
	connect("body_entered",self,"on_body_entered")
	

func on_body_entered(body):
	if body.is_in_group("Player") || body.is_in_group("playerAmmo"):
		queue_free()
