extends Button

func _ready():
	update_size()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		update_size()

func update_size():
	var size = get_viewport().get_visible_rect().size
	set_size(size * 0.3)  # 30% de la taille du viewport
	set_position((size - get_size()) / 2)  # centré
