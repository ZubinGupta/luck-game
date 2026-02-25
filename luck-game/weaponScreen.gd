extends Node3D

func _ready():
	global.pickWeapon()

func _physics_process(delta: float) -> void:
	if $Timer.is_stopped() && Input.is_anything_pressed():
		global.nextRoom()
