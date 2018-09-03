# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends "res://enemies/enemy.gd"

func inflicts_damage():
	return false

func takes_damage():
	return true

func attacked(by):
	if (by is preload("res://player/alpaca.gd")):
		get_node("../particles").set_emitting(true)
		get_node("../break_sfx").play()
		queue_free()

