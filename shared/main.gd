# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node

var current_child = null
var next_scene = ""
var current_scene = null
var current_scene_path = ""

func _load_scene(path):
	print("load: ", path)

	var current = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	get_tree().get_root().remove_child(current)
	print("LOAD: FREEING")
	current.free()

	if path == current_scene_path:
		print("LOAD: INSTANCING")
		set_new_scene(current_scene)
	else:
		print("LOAD: START_PROGRESS")
		current_scene_path = path
		get_node("/root/progress").do_load(path)

func set_new_scene(scene_res):
	current_scene = scene_res
	var scene = scene_res.instance()
	printt("instanced scene ", scene, scene.get_filename())
	if scene:
		get_tree().get_root().add_child(scene)
		printt("added to tree")

func goto_scene(scene):
	next_scene = scene
	call_deferred("_load_scene", scene)
	get_tree().set_pause(false)

#	get_node("anim").play("fadeout")
#	get_node("change").start()

func _ready():
	var vm = OS.get_video_mode_size()
	var rate = float(vm.x)/float(vm.y)
	var height = int(1280.0/rate)
	get_tree().get_root().set_size_override(true, Vector2(1280, height))
	get_tree().get_root().set_size_override_stretch(true)
