extends Node

# Persists player progress to user://progress.json (FR-07, NFR-07).
# Recovers safely to fresh defaults if the file is missing or corrupt (NFR-07).

const SAVE_PATH := "user://progress.json"
const SCHEMA_VERSION := 1

var unlocked_up_to := 1
var stars: Dictionary = {} # level_id (String) -> int 0..3
var has_played_tutorial := false
var stats := {
	"addition_attempted": 0, "addition_correct": 0,
	"subtraction_attempted": 0, "subtraction_correct": 0,
	"regrouping_attempted": 0, "regrouping_correct": 0,
}
var volumes := {"music": 45, "sfx": 70, "voice": 80}
var sound_enabled := true


func _ready() -> void:
	load_progress()


func load_progress() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_reset_to_defaults()
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("ProgressService: could not open save file, resetting to defaults.")
		_reset_to_defaults()
		return

	var text := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if parsed == null or not (parsed is Dictionary) or not parsed.has("schema_version"):
		push_warning("ProgressService: save file corrupt or unrecognized, resetting to defaults.")
		_reset_to_defaults()
		return

	unlocked_up_to = parsed.get("unlocked_up_to", 1)
	stars = parsed.get("stars", {})
	has_played_tutorial = parsed.get("has_played_tutorial", false)
	stats = parsed.get("stats", stats)
	volumes = parsed.get("volumes", volumes)
	sound_enabled = parsed.get("sound_enabled", true)


func save_progress() -> void:
	var data := {
		"schema_version": SCHEMA_VERSION,
		"unlocked_up_to": unlocked_up_to,
		"stars": stars,
		"has_played_tutorial": has_played_tutorial,
		"stats": stats,
		"volumes": volumes,
		"sound_enabled": sound_enabled,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("ProgressService: could not write save file.")
		return
	file.store_string(JSON.stringify(data))
	file.close()


func _reset_to_defaults() -> void:
	unlocked_up_to = 1
	stars = {}
	has_played_tutorial = false
	stats = {
		"addition_attempted": 0, "addition_correct": 0,
		"subtraction_attempted": 0, "subtraction_correct": 0,
		"regrouping_attempted": 0, "regrouping_correct": 0,
	}
	volumes = {"music": 45, "sfx": 70, "voice": 80}
	sound_enabled = true
	save_progress()


func reset_all_progress() -> void:
	# Called from the Adult Area after explicit confirmation (APP_SPEC 5.5).
	_reset_to_defaults()


func record_level_pass(level_id: int, stars_earned: int) -> void:
	var key := str(level_id)
	var prev: int = stars.get(key, 0)
	stars[key] = max(prev, stars_earned)
	unlocked_up_to = max(unlocked_up_to, min(level_id + 1, 10))
	save_progress()


func record_answer(operation: String, is_regrouping: bool, correct: bool) -> void:
	var attempted_key := "%s_attempted" % operation
	var correct_key := "%s_correct" % operation
	stats[attempted_key] = stats.get(attempted_key, 0) + 1
	if correct:
		stats[correct_key] = stats.get(correct_key, 0) + 1
	if is_regrouping:
		stats["regrouping_attempted"] = stats.get("regrouping_attempted", 0) + 1
		if correct:
			stats["regrouping_correct"] = stats.get("regrouping_correct", 0) + 1
	save_progress()


func levels_completed_count() -> int:
	var count := 0
	for k in stars.keys():
		if stars[k] > 0:
			count += 1
	return count


func accuracy_text(correct: int, attempted: int) -> String:
	if attempted == 0:
		return "Chưa có dữ liệu"
	return "%d%%" % round(float(correct) / float(attempted) * 100.0)
