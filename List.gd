class_name List
extends Node2D

var list = []

var selection = 0
var input = Vector2.ZERO

var enabled = false # was enable
var list_increase = Vector2.ZERO

signal select
signal exit

func enable():
	connect("select", Callable(self, "select"))
	enabled = true

func _process(delta):
	if enabled:
		input.x = (int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))) * list_increase.x
		input.y = (int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))) * list_increase.y

		selection = int(selection + input.x + input.y) % list.size()
		
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("select")
			disable()

func disable():
	disconnect("select", Callable(self, "select"))
	enabled = false

func select():
	return list[selection]
