extends AbstractScreen

onready var _display = $HomeDisplay
onready var anim = $AnimationPlayer

func _ready():
	# warning-ignore:return_value_discarded
	Networking.join_server()
	var db = CardEngine.db().get_database("BT1")
	var q = Query.new()
	var store = CardPile.new()

	var cards = q.from([]).execute(db)

	store.populate(db, cards)
	store.shuffle()
	store.keep(3)

	_display.set_store(store)
	yield(get_tree().create_timer(0.3), "timeout")
	$Background/Title.text = Networking.servername+" "+$Background/Title.text

func _on_pingBtn_pressed():
	# warning-ignore-all:unsafe_property_access
	Networking.rpc("ping", "yo, angelo"+str(Networking.ID))

func _on_LeaveBtn_pressed():
	anim.play_backwards("lobbyin")
	yield(get_tree().create_timer(0.6), "timeout")
	emit_signal("next_screen","multiplayer")
