extends Node3D

var enemy: CharacterBody3D

func _ready() -> void:
	if get_tree().current_scene.has_method("addSpawnpoint"):
		get_tree().current_scene.addSpawnpoint(self)

func spawn():
	var num = randi_range(0, global.enemies.size()-1)
	enemy = global.enemies[num].instantiate()
	get_tree().current_scene.add_child.call_deferred(enemy)
	call_deferred("defer")
		
func defer():
	enemy.global_position = global_position
	if get_tree().current_scene.has_method("addEnemy"):
		get_tree().current_scene.addEnemy(enemy)
