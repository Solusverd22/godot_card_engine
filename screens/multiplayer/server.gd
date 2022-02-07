extends AbstractScreen

onready var players_txt = $ButtonsLayout/players
var playerids = []

func _ready():
	#warning-ignore-all:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	Networking.start_host()

func _peer_connected(id):
	add_player(id)
func _peer_disconnected(id):
	remove_player(id)

func _on_BackBtn_pressed():
	Networking.close_connection()
	$AnimationPlayer.play_backwards("lobbyin")
	yield(get_tree().create_timer(0.8), "timeout")
	emit_signal("next_screen","menu")

func add_player(id):
	playerids.append(id)
	write_players()

func remove_player(id):
	playerids.erase(id)
	write_players()

func write_players():
	players_txt.text = ""
	for pid in playerids:
		players_txt.text = (players_txt.text + "\n" + str(pid))
