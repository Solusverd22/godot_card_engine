extends AbstractCard

onready var _name = $AnimContainer/Front/NameBackground/Name
onready var _desc = $AnimContainer/Front/DescBackground/Desc
onready var _cost = $AnimContainer/Front/CostBackground/Cost
onready var _rarity_group = $AnimContainer/Front/RarityGroup
onready var _common = $AnimContainer/Front/RarityGroup/Common
onready var _epic = $AnimContainer/Front/RarityGroup/Epic
onready var _rare = $AnimContainer/Front/RarityGroup/Rare
onready var _legendary = $AnimContainer/Front/RarityGroup/Legendary
onready var _card_id = $AnimContainer/Front/CardId
onready var _card_art = $AnimContainer/Front/CardArt
onready var _type = $AnimContainer/Front/TypeBackground/Type



func _update_data(data: CardData, default: CardData = null) -> void:
	_card_id.text = data.id

	if data.has_text("name"):
		var cardname = data.get_text("name")
		_name.text = cardname
		_card_art.texture = load("res://cardart/"+cardname+".png")

	if data.has_text("desc"):
		_desc.text = data.get_text("desc")
	
	if data.has_meta_category("type"):
		_type.text = data.get_category("type")

	if data.has_value("mana"):
		var val = data.get_value("mana")
		if val >= 0:
			_cost.text = "%d" % val
		else:
			_cost.text = ""

	if default != null:
		var val = data.get_value("mana")
		var orig = default.get_value("mana")

		if val > orig:
			_cost.add_color_override("font_color", Color("ff0000"))
		elif val < orig:
			_cost.add_color_override("font_color", Color("00ff00"))
		else:
			_cost.add_color_override("font_color", Color("ffffff"))


	_update_picture(data)


func _update_picture(data: CardData) -> void:
	for child in _rarity_group.get_children():
		child.visible = false

	if data.has_meta_category("rarity"):
		if data.get_category("rarity") == "Common":
			_common.visible = true
		elif data.get_category("rarity") == "Rare":
			_rare.visible = true
		elif data.get_category("rarity") == "Epic":
			_epic.visible = true
		elif data.get_category("rarity") == "Legendary":
			_legendary.visible = true


func _on_NormalCard_instance_changed() -> void:
	# warning-ignore:return_value_discarded
	instance().connect("modified", self, "_on_instance_modified")
	_update_data(instance().data(), instance().unmodified())


func _on_instance_modified() -> void:
	_update_data(instance().data(), instance().unmodified())
