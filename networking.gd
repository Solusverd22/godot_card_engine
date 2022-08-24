extends Node

signal player_connection

var peer = null
var PORT = 8420
var MAX_PLAYERS = 10
var SERVERIP = "146.90.82.135"
var servername = ""
var upnp = null
var info = {username = "John Longballs", ID = 0}

var peerIDs = []

func _ready():
	upnp = UPNP.new()
	#warning-ignore-all:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("network_peer_connected", self, "_peer_connected")

func port_unforward():
	upnp.delete_port_mapping(PORT)

func start_host() -> void:
	#print("forwarding port "+str(PORT)+": ")
	#upnp.discover(2000, 2, "InternetGatewayDevice")
	#upnp.add_port_mapping(PORT)
	print("hosting..")
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	servername = info.username
	info.ID = peer.get_unique_id()
	print("ID: ",info.ID)

func join_server() -> bool:
	print("joining: "+str(IP)+":"+str(PORT)) 
	peer = NetworkedMultiplayerENet.new()
	if peer.create_client(SERVERIP, PORT) != OK: 
		print("connection failed")
		return false
	get_tree().network_peer = peer
	print("connection success")
	info.ID = peer.get_unique_id()
	print("ID: ",info.ID)
	servername = rpc("get_server_name")
	return true

func _peer_connected(id):
	print("peer connected: "+str(id))
	peerIDs.append(id)
	if info.ID == 1:
		$ScreenLayer/HostScreen.update_players()
	#rset_id(id,"servername",servername)
func _peer_disconnected(id):
	print("peer disconnected: "+str(id))
	peerIDs.erase(id)

func close_connection():
	peer.close_connection()

remote func ping(message):
	print(message)

remote func get_name():
	return info.username

remote func get_server_name():
	if info.ID == 1:
		rpc("set_server_name",servername)

remote func set_server_name(sname):
	if info.ID != 0:
		servername = sname
