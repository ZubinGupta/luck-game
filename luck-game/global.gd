extends Node

var paused: bool = false
var sensitivity: float = .002
var playerZoom: float = 2
var playerPos := Vector3(0,0,0);

var enemies = [preload("res://characters/nikomancer.tscn"), preload("res://characters/ninja.tscn")]

func beatRoom():
	print("you beat the room :D")
