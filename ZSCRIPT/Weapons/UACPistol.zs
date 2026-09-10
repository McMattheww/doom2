//based on UACPistol found in credits


class UACPistol : BaseWeapon{
	

	Default{
		Obituary "%o got shot by %k.";
		AttackSound "weapons/gock";
		Inventory.pickupmessage "Picked up an UAC Standard Pistol.";
		Weapon.SelectionOrder 2;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 0;
		Weapon.AmmoGive2 0;
		Weapon.SlotNumber 2;
		Weapon.kickback 100;
		Weapon.AmmoType1 "UACPistolAmmo";
		Weapon.AmmoType2 "PistolAmmo";
		Decal "BulletChip";
	}
	

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
}


class UACPistolAmmo : WeaponAmmo{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 18;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 18;
	}

}
