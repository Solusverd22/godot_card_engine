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
