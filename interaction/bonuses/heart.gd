# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D

func _on_body_enter(body):
	if body is preload("res://player/alpaca.gd"):
		body.restore_life(1)
		# 2to3: clear_shapes() changed to shape_owner_clear_shapes(0)
		shape_owner_clear_shapes(0)
		get_node("sprite").hide()
#		# 2to3: Particles disabled during conversion
#		get_node("shine_end").set_emitting(true)
#		get_node("shine").set_emitting(false)
		get_node("death").start()

func _on_enter_screen():
#	# 2to3: Particles disabled during conversion
#	get_node("shine").set_emitting(true)
	pass

func _on_exit_screen():
#	# 2to3: Particles disabled during conversion
#	get_node("shine").set_emitting(false)
	pass

func _on_timeout():
	get_parent().call_deferred("remove_and_delete_child", self)

func _on_activate():
	get_node("area").set_monitoring(true)

func _ready():
	get_node("activate").start()

