extends "res://content/monster/Monsters.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func init():
	super.init()
	GameWorld.archipelago.trap_received.connect(self.trap_received)

func trap_received():
	var wcd = Data.of("monsters.wavecooldown")
	wcd -= CONSTARRC.SECONDS_LOST_PER_TRAP
	Data.apply("monsters.waveCooldown", wcd)
