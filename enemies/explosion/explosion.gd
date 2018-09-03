# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Particles2D

func _on_timeout():
	queue_free()

func explode():
#	# 2to3: Particles disabled during conversion
#	set_emitting(true)
	get_node("explosion_sfx").play()
	get_node("timer").start()
	print("GO KABOOM")

