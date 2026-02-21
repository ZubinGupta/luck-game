extends CharacterBody3D
var stop := false;

func _physics_process(delta: float) -> void:
	velocity = basis.z.normalized() * 50
	if(stop): velocity = Vector3.ZERO
	move_and_slide()
	
func bonk(_hit: Node3D):
	print("is stopped")
	stop = true;
