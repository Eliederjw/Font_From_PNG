extends TextureRect

@export var ascii_table:TextureRect

func _on_ascii_table_gui_input(event):
	if not event is InputEventMouseButton: return
	event = event as InputEventMouseButton
		
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_fade_in()
		
func _fade_in() -> void:
	ascii_table.visible = true
	ascii_table.self_modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(ascii_table, "self_modulate:a", 1, 0.15 )	
