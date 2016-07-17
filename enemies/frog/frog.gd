# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends "res://enemies/enemy.gd"

const STATUS_IDLE = 0
const STATUS_JUMP_PREPARE = 1
const STATUS_JUMP_UP = 2
const STATUS_JUMP_FALLING = 3
const STATUS_ADVANCING = 4
const STATUS_DYING = 5
const WALK_SPEED = 200.0
const STOP_SPEED = 2000.0

export(bool) var can_move = false

var timeout = 0
var anim = ""

var siding = -1.0

var status = STATUS_IDLE
var jump_go_up = false
var damaging = false

func propel_up():
	jump_go_up = true

func begin_damage():
	damaging = true

func inflicts_damage():
	return damaging

func takes_damage():
	return not damaging and status != STATUS_DYING

func squatted():
	explode()

func attacked(bywho):
	if not damaging and status != STATUS_DYING:
		status = STATUS_DYING

func _integrate_forces(state):
	var lv = state.get_linear_velocity()

	var new_anim = ""

	if status == STATUS_IDLE:
		new_anim = "idle"
		lv.x = dectime(lv.x, STOP_SPEED, state.get_step())

		if lv.y < 0:
			lv.y = 0
		else:
			lv.y += 300.0*state.get_step()

		var c = get_closest_character()
		if c:
			var dvec = c.get_global_pos() - state.get_transform().get_origin()
			if abs(dvec.x) < 100 and dvec.y < 0 and dvec.y < 500:
				status = STATUS_JUMP_PREPARE
				jump_go_up = false
				new_anim = "jump_begin"

		timeout -= state.get_step()
		if status == STATUS_IDLE and timeout < 0:
			if randi() % 2 == 0:
				siding = -1.0
				get_node("body").set_scale(Vector2(1, 1))
			else:
				siding = 1.0
				get_node("body").set_scale(Vector2(-1, 1))

			status = STATUS_ADVANCING
			set_friction(0)
			timeout = 3.0

	elif status == STATUS_ADVANCING:
		new_anim = "walk"
		timeout -= state.get_step()
		if can_move:
			lv.x = siding*WALK_SPEED
		else:
			lv.x = dectime(lv.x, STOP_SPEED, state.get_step())

		if lv.y < 0:
			lv.y = 0
		else:
			lv.y += 300.0*state.get_step()

		if timeout < 0:
			status = STATUS_IDLE
			timeout = 3
			set_friction(1)

	elif status == STATUS_JUMP_PREPARE:
		new_anim = anim # keep
		if jump_go_up:
			jump_go_up = false
			lv.y = -500
			lv.x = siding*100.0
			status = STATUS_JUMP_UP
			get_node("anim").play("jump_begin")

	elif status == STATUS_JUMP_UP:
		anim = "burst_fall"
		new_anim = "burst_fall"
		if not get_node("anim").is_active():
			status = STATUS_JUMP_FALLING
			get_node("anim").play("burst")
			get_node("anim").queue("burst_fall")

	elif status == STATUS_JUMP_FALLING:
		new_anim = anim # keep
		var found_floor = false
		for i in range(state.get_contact_count()):
			var co = state.get_contact_collider_object(i)
			if co and co extends preload("res://player/alpaca.gd"):
				continue
			var n = state.get_contact_local_normal(i)
			print("cn", n)
			if n.y < -0.507:
				found_floor = true
				break

		if found_floor:
			status = STATUS_IDLE
			damaging = false
			new_anim = "idle"

	elif status == STATUS_DYING:
		if anim != "croak":
			lv.y = 500
		new_anim = "croak"

	state.set_linear_velocity(lv)

	if anim != new_anim:
		get_node("anim").play(new_anim)
		anim = new_anim

func _on_enter_screen():
	get_node("anim").set_active(true)
	set_mode(MODE_CHARACTER)
	set_sleeping(false)

func _on_exit_screen():
	get_node("anim").set_active(false)
	set_mode(MODE_STATIC)
