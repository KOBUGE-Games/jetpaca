
export(String) var group=""


func _on_body_enter(body):
	if (body extends preload("res://player/alpaca.gd")):
		get_tree().call_group(0,group,"_triggered")
		


func _enter_tree():
	connect("body_enter",self,"_on_body_enter")
#	connect("body_exit",self,"_on_body_exit")
