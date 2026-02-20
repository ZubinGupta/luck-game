
extends CharacterBody3D

func _physics_process(delta: float) -> void:
	velocity = basis.z.normalized() * 50 + Vector3(0,-5,0);
	move_and_slide()
