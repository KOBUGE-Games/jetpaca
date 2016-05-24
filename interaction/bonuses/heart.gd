# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

func _on_body_enter(body):

	if (body extends preload("res://player/alpaca.gd")):
		body.restore_life(1)
		clear_shapes()
		get_node("sprite").hide()
		get_node("shine_end").set_emitting(true)
		get_node("shine").set_emitting(false)
		get_node("death").start()	
		

func _on_enter_screen():
	get_node("shine").set_emitting(true)

func _on_exit_screen():
	get_node("shine").set_emitting(false)

func _on_timeout():
	get_parent().call_deferred("remove_and_delete_child",self)
	
	
func _on_activate():
	get_node("area").set_enable_monitoring(true)

func _ready():
	# Initalization here
	get_node("activate").start()
	pass


