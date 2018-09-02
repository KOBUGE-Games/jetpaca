# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends StaticBody2D

var r = 0
var rnode = null

func _process(delta):
	r -= delta*get_constant_angular_velocity()
	rnode.set_rotation(r)

func _on_enter_screen():
	set_process(true)

func _on_exit_screen():
	set_process(false)

func _ready():
	set_process(false)
	rnode = get_node("sprite")

