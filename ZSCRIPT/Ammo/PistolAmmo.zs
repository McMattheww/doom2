class PistolAmmo : SubtypedAmmo{
    Default
    {
        inventory.PickupMessage "Picked up a 10mm clip.";
        inventory.Amount 0;
        inventory.MaxAmount 0;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount 0;
        Inventory.Icon "MAGNB0";
		SubtypedAmmo.subAmmo1 "FMJ";
		SubtypedAmmo.subAmmo2 "JHP";
		SubtypedAmmo.subAmmo3 "PEN";
    }
	
	override void PostBeginPlay(){
		super.PostBeginPlay();
		
	}
	
    States
    {
    Spawn:
        MAGN A -1;
        Stop;
    }
}

class FMJ : PistolAmmo{
	Default
    {
        Inventory.PickupMessage "Picked up a 10mm FMJ rounds.";
		inventory.MaxAmount 1000;
		Ammo.BackpackMaxAmount 1000;
    }
	
}

class JHP : PistolAmmo{
	Default
    {
        Inventory.PickupMessage "Picked up a 10mm JHP rounds.";
		inventory.MaxAmount 1000;
		Ammo.BackpackMaxAmount 1000;
    }
}
	
class PEN : PistolAmmo{
	Default
    {
        Inventory.PickupMessage "Picked up a 10mm teflon coated steel rounds.";
		inventory.MaxAmount 1000;
		Ammo.BackpackMaxAmount 1000;
    }
	
}