# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

var animation
var ril

var TMAX = 150
var skip = 0

func _process(time):

	if skip >= 0:
		skip -= 1
		return
	var t = OS.get_ticks_msec()

	while(OS.get_ticks_msec() < t + TMAX):
		var res = ril.poll()
		if (res==ERR_FILE_EOF):
			printt("progress finished!")
			set_process(false)
			get_node("/root/main").set_new_scene(ril.get_resource())
			ril=null
			hide()
			break
		else:
			assert( res==OK )
			animation.seek(ril.get_stage() / float(ril.get_stage_count()) * animation.get_current_animation_length(), true)

func do_load(path):
	ril = ResourceLoader.load_interactive(path)
	assert( ril != null )
	animation.set_current_animation("progress")
	animation.seek(0, true)

	skip = 2
	call_deferred("set_process", true)
	show()

func _ready():
	animation = get_node("animation")
	hide()
