# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends "res://enemies/enemy.gd"

const MODE_GRAB = 0
const MODE_DIRECTED = 1
const MODE_STOP = 2

export(int, "grab", "directed", "stop") var boost_mode = 0
export var boost_value = 1300

var disabled = false
var incount = 0

func _on_timeout():
	disabled = false

func _on_push_enter(body):
	if body is RigidBody2D:
		if boost_mode == MODE_DIRECTED:
			body.set_linear_velocity(get_global_transform()[0]*boost_value)
			if body is preload("res://player/alpaca.gd"):
				body.cancel_attack()
			disabled = true
			get_node("timer").start()
			get_node("particles").set_emitting(true)
		elif boost_mode == MODE_STOP:
			body.set_linear_velocity(Vector2())
			if body is preload("res://player/alpaca.gd"):
				body.cancel_attack()
			incount += 1
			if incount == 1:
				disabled = true

func _on_push_exit(body):
	if boost_mode == MODE_STOP and body is RigidBody2D:
		incount -= 1
		if incount == 0:
			disabled = false

func inflicts_damage():
	return false

func takes_damage():
	return not disabled

