# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node2D

var prize=0
var ended=false

func _on_body_enter(body):
	if (not ended and body extends preload("res://player/alpaca.gd")):
		get_node("anim").play("button")
		get_node("anim").queue("prize_select")
		ended=true

func _random_select_prize():

	prize=randi() % 6
	get_node("Ruleta/ruleta_select").set_rot( prize / 6.0 * 2.0 * PI ) # rotate randomly

func _end_spin():
	get_node("/root/main").goto_scene("res://menu/stage_select.tscn")
	pass
# member variables here, example:
# var a=2
# var b="textvar"

#func _init():
	#get_node("anim").set_active(false)


	
func _ready():
	# Initalization here
	pass
	
	


