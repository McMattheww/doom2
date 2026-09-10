// weapon has 2 special behaviors over the normal weapon
// it uses a subtyped ammo instead of normal ammo that allows the user to cycle through ammos
// weightbehavior that does not allow pickup of an object if the player pawn is over its weight limit
class BaseWeapon : DoomWeapon{
	HasWeight weightBehavior;
	int activeAmmo;
	int ammoTypes;
	SubtypedAmmo subAmmo1, subAmmo2, subAmmo3, subAmmo4;
	
	Default{
		inventory.MaxAmount 20;
		Weapon.AmmoUse2 1;
		Weapon.AmmoUse1 1;
		+WEAPON.Ammo_CheckBoth;
		Weapon.AmmoGive 0;
		Weapon.AmmoGive2 0;
	}
	
	override void PostBeginPlay(){
		super.PostBeginPlay();
		weightBehavior = HasWeight(AddBehavior("HasWeight"));
		weightBehavior.weight = 2.0;
	}
	
	action void A_LoadClip(){
		Inventory mag = invoker.Ammo1;
		Inventory source = invoker.Ammo2;
		int diff = mag.maxamount - mag.amount;
		int remaining = source.amount;
		if (remaining == 0){return;}
		if (remaining < diff){diff = remaining;}
		player.mo.A_GiveInventory(invoker.AmmoType1, diff);
		player.mo.A_TakeInventory(invoker.AmmoType2, diff);
	}
	
	action state A_JumpIfMagazineGreaterReserves(StateLabel label){
	console.printf("ribs");
		if ((invoker.subAmmo1 == null || invoker.subAmmo1.amount < invoker.Ammo1.amount) &&
		(invoker.subAmmo2 == null || invoker.subAmmo2.amount < invoker.Ammo1.amount) &&
		(invoker.subAmmo3 == null || invoker.subAmmo3.amount < invoker.Ammo1.amount) &&
		(invoker.subAmmo4 == null || invoker.subAmmo4.amount < invoker.Ammo1.amount)){return ResolveState(label);;}
		else{return null;}
			
	}
	

	action void A_CycleAmmo(int selection){
		Class<Inventory> magazine = invoker.AmmoType1;
		Class<Inventory> source = invoker.AmmoType2;
		Inventory m = invoker.Ammo1;
		Inventory s = invoker.Ammo2;
		int remaining = m.amount; m.amount = 0;
		s.amount += remaining;
		invoker.activeAmmo = selection;
		invoker.activeAmmo %= invoker.ammoTypes;
		if (invoker.activeAmmo == 0){
			invoker.Ammo2 = invoker.subAmmo1;
			invoker.AmmoType2 = invoker.subAmmo1.GetClass();
		}
		else if (invoker.activeAmmo == 1){
			invoker.Ammo2 = invoker.subAmmo2;
			invoker.AmmoType2 = invoker.subAmmo2.GetClass();
		}
		else if (invoker.activeAmmo == 2){
			invoker.Ammo2 = invoker.subAmmo3;
			invoker.AmmoType2 = invoker.subAmmo3.GetClass();
		}
		else if (invoker.activeAmmo == 3){
			invoker.Ammo2 = invoker.subAmmo4;
			invoker.AmmoType2 = invoker.subAmmo4.GetClass();
		}
	}
	
	action void A_CycleAmmo2(){
		Class<Inventory> magazine = invoker.AmmoType1;
		Class<Inventory> source = invoker.AmmoType2;
		Inventory m = invoker.Ammo1;
		Inventory s = invoker.Ammo2;
		int remaining = m.amount; m.amount = 0;
		s.amount += remaining;
		invoker.activeAmmo ++;
		invoker.activeAmmo %= invoker.ammoTypes;
		if (invoker.activeAmmo == 0){
			invoker.Ammo2 = invoker.subAmmo1;
			invoker.AmmoType2 = invoker.subAmmo1.GetClass();
		}
		else if (invoker.activeAmmo == 1){
			invoker.Ammo2 = invoker.subAmmo2;
			invoker.AmmoType2 = invoker.subAmmo2.GetClass();
		}
		else if (invoker.activeAmmo == 2){
			invoker.Ammo2 = invoker.subAmmo3;
			invoker.AmmoType2 = invoker.subAmmo3.GetClass();
		}
		else if (invoker.activeAmmo == 3){
			invoker.Ammo2 = invoker.subAmmo4;
			invoker.AmmoType2 = invoker.subAmmo4.GetClass();
		}
		if (invoker.Ammo2.amount == 0){A_CycleAmmo2();}
	}
	
	
	

