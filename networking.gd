extends Node

var peer = null
var PORT = 8420
var MAX_PLAYERS = 10
var ID = 0
var SERVERIP = "146.90.82.179"
var username = "John Longballs"

func _ready():
	#warning-ignore-all:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("network_peer_connected", self, "_peer_connected")

func start_host() -> void:
	print("hosting..")
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	ID = peer.get_unique_id()
	

func join_server() -> bool:
	peer = NetworkedMultiplayerENet.new()
	if peer.create_client(SERVERIP, PORT) != OK: 
		print("connection failed")
		return false
	get_tree().network_peer = peer
	print("connection success")
	ID = peer.get_unique_id()
	return true

func _peer_connected(id):
	print("peer connected: "+str(id))
func _peer_disconnected(id):
	print("peer disconnected: "+str(id))

func close_connection():
	peer.close_connection()

remote func ping(message):
	print(message)
