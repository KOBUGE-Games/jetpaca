# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node2D

var unlocked = false

func _on_enter_screen():
	if not unlocked:
		get_node("anim").play("lock_closed")

func _on_exit_screen():
	if not unlocked:
		get_node("anim").stop()

func unlock():
	get_node("anim").play("lock_opening")
	unlocked = true

func set_index(idx):
	get_node("lock/keyhole").set_frame(idx)

