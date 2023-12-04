extends Node
class_name BlocksThemeTemplate

static var BeginEnd: Theme
static var HandInput: Theme
static var Output: Theme
static var Condition: Theme
static var Process: Theme

static func _static_init():
	var styledBoxTexture = StyleBoxTexture.new()
	styledBoxTexture.texture = load("res://Data/Assets/Textures/blocks_textures.tres")
	styledBoxTexture.region_rect = Rect2(544, 270, 243, 127)
	BeginEnd = Theme.new()
	BeginEnd.set_stylebox("panel", "Panel", styledBoxTexture.duplicate(true))
	styledBoxTexture.region_rect = Rect2(651, 39, 241, 182)
	HandInput = Theme.new()
	BeginEnd.set_stylebox("panel", "Panel", styledBoxTexture.duplicate(true))
	styledBoxTexture.region_rect = Rect2(309, 36, 289, 136)
	Output = Theme.new()
	BeginEnd.set_stylebox("panel", "Panel", styledBoxTexture.duplicate(true))
	styledBoxTexture.region_rect = Rect2(125, 207, 256, 186)
	Condition = Theme.new()
	BeginEnd.set_stylebox("panel", "Panel", styledBoxTexture.duplicate(true))
	styledBoxTexture.region_rect = Rect2(30, 31, 231, 134)
	Process = Theme.new()
	BeginEnd.set_stylebox("panel", "Panel", styledBoxTexture.duplicate(true))
