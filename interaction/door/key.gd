# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D

export(int, 0, 2, 1) var key_index = 0

var key_imgs = [preload("res://art/key1.png"), preload("res://art/key2.png"), preload("res://art/key3.png")]

func _on_timeout_enable():
	get_node("monitor").set_monitoring(true)

func _on_timeout():
	get_parent().call_deferred("remove_and_delete_child", self)

func _on_body_enter(body):
	if body is preload("res://player/alpaca.gd"):
		body.add_key(key_index)
#		# 2to3: Particles disabled during conversion
#		get_node("shine").set_emitting(true)
		get_node("death").start()
#		# 2to3: Sound disabled during conversion
#		get_node("player").play("gotkey")
		get_node("sprite").hide()
		# 2to3: clear_shapes() changed to shape_owner_clear_shapes(0)
		shape_owner_clear_shapes(0)

func _on_enter_screen():
#	# 2to3: Particles disabled during conversion
#	get_node("normal_shine").set_emitting(true)
	pass

func _on_exit_screen():
#	# 2to3: Particles disabled during conversion
#	get_node("normal_shine").set_emitting(false)
	pass

func _ready():
	get_node("sprite").set_texture(key_imgs[key_index])
	get_node("enabler").start()

