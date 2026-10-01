extends "res://content/techtree/TechTreePopup.gd"

func _ready():
    super._ready()
    print("Called in Techtree!!!!")
    var bbCodeDescription: RichTextLabel = find_child("TechDescription")
    bbCodeDescription.bbcode_enabled = true