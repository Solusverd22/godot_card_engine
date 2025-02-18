extends AbstractScreen

onready var _display = $HomeDisplay

func _ready():
	var db = CardEngine.db().get_database("BT1")
	var q = Query.new()
	var store = CardPile.new()

	#var cards = q.from(["rarity:common"]).execute(db)
	var cards = q.from([]).execute(db)

	store.populate(db, cards)
	store.shuffle()
	store.keep(3)

	_display.set_store(store)


func _on_LobbyBtn_pressed():
	emit_signal("next_screen", "multiplayer")

func _on_BoardGameBtn_pressed() -> void:
	emit_signal("next_screen", "board")

func _on_BuilderBtn_pressed() -> void:
	emit_signal("next_screen", "builder")

func _on_QuitBtn_pressed():
	get_tree().quit()
