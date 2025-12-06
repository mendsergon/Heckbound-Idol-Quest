extends Control

# ------------------------
# Signal to communicate with Main
# ------------------------
signal back_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_master_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.


func _on_music_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.


func _on_sfx_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.


func _on_back_pressed() -> void:
	# --------------------------------------------------------
	# Tell Main that player wants to go back to main menu
	# --------------------------------------------------------
	emit_signal("back_pressed")
