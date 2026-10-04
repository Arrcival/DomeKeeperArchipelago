extends "res://stages/intro/IntroStage.gd"

func beforeStart():
    super.beforeStart()
    if OS.is_debug_build():
        var animation_player: AnimationPlayer = find_child("IntroAnimation")
        animation_player.speed_scale = 10

func end_animation():
    super.end_animation()
    if OS.is_debug_build():
        finishStage()