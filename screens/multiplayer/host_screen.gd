extends AbstractScreen

onready var players_txt = $ButtonsLayout/players
var playerids = []

func _ready():
	#warning-ignore-all:return_value_discarded
	Networking.start_host()

func _on_BackBtn_pressed():
	Networking.close_connection()
	#Networking.port_unforward()
	$AnimationPlayer.play_backwards("lobbyin")
	yield(get_tree().create_timer(0.8), "timeout")
	emit_signal("next_screen","menu")

func update_players():
	players_txt.text = ""
	for pid in Networking.peerIDs:
		players_txt.text = (players_txt.text + "\n" + str(pid))
