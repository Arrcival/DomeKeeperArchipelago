class_name ArchipelagoProgression

var relic: ArchipelagoRelicProgression = ArchipelagoRelicProgression.new()
var guild: ArchipelagoAssignmentProgression = ArchipelagoAssignmentProgression.new()
var slot_data: ArchipelagoSlotData
var died_to_death_link: bool = false
signal log_informations(text: String)
signal trap_received

func setup(progression_slot_data: ArchipelagoSlotData) -> void:
	slot_data = progression_slot_data
	relic.setup(progression_slot_data)
	guild.setup(progression_slot_data)
	relic.log_informations.connect(_on_relic_log)
	relic.trap_received.connect(_on_relic_trap)

func reset() -> void:
	relic.reset()
	guild.reset()
	died_to_death_link = false

func reset_given_resources() -> void:
	relic.reset_given_resources()
	guild.reset_given_resources()

# Returns resources received since the previous call and marks them as given.
# Relic and guild progression are mutually exclusive, but both are included so
# this remains correct if a progression mode changes or receives mixed data.
func consume_resource_deltas() -> Dictionary:
	var sand := 0
	var water := 0
	var iron := 0

	if relic.cobaltRetrieved > relic.cobaltGiven:
		sand += relic.cobaltRetrieved - relic.cobaltGiven
		relic.cobaltGiven = relic.cobaltRetrieved
	if relic.waterRetrieved > relic.waterGiven:
		water += relic.waterRetrieved - relic.waterGiven
		relic.waterGiven = relic.waterRetrieved
	if relic.ironRetrieved > relic.ironGiven:
		iron += relic.ironRetrieved - relic.ironGiven
		relic.ironGiven = relic.ironRetrieved

	if guild.cobaltRetrieved > guild.cobaltGiven:
		sand += guild.cobaltRetrieved - guild.cobaltGiven
		guild.cobaltGiven = guild.cobaltRetrieved
	if guild.waterRetrieved > guild.waterGiven:
		water += guild.waterRetrieved - guild.waterGiven
		guild.waterGiven = guild.waterRetrieved
	if guild.ironRetrieved > guild.ironGiven:
		iron += guild.ironRetrieved - guild.ironGiven
		guild.ironGiven = guild.ironRetrieved

	return {"sand": sand, "water": water, "iron": iron}

func process_item(item_id: int) -> bool:
	if slot_data.is_guild_assignment():
		return guild.process_item(item_id)
	return relic.process_item(item_id)

func is_immediate_item(item_id: int) -> bool:
	return slot_data.is_guild_assignment() and guild.is_assignment_unlock_item(item_id)

func mark_death_link_death() -> void:
	died_to_death_link = true

func consume_death_link_death() -> bool:
	if not died_to_death_link:
		return false
	died_to_death_link = false
	return true

func _on_relic_trap() -> void:
	trap_received.emit()

func _on_relic_log(text: String) -> void:
	log_informations.emit(text)

func get_relic_hunt_stats() -> String:
	if slot_data.is_guild_assignment():
		return ""
	else: 
		return relic.get_relic_hunt_stats()

func get_speed_multiplier() -> float:
	if slot_data.is_guild_assignment():
		return guild.get_speed_multiplier()
	else:
		return 1

func get_mining_multiplier() -> float:
	if slot_data.is_guild_assignment():
		return guild.get_mining_multiplier()
	else:
		return 1