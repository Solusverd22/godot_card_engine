extends HBoxContainer

export(String) var button_text = "JOIN" setget set_button_text
export(String) var label_text = "USERNAME"

onready var b_text = $MenuButton
onready var l_text = $PlayerNameLBL


func _ready():
	b_text.set_button_text(button_text) # Compensate for not being able to set the value before in the tree
	l_text.text = label_text # Compensate for not being able to set the value before in the tree


func set_button_text(new_text: String) -> void:
	button_text = new_text
	if !is_inside_tree():
		return # Avoid crash when value is set before the node is added to the tree
	b_text.text = new_text
	label_text = new_text
	if !is_inside_tree():
		return # Avoid crash when value is set before the node is added to the tree
	l_text.text = new_text

