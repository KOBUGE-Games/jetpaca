# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D

const RAISE_ACCEL = 100
const MAX_SPEED = 64

var deleted = false

func pop():
	if not deleted:
		deleted = true
		get_node("burst").start()
		deleted = true
		get_node("anim").play("burst")

func attacked(by):
	pop()

func _integrate_forces(state):
	var lv = state.get_linear_velocity()

	if lv.y > -MAX_SPEED:
		lv.y -= RAISE_ACCEL*state.get_step()
	state.set_linear_velocity(lv)

	for i in range(state.get_contact_count()):
		var co = state.get_contact_collider_object(i)
		if not co or not (co is RigidBody2D):
			pop()

func _on_timeout():
	get_parent().call_deferred("remove_and_delete_child", self)

func _on_enter_screen():
	get_node("anim").set_active(true)
	set_mode(MODE_CHARACTER)
	set_sleeping(true)

func _on_exit_screen():
	get_node("anim").set_active(false)
	set_mode(MODE_STATIC)

func _enter_tree():
	get_node("anim").play("appear")
	get_node("anim").queue("wobble")
	get_node("anim").set_active(false)

