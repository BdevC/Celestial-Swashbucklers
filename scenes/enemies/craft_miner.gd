extends PathFollow

export var attack_speed:float = 1
var crash_rotation:float = 0.02
var is_crashing:bool = false
var descent_speed:float = 0.0

#func _ready():
	

func crash():
	is_crashing = true
#	$AttackCraft.set_linear_velocity(Vector3(0,-100,0))

func _process(delta):
	offset += attack_speed
	if (is_crashing):
		$AttackCraft.rotate_z(crash_rotation)
		$AttackCraft.move_and_slide(Vector3(0,descent_speed,0), Vector3.UP)
		descent_speed -=0.8
	
	#make this better
	if ($AttackCraft.get_translation().y <= -100 || unit_offset > 98): #todo change -100 to a colision
		print("bye bye")
		self.queue_free()

