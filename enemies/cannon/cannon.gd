# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends StaticBody2D

const TYPE_MISSILE = 0
const TYPE_SEEKER = 1
const TYPE_BUBBLE = 2

export(int) var interval = 2.0
export(int) var max_alive = 4
export(int, "missile", "heatseeker", "bubbles") var type = 0

var alive = 0

func _killed_one():
	alive -= 1

func _on_timeout():
	get_node("anim").play("firing")
	get_node("anim").queue("idle")

func fire():
	print("TIMEOUT")
	get_node("timer").set_wait_time(interval)
	get_node("timer").start()

	if alive >= max_alive:
		return

	var t = get_global_transform()
	var spawn
	var dir = -t[0]
	var pos = get_node("cannon_sprites_r90/cannon_rotation/body_orientation/missile2d").get_global_position()
	var ofs = 0

	if type == TYPE_SEEKER or type == TYPE_MISSILE:
		spawn = preload("res://enemies/cannon/heatseeker.tscn").instance()
		spawn.set_rotation(t.get_rotation())
		spawn.set_seek_heat(type == TYPE_SEEKER)
	elif type == TYPE_BUBBLE:
		spawn = preload("res://enemies/cannon/bubble.tscn").instance()
		ofs = 128

	var parent = get_parent()
	while parent is CanvasItem:
		parent = get_parent()

	spawn.set_position(pos + dir*ofs)
	parent.add_child(spawn)
	spawn.connect("exit_tree", self, "_killed_one")
	alive += 1

func _on_enter_screen():
	get_node("timer").set_wait_time(interval)
	get_node("timer").start()
	get_node("anim").set_active(true)

func _on_exit_screen():
	get_node("timer").stop()
	get_node("anim").set_active(false)

func _ready():
	get_node("anim").play("idle")
	get_node("anim").set_active(false)

