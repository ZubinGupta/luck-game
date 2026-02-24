extends Node3D

var enemyList = []
var spawnPoints = []
var started = false

func _ready() -> void:
	startRoom(2)

func _physics_process(_delta: float) -> void:
	if started:
		var won = true
		for i in enemyList:
			if i != null:
				won = false
		if won:
			global.beatRoom()

func startRoom(num: int): # limit is 10, all rooms shouldn't have less than 10 spawns
	for i in num:
		var num1 = randi_range(0, spawnPoints.size()-1)
		spawnPoints[num1].spawn()
		spawnPoints.remove_at(num1)

func addSpawnpoint(point: Node3D):
	spawnPoints.append(point)
			
func addEnemy(enemy: CharacterBody3D):
	started = true
	enemyList.append(enemy)