	override void AttachToOwner (Actor other)
	{
		Super.AttachToOwner (other);
		activeAmmo = 0;
		ammoTypes = 0;
		if (AmmoType2 != null){
			let source = SubtypedAmmo(GetDefaultByType(AmmoType2));
			if (source != null){
				if (source.subAmmo1 != null){subAmmo1 = SubtypedAmmo(AddAmmo(Owner, source.subAmmo1, AmmoGive2)); console.printf("%s", subAmmo1.GetClassName()); ammoTypes++;}
				if (source.subAmmo2 != null){subAmmo2 = SubtypedAmmo(AddAmmo(Owner, source.subAmmo2, 5)); console.printf("%s", subAmmo2.GetClassName()); ammoTypes++;}
				if (source.subAmmo3 != null){subAmmo3 = SubtypedAmmo(AddAmmo(Owner, source.subAmmo3, 5)); console.printf("%s", subAmmo3.GetClassName()); ammoTypes++;}
				if (source.subAmmo4 != null){subAmmo4 = SubtypedAmmo(AddAmmo(Owner, source.subAmmo4, 5)); console.printf("%s", subAmmo4.GetClassName()); ammoTypes++;}
				Ammo2 = subAmmo1;
				AmmoType2 = subAmmo1.GetClass();
				console.printf("types: %i", ammoTypes);
			}
		}
		//console.printf("%s", AmmoType1.GetClassName());
		//let sourceDefault = GetDefaultByType(AmmoType2.GetClassName());
		//let source = SubtypedAmmo(sourceDefault);
	}
	
	
	override bool CheckAmmo(int fireMode, bool autoSwitch, bool requireAmmo, int ammocount)
	{
		int count1, count2, count3, count4, count5, count6;
		int enough, enoughmask, enoughCycle;
		int lAmmoUse1;
		int lAmmoUse2 = AmmoUse2;

		if (sv_infiniteammo || (Owner.FindInventory ('PowerInfiniteAmmo', true) != null))
		{
			return true;
		}
		if (fireMode == EitherFire)
		{
			bool gotSome = CheckAmmo (PrimaryFire, false) || CheckAmmo (AltFire, false);
			if (!gotSome && autoSwitch)
			{
				PlayerPawn(Owner).PickNewWeapon (null);
			}
			return gotSome;
		}
		let altFire = (fireMode == AltFire);
		let optional = (altFire? bAlt_Ammo_Optional : bAmmo_Optional);
		let useboth = (altFire? bAlt_Uses_Both : bPrimary_Uses_Both);

		if (!requireAmmo && optional)
		{
			return true;
		}
		count1 = (Ammo1 != null) ? Ammo1.Amount : 0;
		count2 = (Ammo2 != null) ? Ammo2.Amount : 0;
		count3 = (subAmmo1 != null) ? subAmmo1.Amount : 0;
		count4 = (subAmmo2 != null) ? subAmmo2.Amount : 0;
		count5 = (subAmmo3 != null) ? subAmmo3.Amount : 0;
		count6 = (subAmmo4 != null) ? subAmmo4.Amount : 0;

		if (bDehAmmo && Ammo1 == null)
		{
			lAmmoUse1 = 0;
		}
		else if (ammocount >= 0)
		{
			lAmmoUse1 = ammocount;
			lAmmoUse2 = ammocount;
		}
		else
		{
			lAmmoUse1 = AmmoUse1;
		}
		
		enoughCycle = (count1 >= lAmmoUse1) | ((count2 >= lAmmoUse2) << 1);
		enough = enoughCycle | ((count3 >= lAmmoUse2) << 1) | ((count4 >= lAmmoUse2) << 1) | ((count5 >= lAmmoUse2) << 1) | ((count6 >= lAmmoUse2) << 1);
		if (useboth)
		{
			enoughmask = 3;
		}
		else
		{
			enoughmask = 1 << altFire;
		}
		if (altFire && FindState('AltFire') == null)
		{ // If this weapon has no alternate fire, then there is never enough ammo for it
			enough &= 1;
		}
		if (((enough & enoughmask) == enoughmask) || (enough && bAmmo_CheckBoth))
		{
			return true;
		}
		// out of ammo, pick a weapon to change to
		if (autoSwitch)
		{
			PlayerPawn(Owner).PickNewWeapon (null);
		}
		return false;
	}
	

}
