extends "res://content/keeper/keeper4/Keeper4.gd"

func hit_tile(tile, dir):
    var damage = Data.of(playerId + ".keeper4.punchstrength")

    var punch_value: = 1.0
    var drillBuff: float = Data.ofOr(playerId + ".keeper.drillBuff", 0.0)
    if drillBuff > 0.0:
        punch_value += drillBuff * 3.0 * (1.0 - currentSpeedup)
        damage *= 1.0 + drillBuff * currentSpeedup
    tilePunchCount = min(tilePunchCount + punch_value, float(Data.of(playerId + ".keeper4.maxSpeedupAtPunches")))

    # Archipelago bonus
    damage *= GameWorld.archipelago.get_mining_multiplier()

    if is_multiplayer_authority():
        tile.hit(dir, damage, teamId, techId)
        timeSinceLastPunch = 0.0
        emit_signal("mined", 0.02)
        if Options.shakeDrill:
            InputSystem.getCamera(playerId).shake(20, 0.2, 8)
    if _dig_upgrade_level >= 4:
        $RageHit.baseVolume = lerpf(-20.0, -6.0, currentSpeedup)
        $RageHit.startSound()
    if isMiningMode:
        mining_recoil_offset = Keeper4GameplaySettings.MINING_OSCILLATION_AMPLITUDE

    if tile.health <= 0:
        if currentMiningTile == tile:
            pending_tile_destroyed = true

    emit_signal("tileHit")
    if is_multiplayer_authority():
        synchronizer.network_rpc(playSoundsAndSparks.bind(tile.coord, tile.health, tile.max_health, tile.type, tile.hardness), true)


func currentSpeed() -> float:
    var speed = super.currentSpeed()
    if not GameWorld.archipelago.is_relic_hunt():
        speed *= GameWorld.archipelago.get_speed_multiplier()

    return speed