extends TextureButton

onready var anim = $SettingsAnim
var open = false

func _on_SettingsButton_pressed():
	if !open:
		anim.play("pressed")
		open = true
	else:
		anim.play_backwards("pressed")
		open = false


func _on_IPBtn_pressed():
	Networking.SERVERIP = $Panel/ServerIP/IPTXT.text
