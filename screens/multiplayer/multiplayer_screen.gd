extends AbstractScreen

onready var _display = $HomeDisplay
onready var anim = $AnimationPlayer
onready var nametxtbox = $ButtonsLayout/dummyBtn/NameHBOX/NameTXT
onready var ip = $IPHBOX/IPTXT

func _ready():
	nametxtbox.text = Networking.info.username
	$IPHBOX/IPTXT.text = "146.90.82.135"
	var db = CardEngine.db().get_database("BT1")
	var q = Query.new()
	var store = CardPile.new()

	var cards = q.from([]).execute(db)

	store.populate(db, cards)
	store.shuffle()
	store.keep(3)

	_display.set_store(store)


func _on_HostBtn_pressed():
	emit_signal("next_screen","host")

func _on_JoinBtn_pressed() -> void:
	Networking.SERVERIP = ip.text
	Networking.info.username = nametxtbox.text
	emit_signal("next_screen","lobby")

func _on_BackBtn_pressed():
	anim.play_backwards("lobbyin")
	yield(get_tree().create_timer(0.3), "timeout")
	emit_signal("next_screen", "menu")

func _on_pingBtn_pressed():
	# warning-ignore-all:unsafe_property_access
	Networking.rpc("ping", "yo, angelo"+str(Networking.ID))
