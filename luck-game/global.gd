extends Node

var paused: bool = false
var sensitivity: float = .002
var playerZoom: float = 2
var playerPos := Vector3(0,0,0);
var rooms = 2
var curWeapon = "rocketLauncher"
var weapons = ["bow", "rocketLauncher", "spear"]
var speedBuff = 0
var healthBuff = 0
var enemyNum = 2

var enemies = [preload("res://characters/nikomancer.tscn"), preload("res://characters/ninja.tscn"), preload("res://characters/lilBomber.tscn"),preload("res://characters/hammerDude.tscn")]

func beatRoom():
	print("you beat the room :D")
	var num = randi_range(0,1)
	if num==1:
		healthBuff += 3
	elif num==0:
		speedBuff += 3
	enemyNum+=1
	if enemyNum > 10:
		enemyNum = 10
	nextWeapon()

func nextWeapon():
	get_tree().change_scene_to_file("res://weaponScreen.tscn")

func nextRoom():
	get_tree().change_scene_to_file("res://rooms/room"+str(randi_range(1,rooms))+".tscn")

func pickWeapon():
	curWeapon = weapons[randi_range(0,weapons.size()-1)]
	get_tree().current_scene.get_node(curWeapon).visible = true
