# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node2D

export var key_idx = 0
export var no_key = false

var unlocked = false

func activated():
		if unlocked:
			return
		get_node("anim").play("open")
		get_node("lock").unlock()
		unlocked = true

func _on_body_enter(body):
	if not no_key and body and body is preload("res://player/alpaca.gd") and not unlocked:
		if get_node("/root/game_data").current_keys[key_idx]:
			activated()

func _ready():
	get_node("lock").set_index(key_idx)
#	get_node("lock").set_texture([preload("res://art/keyhole1.png"), preload("res://art/keyhole2.png"), preload("res://art/keyhole2.png")][key_idx])
	if no_key:
		get_node("lock").hide()
		key_idx = -1

