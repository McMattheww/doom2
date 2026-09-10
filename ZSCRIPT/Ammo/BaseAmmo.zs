class WeaponAmmo : Ammo
{
	Default{
		Inventory.Amount 0;
		Ammo.BackpackAmount 0;
		+INVENTORY.UNDROPPABLE;
		+INVENTORY.UNTOSSABLE;
		+INVENTORY.IGNORESKILL;
	}

    override class<WeaponAmmo> GetParentAmmo(){
		class<Object> type = GetClass();
		while(type.GetParentClass()!= "WeaponAmmo"&&type.GetParentClass()!=null) type = type.GetParentClass();
		return(class<WeaponAmmo>)(type);
	}
}


class SubtypedAmmo : Ammo {
	class<SubtypedAmmo> subAmmo1;
	class<SubtypedAmmo> subAmmo2;
	class<SubtypedAmmo> subAmmo3;
	class<SubtypedAmmo> subAmmo4;
	
	property subAmmo1: subAmmo1;
	property subAmmo2: subAmmo2;
	property subAmmo3: subAmmo3;
	property subAmmo4: subAmmo4;
	
	Default{
		SubtypedAmmo.subAmmo1 "none";
		SubtypedAmmo.subAmmo2 "none";
		SubtypedAmmo.subAmmo3 "none";
		SubtypedAmmo.subAmmo4 "none";
	}
	
	override class<SubtypedAmmo> GetParentAmmo(){
		class<Object> type = GetClass();
		while(type.GetParentClass()!= "SubtypedAmmo"&&type.GetParentClass()!=null) type = type.GetParentClass();
		return(class<SubtypedAmmo>)(type);
	}


}