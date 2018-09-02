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
#		# 2to3: Particles disabled during conversion
#		get_node("shine").set_emitting(true)
#		get_node("shine").set_emit_timeout(0.75)
#		# 2to3: Sound disabled during conversion
#		get_node("sound").play("shine")
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
#		# 2to3: Particles disabled during conversion
#		if not taken:
#			get_node("shine").set_emitting(false)

func _on_magnet_enter(body):
	if body is preload("res://player/alpaca.gd"):
		alpacas.push_back(body)
		set_process(true)
#		# 2to3: Particles disabled during conversion
#		get_node("shine").set_emitting(true)
#		get_node("shine").set_emit_timeout(0)

func _on_magnet_exit(body):
	if body is preload("res://player/alpaca.gd"):
		alpacas.erase(body)

func _ready():
	set_process(false)
