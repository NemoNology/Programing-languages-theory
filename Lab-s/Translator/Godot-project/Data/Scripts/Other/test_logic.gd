extends Control

var output: ItemList

func _ready():
	output = get_node("MarginContainer/HBoxContainer/Output")

func _on_input_text_changed():
	pass # Replace with function body.
