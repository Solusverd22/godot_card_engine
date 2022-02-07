extends AbstractScreen

onready var _display = $HomeDisplay
onready var anim = $AnimationPlayer
onready var iptxtbox = $ButtonsLayout/dummyBtn/IPTxtBox

var PORT = 8420
var MAX_PLAYERS = 10
var peer = null

func _ready():
	#warning-ignore-all:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	var db = CardEngine.db().get_database("BT1")
	var q = Query.new()
	var store = CardPile.new()

	var cards = q.from(["rarity:common"]).execute(db)

	store.populate(db, cards)
	store.shuffle()
	store.keep(3)

	_display.set_store(store)


func _on_HostBtn_pressed():
	print("hosting..")
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func _on_JoinBtn_pressed() -> void:
	peer = NetworkedMultiplayerENet.new()
	if peer.create_client(iptxtbox.text, PORT) != OK: 
		print("connection failed")
		return
	get_tree().network_peer = peer
	print("connection success")
	$ButtonsLayout/pingBtn.visible = true

func _on_BackBtn_pressed():
	anim.play_backwards("lobbyin")
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("next_screen", "menu")

func _peer_connected(id):
	print("peer connected: "+str(id))
func _peer_disconnected(id):
	print("peer disconnected: "+str(id))

remote func ping(message):
	print(message)

func _on_pingBtn_pressed():
	rpc("ping", "yo, angelo")
