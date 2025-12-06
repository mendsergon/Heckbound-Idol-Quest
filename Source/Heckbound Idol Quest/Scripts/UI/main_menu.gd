extends Control

# ------------------------
# Signals to communicate with Main
# ------------------------
signal start_pressed
signal settings_pressed
signal quit_pressed

# Called when the node enters the scene tree
func _ready() -> void:
	pass


# ------------------------
# Button handlers
# ------------------------
func _on_play_pressed() -> void:
	# Tell Main that the player wants to start the game
	emit_signal("start_pressed")


func _on_settings_pressed() -> void:
	# Tell Main that the player opened settings
	emit_signal("settings_pressed")


func _on_quit_pressed() -> void:
	# Tell Main that the player wants to quit the game
	emit_signal("quit_pressed")
