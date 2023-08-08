extends TextureRect

func _on_ascii_tabler_full_gui_input(event):
	if not event is InputEventMouseButton: return
	
	event = event as InputEventMouseButton
		
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "self_modulate:a", 0, 0.15 )
		
		await tween.finished
		
		visible = false
	

