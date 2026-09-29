class_name ArchipelagoCaveSynchronizer
extends Synchronizer

func _ready() -> void :
    super ._ready()

    owner.hit.connect(on_scanner_hit)

func on_scanner_hit(keeper: Keeper) -> void :
    network_rpc(remote_scanner_hit.bind(keeper.playerId), true)

@rpc("reliable", "any_peer")
func remote_scanner_hit(playerId: String) -> void :
    owner.registerHit(playerId)