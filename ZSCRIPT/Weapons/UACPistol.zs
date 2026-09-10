//based on UACPistol found in credits

//I made this weapon as an example weapon that uses multiple ammo types
//press user1 key to cycle through available ammo types
//another issue: currently ammo types are cycled through one at a time using a single key press user1, there is no way to select a specific type of subammo with a single action

class UACPistol : BaseWeapon{
	

	Default{
		Obituary "%o got shot by %k.";
		//+WEAPON.NOAUTOFIRE;
		//+WEAPON.Ammo_CheckBoth;
		+WEAPON.ALT_USES_BOTH;
		AttackSound "weapons/gock";
		Inventory.pickupmessage "Picked up an UAC Standard Pistol.";
		Weapon.SelectionOrder 2;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 0;
		Weapon.AmmoGive2 0;
		Weapon.SlotNumber 2;
		Weapon.kickback 100;
		//Weapon.AmmoType "Clip";
		Weapon.AmmoType1 "UACPistolAmmo";
		Weapon.AmmoType2 "PistolAmmo";
		Decal "BulletChip";
	}
	
	override void PostBeginPlay(){
		super.PostBeginPlay();
		//ammo2 = AddAmmo(Owner, "Clip", 5);
	}

	States
  {
  Spawn:
   DEPI A -1;
   Stop;
  Ready:
   DPIG A 1 A_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER1);
   Loop;
  Deselect:
   DPIG A 1 A_Lower;
   Loop;
  Select:
   DPIG A 1 A_Raise;
   Loop;
  Fire:
   TNT1 A 0 A_GunFlash;
   DPIF A 2 Bright A_FireBullets(2,2,-1,6,"BulletPuff",1);
   DPIG C 3;
   DPIG A 3 A_JumpIf(invoker.Ammo1.amount == 0,"DryFire");
   Goto Ready;
  AltFire:
   TNT1 A 0 A_GunFlash;
   DPIF A 2 Bright A_FireBullets(2,2,-1,6,"BulletPuff",1);
   DPIG C 3;
   TNT1 A 0 A_JumpIfInventory("UACPistolAmmo",0,"DryFire");
   DPIF A 2 Bright A_FireBullets(2,2,-1,6,"BulletPuff",1);
   DPIG C 3;
   TNT1 A 0 A_JumpIfInventory("UACPistolAmmo",0,"DryFire");
   DPIF A 2 Bright A_FireBullets(2,2,-1,6,"BulletPuff",1);
   DPIG C 3;
   DPIG A 3 A_JumpIfInventory("UACPistolAmmo",0,"DryFire");
   Goto Ready;
  DryFire:
   DPIG A 6;
   DPIG A 6 A_PlaySound("weapons/glockdry");
   Goto Reload;
  Reload:
   NULL A 0 A_JumpIf(invoker.Ammo1.amount == invoker.Ammo1.MaxAmount, "Ready"); // If your magazine is loaded, jump to ReloadFull state.
   NULL A 0 A_JumpIfMagazineGreaterReserves("Ready");  //check if no reserve ammos have more ammo than current clip, if so goto ready 
   NULL A 0 A_JumpIf(invoker.Ammo2.amount == 0,"User1"); //if you have no reserve ammo for the currently selected type, try to cycle ammo type
   DPIR A 3 A_LoadClip(); // fill weapon clip until full or reserve ammo is depleted
   DPIR B 3 A_Playsound ("CLIPOUT");
   DPIR C 3;
   DPIR D 3;
   DPIR E 3;
   DPIR F 3 A_Playsound ("CLIPIN");
   DPIR G 3;
   DPIR H 3;
   DPIR I 3;
   DPIR J 3;
   DPIG A 3;
   Goto Ready;
  ReloadFull:
   DPIG A 0 A_WeaponReady; // State your gun jumps into if you hold down Reload on a full mag. Keep it like this, or add an inspect animation.
   Goto Ready;
  Flash:
   TNT1 A 2 A_Light2;
   TNT1 A 2 A_Light1;
Goto LightDone;
	User1:
		TNT1 A 0 A_JumpIf(!invoker.checkAmmo(true, true, true, 1),"Ready"); //if no reserve ammo types are available, jump to ready, where the normal ammo check will then force a deselect
		TNT1 A 0 A_CycleAmmo2(); //at least one reserve ammo type has ammo, cycle ammo types until we find one that has ammunition
		Goto Reload;
  }


/*
	States
  {
  Spawn:
   DEPI A -1;
   Stop;
  Ready:
   TNT1 A 0 A_JumpIf(CountInv("UACPistolAmmo")==18,"ReadyNoReload");
   DPIG A 1 A_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER1);
   Loop;
  ReadyNoReload:
   DPIG A 1 A_WeaponReady(WRF_ALLOWUSER1);
   Goto Ready;
  Deselect:
   DPIG A 1 A_Lower;
   Loop;
  Select:
   DPIG A 1 A_Raise;
   Loop;
  Fire:
   TNT1 A 0 A_GunFlash;
   DPIF A 2 Bright A_FireBullets(2,2,-1,6,"BulletPuff",1);
   DPIG C 3;
   DPIG A 3 A_JumpIf(CountInv("UACPistolAmmo")==0,"DryFire");
   Goto Ready;
  AltFire:
   TNT1 A 0 A_GunFlash;
   DPIF A 2 Bright A_FireBullets(2,2,-1,6,"BulletPuff",1);
   DPIG C 3;
   TNT1 A 0 A_JumpIfInventory("UACPistolAmmo",0,"DryFire");
   DPIF A 2 Bright A_FireBullets(2,2,-1,6,"BulletPuff",1);
   DPIG C 3;
   TNT1 A 0 A_JumpIfInventory("UACPistolAmmo",0,"DryFire");
   DPIF A 2 Bright A_FireBullets(2,2,-1,6,"BulletPuff",1);
   DPIG C 3;
   DPIG A 3 A_JumpIfInventory("UACPistolAmmo",0,"DryFire");
   Goto Ready;
  DryFire:
   DPIG A 6;
   DPIG A 6 A_PlaySound("weapons/glockdry");
   //TNT1 A 0 A_CheckCycleAmmo("User1");
   //TNT1 A 0 A_JumpIf(invoker.Ammo2.amount!=0,"Reload");
   Goto Reload;
  Reload:
   TNT1 A 0 A_JumpIf(invoker.Ammo2.amount == 0,"User1");
   DPIR A 3 A_LoadClip();
   DPIR B 3 A_Playsound ("CLIPOUT");
   DPIR C 3;
   DPIR D 3;
   DPIR E 3;
   DPIR F 3 A_Playsound ("CLIPIN");
   DPIR G 3;
   DPIR H 3;
   DPIR I 3;
   DPIR J 3;
   DPIG A 3;
   Goto Ready;
  Flash:
   TNT1 A 2 A_Light2;
   TNT1 A 2 A_Light1;
Goto LightDone;
	User1:
		TNT1 A 0 A_JumpIf(!invoker.checkAmmo(true, true, true, 1),"Ready");
		TNT1 A 0 A_CycleAmmo2();
		Goto Reload;
  }
  */
}


class UACPistolAmmo : WeaponAmmo{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 18;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 18;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "D4E0Z0";
	}

}
