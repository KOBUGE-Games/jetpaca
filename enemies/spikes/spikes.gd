# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends PhysicsBody2D

export(bool) var tutorial_mode = false

func _on_body_enter(body):
	if body extends preload("res://player/alpaca.gd"):
		if not tutorial_mode:
			body.hit_begin()

func _on_body_exit(body):
	if body extends preload("res://player/alpaca.gd"):
		if not tutorial_mode:
			body.hit_end()
