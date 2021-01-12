extends Control

var NotPaused = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if NotPaused:
			get_tree().paused = true
			NotPaused = false
			visible = true
		else:
			get_tree().paused = false
			NotPaused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			visible = false


func _on_UnPause_pressed():
	get_tree().paused = false
	NotPaused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false


func _on_MainMenu_pressed():
	get_tree().change_scene('res://MainMenu.tscn')


func _on_Quit_pressed():
	get_tree().quit()
