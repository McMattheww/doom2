
Class InventoryHandler : EventHandler {
	override void NetworkProcess(ConsoleEvent e){
		InventoryPlayerPawn p = InventoryPlayerPawn(players[e.player].mo);
		BaseWeapon b = BaseWeapon(players[e.player].ReadyWeapon);
		if (e.name == "inventoryOpen"){ Menu.SetMenu("InventoryMenu"); }
		else if (e.name == "saveIndex"){ p.selectionIndex = e.Args[0]; }
		else if (e.name == "ammoCycle"){ if (b != null){ b.A_CycleAmmo(b.activeAmmo+1);} }
		//if no specific event name identified, event name is used as String argument to drop specific item
		else { p.A_DropInventory(e.name, 1); }
	}
}
