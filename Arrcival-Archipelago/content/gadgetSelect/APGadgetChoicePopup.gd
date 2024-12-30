extends "res://stages/level/GadgetChoicePopup.gd"

func generateOffers():
	var offer:Array
	var goalCount:int
	var to_exclude = []
	for x in gadgets:
		if not x.has("dropType"):
			# don't consider drop type offers here
			to_exclude.append(x.id)
			
	to_exclude.append("archipelago")
	
	
	if droptype == CONST.POWERCORE:
		offer = GameWorld.generateSupplements(to_exclude)
		goalCount = Data.of("artifacts.supplementChoicesPerArtifact")
	else:
		offer = GameWorld.generateGadgets(to_exclude)
		goalCount = Data.of("artifacts.gadgetChoicesPerArtifact")
	
	while offer.size() < goalCount and to_exclude.size() > 0:
		var id = to_exclude.pick_random()
		if Data.gadgets.has(id):
			offer.append(Data.gadgets[id])
		elif Data.supplements.has(id):
			offer.append(Data.supplements[id])
		else:
			continue
		to_exclude.erase(id)
	
	var freeReroll = Data.ofOr("gadgetselection.freereroll", false) and rerollCount == 0 
	var paidReroll = Data.ofOr("gadgetselection.paidreroll", false) 
	var rerollPossible = (freeReroll or paidReroll) and (offer.size() + to_exclude.size()) > goalCount
	if droptype == CONST.GADGET:
		rerollPossible = rerollPossible and not GameWorld.useCustomGadgetOrder
	elif droptype == CONST.POWERCORE:
		rerollPossible = rerollPossible and not GameWorld.useCustomSupplementOrder
	
	%RerollButton.visible = rerollPossible
	if freeReroll:
		%RerollButton.icon = null
	else:
		%RerollButton.disabled = Data.ofOr("inventory.water", 0) <= 0
		%RerollButton.icon = preload("res://content/icons/icon_water.png")
	
	for c in %Gadgets.get_children():
		%Gadgets.remove_child(c)
		c.queue_free()
	
	offer.resize(min(goalCount, offer.size()))
	
	offer.append({
		"id": "shredgadgettocobalt", 
		"dropType": CONST.SAND, 
		"amount": 2})
	
	var count = offer.size()
	self.gadgets = offer
	
	if count % 2 == 0 and count <= 4:
		find_child("Gadgets").columns = 2
	else:
		find_child("Gadgets").columns = 3
	
	for g in gadgets:
		var id = g.get("id", "missing_id")
		var choice
		if Data.supplements.has(id):
			choice = preload("res://stages/level/SupplementChoice.tscn").instantiate()
			choice.fillSupplement(g)
		else:
			choice = preload("res://stages/level/GadgetChoice.tscn").instantiate()
			choice.fillGadget(g)
		
		%Gadgets.add_child(choice)
		choice.connect("focussed", optionFocussed.bind(g, choice))
		choice.connect("selected", emit_signal.bind("selected_by_mouse"))
	
	InputSystem.grabFocus(%Gadgets.get_children().front())
