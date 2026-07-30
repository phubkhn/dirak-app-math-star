extends Control

@onready var close_btn: Button = %CloseButton
@onready var tab_progress: Button = %TabProgress
@onready var tab_settings: Button = %TabSettings
@onready var panel_progress: Control = %PanelProgress
@onready var panel_settings: Control = %PanelSettings

@onready var stat_levels: Label = %StatLevelsValue
@onready var stat_overall: Label = %StatOverallValue
@onready var stat_addition: Label = %StatAdditionValue
@onready var stat_subtraction: Label = %StatSubtractionValue
@onready var stat_regrouping: Label = %StatRegroupingValue

@onready var vol_music: HSlider = %VolMusicSlider
@onready var vol_sfx: HSlider = %VolSfxSlider
@onready var vol_voice: HSlider = %VolVoiceSlider
@onready var vol_music_value: Label = %VolMusicValue
@onready var vol_sfx_value: Label = %VolSfxValue
@onready var vol_voice_value: Label = %VolVoiceValue

@onready var reset_btn: Button = %ResetButton
@onready var reset_backdrop: Control = %ResetBackdrop
@onready var reset_confirm_btn: Button = %ResetConfirmButton
@onready var reset_cancel_btn: Button = %ResetCancelButton

@onready var qa_fallback_btn: Button = %QaFallbackButton
@onready var fallback_overlay: Control = %FallbackOverlay


func _ready() -> void:
	close_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/menu/Menu.tscn"))
	tab_progress.pressed.connect(func(): _select_tab(true))
	tab_settings.pressed.connect(func(): _select_tab(false))

	vol_music.value = ProgressService.volumes.get("music", 45)
	vol_sfx.value = ProgressService.volumes.get("sfx", 70)
	vol_voice.value = ProgressService.volumes.get("voice", 80)
	_update_volume_labels()

	vol_music.value_changed.connect(func(v): _on_volume_changed("music", v))
	vol_sfx.value_changed.connect(func(v): _on_volume_changed("sfx", v))
	vol_voice.value_changed.connect(func(v): _on_volume_changed("voice", v))

	reset_btn.pressed.connect(func(): reset_backdrop.show())
	reset_cancel_btn.pressed.connect(func(): reset_backdrop.hide())
	reset_confirm_btn.pressed.connect(_on_reset_confirmed)

	qa_fallback_btn.pressed.connect(_on_qa_fallback)

	_select_tab(true)
	_render_stats()


func _select_tab(show_progress: bool) -> void:
	tab_progress.add_theme_color_override("font_color", Color(0.098, 0.435, 0.686) if show_progress else Color(0.376, 0.471, 0.557))
	tab_settings.add_theme_color_override("font_color", Color(0.376, 0.471, 0.557) if show_progress else Color(0.098, 0.435, 0.686))
	panel_progress.visible = show_progress
	panel_settings.visible = not show_progress


func _render_stats() -> void:
	var s: Dictionary = ProgressService.stats
	stat_levels.text = "%d/%d" % [ProgressService.levels_completed_count(), GameState.LEVEL_COUNT]
	var overall_attempted: int = s.get("addition_attempted", 0) + s.get("subtraction_attempted", 0)
	var overall_correct: int = s.get("addition_correct", 0) + s.get("subtraction_correct", 0)
	stat_overall.text = ProgressService.accuracy_text(overall_correct, overall_attempted)
	stat_addition.text = ProgressService.accuracy_text(s.get("addition_correct", 0), s.get("addition_attempted", 0))
	stat_subtraction.text = ProgressService.accuracy_text(s.get("subtraction_correct", 0), s.get("subtraction_attempted", 0))
	stat_regrouping.text = ProgressService.accuracy_text(s.get("regrouping_correct", 0), s.get("regrouping_attempted", 0))


func _on_volume_changed(key: String, value: float) -> void:
	ProgressService.volumes[key] = int(value)
	ProgressService.save_progress()
	AudioService.apply_volumes_from_progress()
	_update_volume_labels()


func _update_volume_labels() -> void:
	vol_music_value.text = "%d%%" % int(vol_music.value)
	vol_sfx_value.text = "%d%%" % int(vol_sfx.value)
	vol_voice_value.text = "%d%%" % int(vol_voice.value)


func _on_reset_confirmed() -> void:
	ProgressService.reset_all_progress()
	QuestionRepository.clear_session_history()
	reset_backdrop.hide()
	_render_stats()


func _on_qa_fallback() -> void:
	fallback_overlay.show()
	get_tree().create_timer(1.6).timeout.connect(func():
		fallback_overlay.hide()
	)
