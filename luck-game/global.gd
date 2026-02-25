extends Node

var paused: bool = false
var sensitivity: float = .002
var playerZoom: float = 2
var playerPos := Vector3(0,0,0);
var rooms = 1
var curWeapon = "rocketLauncher"
var weapons = ["bow", "rocketLauncher", "spear"]

var enemies = [preload("res://characters/nikomancer.tscn"), preload("res://characters/ninja.tscn"), preload("res://characters/lilBomber.tscn"),preload("res://characters/hammerDude.tscn")]

func beatRoom():
	print("you beat the room :D")
	nextWeapon()

func nextWeapon():
	get_tree().change_scene_to_file("res://weaponScreen.tscn")

func nextRoom():
	get_tree().change_scene_to_file("res://rooms/room"+str(randi_range(1,rooms))+".tscn")

func pickWeapon():
	curWeapon = weapons[randi_range(0,weapons.size()-1)]
	get_tree().current_scene.get_node(curWeapon).visible = true
