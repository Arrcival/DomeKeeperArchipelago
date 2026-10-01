extends "res://content/techtree/TechTreePopup.gd"

# Currently not called due to a preloaded issue
func _ready():
    super._ready()
    var bbCodeDescription: RichTextLabel = find_child("TechDescription")
    bbCodeDescription.bbcode_enabled = true