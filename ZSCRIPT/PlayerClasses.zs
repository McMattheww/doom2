class InventoryPlayerPawn : DoomPlayer
{
	double maxWeight;
	int selectionIndex; //last selected inventroy item
	Default {
		Player.DisplayName "Inventory test"; 
	}
	
    override void PostBeginPlay(){
        Super.PostBeginPlay();
		selectionIndex = 0;
		maxWeight = 8.0;
		Inventory item = FindInventory("HexenArmor"); if (item != null){RemoveInventory(item);}
		item = FindInventory("pistol"); if (item != null){RemoveInventory(item);}
		item = FindInventory("clip"); if (item != null){RemoveInventory(item);}
	}
	
	double CalcWeight() {
		double weight = 0;
		for (Inventory item = Inv; item != null; item = item.Inv) {
			HasWeight weightBehavior = HasWeight(item.FindBehavior("HasWeight"));
			if (weightBehavior) { weight += (item.Amount * weightBehavior.weight); }
		}
		return weight;
	}
	
	 override bool CanTouchItem(Inventory item){
		HasWeight weightBehavior = HasWeight(item.FindBehavior("HasWeight"));
		if (weightBehavior != null){
			if (CalcWeight() + weightBehavior.weight > maxWeight){ return false; }
		}
		return Super.CanTouchItem(item);
	 }
	 
}




