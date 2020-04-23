tool
extends WindowDialog

var _db: CardDatabase = null

func set_database(id: String):
	_clear_lists()
	
	_db = CardEngine.db().get_database(id)
	
	var cards = _db.cards()
	for card_id in cards:
		var card = cards[card_id]
		$MainLayout/CardsLayout/CardList.add_item(card.id)

func _clear_lists():
	$MainLayout/CardsLayout/CardList.clear()
	$MainLayout/CardsLayout/DetailsLayout/DetailsList.clear()

func _on_DoneBtn_pressed():
	hide()

func _on_EditDatabaseDialog_about_to_show():
	_clear_lists()

func _on_CardList_item_selected(index):
	var list = $MainLayout/CardsLayout/DetailsLayout/DetailsList
	list.clear()
	
	var id = $MainLayout/CardsLayout/CardList.get_item_text(index)
	var card = _db.get_card(id)
	
	list.add_item("Categories:")
	for categ in card.categories():
		list.add_item("  * %s: %s" % [categ, card.get_category(categ)])
		
	list.add_item("Values:")
	for value in card.values():
		list.add_item("  * %s = %f" % [value, card.get_value(value)])
		
	list.add_item("Texts:")
	for text in card.texts():
		list.add_item("  * %s: %s" % [text, card.get_text(text)])