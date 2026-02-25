extends Node3D

func _ready():
	$Rooms.text = "You survived "+str(global.enemyNum-2)+" rooms"
	global.speedBuff = 0
	global.healthBuff = 0
	global.enemyNum = 2

func _physics_process(delta: float) -> void:
	if $Timer.is_stopped() && Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://titleScreen.tscn")
