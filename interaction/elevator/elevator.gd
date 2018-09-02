# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node2D

export(int) var distance = 100
export(float) var max_speed = 64.0

var done = false
var target = 0
var speed = 0
var active = false
var moved = 0

func _physics_process(delta):
	if done or not active:
		return

	var tomove = speed*delta
	if speed < max_speed:
		speed += 20*delta
		if speed > max_speed:
			speed = max_speed

	if distance > 0:
		moved += tomove
		if moved > target:
			moved = target
			done = true
	else:
		moved -= tomove
		if moved < target:
			moved = target
			done = true

	if done:
		set_physics_process(false)

	set_position(Vector2(get_position().x, moved))

func _triggered():
	if active or done:
		return

	set_physics_process(true)
	active = true
	target = get_position().y + distance
	moved = get_position().y
	speed = 0

func _ready():
	set_physics_process(false)

