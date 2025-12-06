extends Control

# ------------------------
# Signals to communicate with Main
# ------------------------
signal back_pressed
signal start_continue_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start__continue_pressed() -> void:
	# --------------------------------------------------------
	# Tell Main that player wants to start/continue the game
	# --------------------------------------------------------
	emit_signal("start_continue_pressed")


func _on_level_select_pressed() -> void:
	pass # Replace with function body.


func _on_back_pressed() -> void:
	# --------------------------------------------------------
	# Tell Main that player wants to go back to main menu
	# --------------------------------------------------------
	emit_signal("back_pressed")
