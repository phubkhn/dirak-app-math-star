extends Node

# Audio bus/volume infrastructure (APP_SPEC 5.6, FR-09/FR-11/FR-12).
#
# No licensed audio assets exist yet (see docs/design/asset-manifest.csv — all
# AUD-* rows are "planned"). CLAUDE.md explicitly forbids using unlicensed
# internet audio without recorded source/license, so this service wires up the
# real bus/volume/ducking architecture but every playback call is a safe no-op
# until real .ogg files are dropped into assets/audio/{bgm,sfx,voice}/ and
# referenced here.

const BUS_MUSIC := "Music"
const BUS_SFX := "SFX"
const BUS_VOICE := "Voice"

var _duck_tween: Tween


func _ready() -> void:
	_ensure_bus(BUS_MUSIC)
	_ensure_bus(BUS_SFX)
	_ensure_bus(BUS_VOICE)
	apply_volumes_from_progress()


func _ensure_bus(bus_name: String) -> void:
	if AudioServer.get_bus_index(bus_name) == -1:
		AudioServer.add_bus()
		var idx := AudioServer.bus_count - 1
		AudioServer.set_bus_name(idx, bus_name)
		AudioServer.set_bus_send(idx, "Master")


func apply_volumes_from_progress() -> void:
	set_volume_percent(BUS_MUSIC, ProgressService.volumes.get("music", 45))
	set_volume_percent(BUS_SFX, ProgressService.volumes.get("sfx", 70))
	set_volume_percent(BUS_VOICE, ProgressService.volumes.get("voice", 80))
	set_master_muted(not ProgressService.sound_enabled)


func set_volume_percent(bus_name: String, percent: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	var linear: float = clamp(percent / 100.0, 0.0, 1.0)
	AudioServer.set_bus_volume_db(idx, linear_to_db(max(linear, 0.0001)) if linear > 0.0 else -80.0)


func set_master_muted(muted: bool) -> void:
	var idx := AudioServer.get_bus_index("Master")
	if idx != -1:
		AudioServer.set_bus_mute(idx, muted)


## Ducks the Music bus by 10dB while voice is speaking, restoring over 300ms after
## (APP_SPEC 5.6: "giảm nhạc nền khoảng 8-12 dB; khôi phục trong 300 ms").
func duck_music_for(duration_sec: float) -> void:
	var idx := AudioServer.get_bus_index(BUS_MUSIC)
	if idx == -1:
		return
	var base_db := AudioServer.get_bus_volume_db(idx)
	if _duck_tween:
		_duck_tween.kill()
	_duck_tween = create_tween()
	_duck_tween.tween_property(AudioServer, "bus_volume_db", base_db - 10.0, 0.05)
	_duck_tween.tween_interval(duration_sec)
	_duck_tween.tween_method(func(v): AudioServer.set_bus_volume_db(idx, v), base_db - 10.0, base_db, 0.3)


## Safe no-op playback helpers — wire these to real AudioStreamPlayer nodes with
## licensed .ogg assets once available (see asset-manifest.csv AUD-* rows).
func play_sfx(_cue_id: String) -> void:
	pass


func play_bgm(_cue_id: String) -> void:
	pass


func play_voice(_cue_id: String) -> void:
	pass
