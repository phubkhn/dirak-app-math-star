extends Control

@onready var route_container: HBoxContainer = %RouteContainer
@onready var back_button: Button = %BackButton


func _ready() -> void:
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/menu/Menu.tscn"))
	_render_map()


func _render_map() -> void:
	for child in route_container.get_children():
		child.queue_free()

	var groups := _group_by_theme()
	for group in groups:
		var group_box := VBoxContainer.new()
		group_box.alignment = BoxContainer.ALIGNMENT_CENTER
		group_box.add_theme_constant_override("separation", 8)

		var label := Label.new()
		label.text = group.theme
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_color_override("font_color", Color(0.376, 0.471, 0.557))
		group_box.add_child(label)

		var nodes_box := HBoxContainer.new()
		nodes_box.add_theme_constant_override("separation", 8)
		for level_id in group.levels:
			nodes_box.add_child(_make_level_node(level_id))
		group_box.add_child(nodes_box)

		route_container.add_child(group_box)


func _group_by_theme() -> Array:
	var groups: Array = []
	var last_theme := ""
	for level_id in range(1, GameState.LEVEL_COUNT + 1):
		var theme_name: String = GameState.theme_for_level(level_id)
		if theme_name != last_theme:
			groups.append({"theme": theme_name, "levels": []})
			last_theme = theme_name
		groups[-1].levels.append(level_id)
	return groups


func _make_level_node(level_id: int) -> Button:
	var stars: int = ProgressService.stars.get(str(level_id), 0)
	var locked: bool = level_id > ProgressService.unlocked_up_to
	var is_current: bool = level_id == ProgressService.unlocked_up_to and stars == 0

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(64, 64)
	btn.focus_mode = Control.FOCUS_ALL

	var stars_text := ""
	if locked:
		stars_text = "—"
	else:
		stars_text = "★".repeat(stars) + "☆".repeat(3 - stars)

	btn.text = ("🔒" if locked else str(level_id)) + "\n" + stars_text

	if locked:
		btn.modulate = Color(0.7, 0.7, 0.7)
	elif is_current:
		btn.add_theme_color_override("font_color", Color(0.098, 0.435, 0.686))
	elif stars > 0:
		btn.add_theme_color_override("font_color", Color(0.098, 0.478, 0.29))

	btn.pressed.connect(func(): _on_level_pressed(level_id, locked, btn))
	return btn


func _on_level_pressed(level_id: int, locked: bool, btn: Button) -> void:
	if locked:
		var tween := create_tween()
		var original_pos := btn.position
		tween.tween_property(btn, "position:x", original_pos.x - 4, 0.06)
		tween.tween_property(btn, "position:x", original_pos.x + 4, 0.06)
		tween.tween_property(btn, "position:x", original_pos.x, 0.06)
		return

	GameState.current_level_id = level_id
	get_tree().change_scene_to_file("res://scenes/runner/Runner.tscn")
