extends Control

const HOLD_SECONDS := 3.0

@onready var play_button: Button = %PlayButton
@onready var sound_button: Button = %SoundButton
@onready var adult_button: Button = %AdultButton
@onready var adult_ring: ProgressBar = %AdultRing

var _holding := false
var _hold_elapsed := 0.0


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	sound_button.pressed.connect(_on_sound_pressed)
	adult_button.button_down.connect(_on_adult_down)
	adult_button.button_up.connect(_on_adult_up)
	_update_sound_icon()
	adult_ring.value = 0


func _process(delta: float) -> void:
	if _holding:
		_hold_elapsed += delta
		adult_ring.value = clamp((_hold_elapsed / HOLD_SECONDS) * 100.0, 0, 100)
		if _hold_elapsed >= HOLD_SECONDS:
			_holding = false
			adult_ring.value = 0
			get_tree().change_scene_to_file("res://scenes/adult/Adult.tscn")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/Map.tscn")


func _on_sound_pressed() -> void:
	ProgressService.sound_enabled = not ProgressService.sound_enabled
	ProgressService.save_progress()
	AudioService.set_master_muted(not ProgressService.sound_enabled)
	_update_sound_icon()


func _update_sound_icon() -> void:
	sound_button.text = "🔊" if ProgressService.sound_enabled else "🔇"


func _on_adult_down() -> void:
	_holding = true
	_hold_elapsed = 0.0


func _on_adult_up() -> void:
	_holding = false
	_hold_elapsed = 0.0
	adult_ring.value = 0
