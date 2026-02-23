extends CharacterBody3D
var stop := false;

func _physics_process(delta: float) -> void:
	velocity = basis.z.normalized() * 50
	if(stop): velocity = Vector3.ZERO
	move_and_slide()
	


func _on_hitbox_body_entered(body: Node3D) -> void:
	if(body.has_method("take_damage")):
		body.take_damage(20)
	queue_free()
