extends Object

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func init(chain: ModLoaderHookChain):
	chain.execute_next()
	var main_node : Node = chain.reference_object
	GameWorld.archipelago.trap_received.connect(self.trap_received)

func trap_received():
	var wcd = Data.of("monsters.wavecooldown")
	wcd -= CONSTARRC.SECONDS_LOST_PER_TRAP
	Data.apply("monsters.waveCooldown", wcd)
