# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends TextureFrame

# member variables here, example:
# var a=2
# var b="textvar"


func _on_load_world(world):
	get_tree().get_root().get_node("game_data").current_world=world
# 	get_tree().get_root().get_node("game_data").current_checkpoint=null
	get_tree().get_root().get_node("main").goto_scene(world.path)
	

const LEVEL_COLUMNS = 3
	
func _on_back_pressed():
	print("goback")	
	get_tree().get_root().get_node("main").goto_scene("res://menu/main_menu.xml")

func add_levels():
	# Initalization here
	var gd = get_tree().get_root().get_node("game_data");
	var tab_world={}
	var tabs=get_node("vbox/tabs")
	print("ENTER SCENE!")
	var focus = false

	for l in gd.levels:
		printt("adding level", l.enabled, l.path)
		if (not l.enabled):
			continue
		if (!(l.id[0] in tab_world)):
			var tabdata = {}
			var t = CenterContainer.new()
			t.set_name("World "+str(l.id[0]))
			tabs.add_child(t)			
			var vb = VBoxContainer.new()
			t.add_child(vb)			
			tabdata.vb=vb
			tab_world[l.id[0]]=tabdata
			tabdata.current_hb=null
			
			
		var td = tab_world[l.id[0]]
		if (td.current_hb==null or td.current_hb.get_child_count()==LEVEL_COLUMNS):
			
			var hb = HBoxContainer.new()
			td.current_hb=hb
			td.vb.add_child(hb)
			
		var vb2 = VBoxContainer.new()
		td.current_hb.add_child(vb2)
		var b = Button.new()
		#b.set_flat(true)
		vb2.add_child(b)
		b.set_button_icon(ResourceLoader.load(l.preview_path))
		var lb = Label.new()
		lb.add_font_override("font",preload("res://art/font.xfnt"))
		lb.set_align(Label.ALIGN_CENTER)
		vb2.add_child(lb)
		lb.set_text(str(l.id[0],"-",l.id[1]))
		b.connect("pressed",self,"_on_load_world",[l])
		if !focus:
			b.call_deferred("grab_focus")
			focus = true
		
		
func _enter_tree():
	printt("stage select enter scene!")
	call_deferred("add_levels")
