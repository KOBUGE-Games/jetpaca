# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D

const DROP_NONE = 0
const DROP_HEART = 1
const DROP_KEY1 = 2
const DROP_KEY2 = 3
const DROP_KEY3 = 4

const explosion = preload("res://enemies/explosion/explosion.tscn")

export(int, "None", "Heart", "Key1", "Key2", "Key3") var drop = DROP_NONE

func inflicts_damage():
	return true

func takes_damage():
	return false

func get_closest_character():
	var clist = get_tree().get_nodes_in_group("character")
	var d = 1.0e10
	var retc = null
	for c in clist:
		var ld = (get_global_position() - c.get_global_position()).length()
		if ld < d:
			retc = c
			d = ld

	return retc

func explode():
	hide()
	queue_free()
	var n = explosion.instance()
	get_parent().add_child(n)
	n.set_global_transform(get_global_transform())
	n.explode()
	if drop:
		var dropscene = null
		# FIXME: Using preload here causes cyclic references with alpaca.gd
		if drop == DROP_HEART:
			dropscene = load("res://interaction/bonuses/heart.tscn").instance()
		elif drop == DROP_KEY1:
			dropscene = load("res://interaction/door/key.tscn").instance()
			dropscene.key_index = 0
		elif drop == DROP_KEY2:
			dropscene = load("res://interaction/door/key.tscn").instance()
			dropscene.key_index = 1
		elif drop == DROP_KEY3:
			dropscene = load("res://interaction/door/key.tscn").instance()
			dropscene.key_index = 2

		get_parent().call_deferred("add_child", dropscene)
		dropscene.set_global_transform(get_global_transform())

func _on_enter_screen():
	pass

func _on_exit_screen():
	pass

func _enter_tree():
	var c = VisibilityNotifier2D.new()
	c.connect("screen_entered", self, "_on_enter_screen")
	c.connect("screen_exited", self, "_on_exit_screen")
	add_child(c)

