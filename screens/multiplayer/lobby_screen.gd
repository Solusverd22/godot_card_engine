extends AbstractScreen

onready var _display = $HomeDisplay
onready var anim = $AnimationPlayer
onready var iptxtbox = $ButtonsLayout/dummyBtn/IPTxtBox

func _ready():
	var db = CardEngine.db().get_database("BT1")
	var q = Query.new()
	var store = CardPile.new()

	var cards = q.from(["rarity:common"]).execute(db)

	store.populate(db, cards)
	store.shuffle()
	store.keep(3)

	_display.set_store(store)


func _on_HostBtn_pressed():
	Networking.start_host()
	emit_signal("next_screen","host_screen")

func _on_JoinBtn_pressed() -> void:
	if Networking.join_server(iptxtbox.text):
		$ButtonsLayout/pingBtn.show()

func _on_BackBtn_pressed():
	anim.play_backwards("lobbyin")
	$ButtonsLayout/pingBtn.hide()
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("next_screen", "menu")

func _on_pingBtn_pressed():
	Networking.rpc("ping", "yo, angelo"+str(Networking.ID))
