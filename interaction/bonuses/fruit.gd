# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Area2D

var alpacas = []
var taken = false
var follow_accel = 30.0
var speed = 0.0

func _on_timeout():
	queue_free()

func _on_enter_screen():
	get_node("anim").play("roll")

func _on_exit_screen():
	get_node("anim").stop()

func _on_body_enter(body):
	if body is preload("res://player/alpaca.gd"):
		body.add_fruit()
		get_node("sprite").hide()
		get_node("shine").set_emitting(true)
		# FIXME: Godot 2 version had lifetime 0.3 and emit timeout 0.5, then overridden here.
		# Not possible out of the box in Godot 3.
#		get_node("shine").set_emit_timeout(0.75)
		get_node("shine_sfx").play()
		get_node("deathclock").start()
		taken = true

func _process(delta):
	if alpacas.size():
		if not taken:
			var a = alpacas[0]
			var n = a.get_global_position() - get_global_position()
			speed += follow_accel*delta
			set_position(get_position() + n*delta*speed)
	else:
		set_process(false)
		speed = 0.0
		if not taken:
			get_node("shine").set_emitting(false)

func _on_magnet_enter(body):
	if body is preload("res://player/alpaca.gd"):
		alpacas.push_back(body)
		set_process(true)
		get_node("shine").set_emitting(true)
#		get_node("shine").set_emit_timeout(0)

func _on_magnet_exit(body):
	if body is preload("res://player/alpaca.gd"):
		alpacas.erase(body)

func _ready():
	set_process(false)
