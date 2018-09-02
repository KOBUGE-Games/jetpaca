# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Sprite

export(String) var trigger_name = ""
var onfire = false

func set_on_fire(pos):
	if onfire:
		return

	var d = pos.distance_to(get_node("fire").get_global_position())

	if d < 20:
		get_tree().call_group(trigger_name, "activated")
		onfire = true
		get_node("fire").set_emitting(true)

