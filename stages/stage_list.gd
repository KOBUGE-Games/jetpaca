# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

static func get_stage_list():
	var sl = [
		{ "id": Vector2(1, 1), "path": "res://stages/world_1/intro", "music": "res://music/forest.mpc" },
		{ "id": Vector2(1, 2), "path": "res://stages/world_1/forest_fun", "music": "res://music/forest.mpc" },
		{ "id": Vector2(1, 3), "path": "res://stages/world_1/roller_coaster", "music": "res://music/forest.mpc" },
		{ "id": Vector2(1, 5), "path": "res://stages/gcon/demo_gcon_004", "music": "res://music/carbonite.mpc" },
		{ "id": Vector2(1, 7), "path": "res://stages/gcon/demo_gcon_006", "music": "res://music/carbonite.mpc" }
	]

	return sl
