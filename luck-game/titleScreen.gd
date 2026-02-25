extends Node3D

func _physics_process(delta: float) -> void:
	if $Timer.is_stopped() && Input.is_anything_pressed():
		global.nextWeapon()
