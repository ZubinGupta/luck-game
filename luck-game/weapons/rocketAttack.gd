extends CharacterBody3D

func _physics_process(delta: float) -> void:
	velocity = basis.z.normalized() * 50
	move_and_slide()
