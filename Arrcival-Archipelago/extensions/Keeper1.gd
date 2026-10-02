extends "res://content/keeper/keeper1/Keeper1.gd"

# copy paste
func drill_check() -> void :
    drill_hit_test_ray.rotation = moveDirectionInput.angle()

    drill_hit_test_ray.force_raycast_update()
    var tile = drill_hit_test_ray.get_collider()

    if not tile or not tile.has_meta("destructable"):
        return
    if not tile.get_meta("destructable"):
        if Data.of(playerId + ".keeper1.destroyindestructibletiles"):
            if not Level.map.isWithinBounds(tile.coord):
                return
        else:
            return


    synchronizer.network_rpc(play_drill_anim.bind(drill_hit_test_ray.rotation + PI, tile.coord), true)

    var hits_needed_to_destroy: float = float(tile.max_health) / float(Data.of(playerId + ".keeper1.drillStrength"))
    synchronizer.network_rpc(emit_sparks.bind(drill_hit_test_ray.get_collision_point(), tile.coord, hits_needed_to_destroy, drill_hit_test_ray.rotation + PI), true)

    var dir = global_position - tile.global_position
    var drillStrength = Data.of(playerId + ".keeper1.drillStrength")
    if tile.hardness >= 3:
        var tilehardnessmodifier = Data.ofOr(playerId + ".keeper1.hardtilesmodifier", 1.0)
        drillStrength *= tilehardnessmodifier

    # Archipelago addition
    drillStrength *= GameWorld.archipelago.get_mining_multiplier()

    tile.hit(dir, drillStrength, teamId, techId)
    emit_signal("mined", 0.1)

    if Options.shakeDrill:
        InputSystem.shakeTarget(self, 20, 0.2, 8)

    var knockback = Data.of(playerId + ".keeper1.acceleration") * Data.of(playerId + ".keeper1.tileKnockback")
    hitCooldown = Data.of(playerId + ".keeper1.tileHitCooldown")
    var drillbuff = 1.0 - float(Data.of(playerId + ".keeper.drillBuff"))

    moveSlowdown = 0.25 + currentSpeed() * 0.01
    if drillbuff < 1.0:
        hitCooldown = max(hitCooldown * drillbuff, 0.017)
        knockback *= drillbuff
    if abs(dir.x) > abs(dir.y):
        move.x = sign(dir.x) * knockback
        move.y *= 0.1
    else:
        move.y = sign(dir.y) * knockback
        move.x *= 0.1

    tileHit.emit()

func currentSpeed() -> float:
    var speed = super.currentSpeed()
    if not GameWorld.archipelago.is_relic_hunt():
        speed *= GameWorld.archipelago.get_speed_multiplier()

    return speed