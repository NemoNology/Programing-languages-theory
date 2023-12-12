class_name FlowchartSaveLoadHandler extends FileDialog

var _flowchart_editor: FlowchartEditor
var _saved: bool = false

signal state_load(flowchart_state: Dictionary)

func _init(flowchart_editor: FlowchartEditor):
	_flowchart_editor = flowchart_editor
	add_filter("*.json", "JSON files")
	access = FileDialog.ACCESS_FILESYSTEM
	file_selected.connect(_on_file_selected)
	dialog_hide_on_ok = true
	min_size = Vector2(640, 480)


func save() -> void:
	if not _saved:
		save_as()
	else:
		var save_file: FileAccess = FileAccess.open(current_path, FileAccess.WRITE)
		save_file.store_string(JSON.stringify(_flowchart_editor.get_state()))
		save_file.close()

func save_as() -> void:
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	popup_centered()


func load() -> void:
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	popup_centered()


func _on_file_selected(path: String):
	_saved = true
	if file_mode == FileDialog.FILE_MODE_SAVE_FILE:
		var save_file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
		save_file.store_string(JSON.stringify(_flowchart_editor.get_state()))
		save_file.close()
	elif file_mode == FileDialog.FILE_MODE_OPEN_FILE:
		if not FileAccess.file_exists(path):
			return
		var loaded_state = JSON.parse_string(FileAccess.get_file_as_string(path))
		if loaded_state != null:
			state_load.emit(loaded_state)
