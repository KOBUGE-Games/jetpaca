# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D

export var has_key = false
export var key_index = 0

var broken = false

func _on_timeout():
	print("DEADED!")
	get_parent().call_deferred("remove_and_delete_child", self)

func attacked(by):
	if broken:
		return
	# 2to3: clear_shapes() changed to shape_owner_clear_shapes(0)
	shape_owner_clear_shapes(0)
	get_node("sprite").hide()
	get_node("particles").set_emitting(true)
	get_node("death").start()
#	# 2to3: Sound disabled during conversion
#	get_node("player").play("break")
	broken = true
	if has_key:
		var ki = preload("res://interaction/door/key.tscn").instance()
		ki.set_position(get_global_position())
		ki.key_index = key_index
		get_parent().add_child(ki)

