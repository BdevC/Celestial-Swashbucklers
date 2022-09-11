extends PathFollow

export var attack_speed:float = 1
var crash_rotation:float = 0.02
var is_crashing:bool = false

#func _ready():
	

func crash():
	$AttackCraft.gravity_scale = 1
	is_crashing = true
#	$AttackCraft.set_linear_velocity(Vector3(0,-100,0))

func _process(delta):
	offset += attack_speed
	if (unit_offset > .3 && !is_crashing):
		print("crashing")
		crash()
	if (is_crashing):
		$AttackCraft.set_physics_process(true)
		$AttackCraft.apply_central_impulse(Vector3(0,-1000,0))
		$AttackCraft.rotate_z(crash_rotation)
#		$AttackCraft.NOTIFICATION_PHYSICS_PROCESS
#		$AttackCraft.set_linear_velocity(Vector3(0,-50,0))
#		$AttackCraft.add_force(Vector3(0,-100,0), Vector3(0,-10000,0))
		#$AttackCraft.add_central_force(Vector3(0,-1000,0))
		
	#make this better
	if ($AttackCraft.get_translation().y <= -100 || unit_offset > 98):
		self.queue_free()

