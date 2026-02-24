extends Area3D
@onready var lifespan = $Lifespan

var damage = 25
var special: bool = false

func _ready() -> void:
	lifespan.start()
	await get_tree().physics_frame
	
	#var bodies = get_overlapping_bodies()
	#print(bodies)
	#for body in bodies:
	#	if(body.has_method("take_damage")):
	#		body.take_damage(10)


func _on_lifespan_timeout() -> void:
	if(is_inside_tree()):
		queue_free()


func onHit(_body: Node3D):
	if(special):
		$"../Player".knockbackVelocity = Vector3(0, 60, 0)
	else:
		$"../Player".knockbackVelocity = ($"../Player".global_position-global_position).normalized()*40*Vector3(1,0,1) + Vector3(0, 20, 0)


func hitEnemy(body: Node3D) -> void:
	if(body.has_method("take_damage")):
			body.take_damage(damage)
