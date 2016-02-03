# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"


export(int,0,2,1) var key_index=0

var key_imgs = [ preload("res://art/key1.png"), preload("res://art/key2.png"), preload("res://art/key3.png") ]


func _on_timeout_enable():
	get_node("monitor").set_enable_monitoring(true)	
	
func _on_timeout():

	get_parent().call_deferred("remove_and_delete_child",self)

func _on_body_enter(body):
	if (body extends preload("res://player/alpaca.gd")):
		body.add_key(key_index)
		get_node("shine").set_emitting(true)
		get_node("death").start()
		get_node("player").play("gotkey")
		get_node("sprite").hide()
		clear_shapes()
		
func _on_enter_screen():
	get_node("normal_shine").set_emitting(true)

func _on_exit_screen():
	get_node("normal_shine").set_emitting(false)

func _ready():
	# Initalization here
	get_node("sprite").set_texture(key_imgs[key_index])
	get_node("enabler").start()
	pass


