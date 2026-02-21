extends Area3D
@onready var lifespan = $Lifespan

func _ready() -> void:
	lifespan.start()
	await get_tree().physics_frame
	await get_tree().physics_frame #idk 
	var bodies = get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if(body.has_method("take_damage")):
			body.take_damage(10)


func _on_lifespan_timeout() -> void:
	queue_free()
