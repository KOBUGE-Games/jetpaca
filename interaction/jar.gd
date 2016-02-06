# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var broken=false
export var has_key=false
export var key_index=0


func _on_timeout():
	print("DEADED!")
	get_parent().call_deferred("remove_and_delete_child",self)

func attacked(by):
	if (broken):
		return
	clear_shapes()
	get_node("sprite").hide()
	get_node("particles").set_emitting(true)
	get_node("death").start()
	get_node("player").play("break")
	broken=true
	if (has_key):
		var ki = preload("res://interaction/key.xml").instance()
		ki.set_pos(get_global_pos())
		ki.key_index=key_index
		get_parent().add_child(ki)

func _ready():
	# Initalization here
	pass


