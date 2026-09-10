class InventoryMenu : GenericMenu {
	ButtonGrid grid; 
	int selection; //what button in the ButtonGrid is selected
	int virtualX; //coordinate space in which menu elements are defined
	int virtualY;
	TextureID texID;  //texture for buttons in the ButtonGrid, resolution should be same as Size so the drawn button area matches the mouse collision area
	InventoryPlayerPawn p; //the player, use network events to modify
	Inventory item;	//selected item instance
	Array<Inventory> items; //list of valid player inventory items to be drawn in inventory
	String selectedItem; //classname of seleted inventory item
	
    override void Init(Menu parent) {
        Super.Init(parent);
		p = InventoryPlayerPawn(players[consoleplayer].mo);
		virtualX = 640; 
		virtualY = 480;
		selection = p.selectionIndex;	//set initial selection index to user's last picked
		texID = TexMan.CheckForTexture("SQRE", TexMan.TYPE_ANY);
		grid = new("ButtonGrid").init(6, 6, 64, 4, (virtualX/2,virtualY/2), virtualX, virtualY);
    }
	
	override void Drawer() {
		Super.Drawer(); GenerateItemList();
		String sub; String amt;
		
		if (selection < items.size()){selectedItem = items[selection].GetClassName();}
		else {selectedItem = "none";}
		
		for (int i = 0; i < grid.originX.size(); i++){
			if (selection == i){
				Screen.DrawTexture(texID, true, grid.originX[i], grid.originY[i], DTA_VirtualWidth, virtualX, DTA_VirtualHeight, virtualY, DTA_ALPHA, 0.8);
			}
			else {
				Screen.DrawTexture(texID, true, grid.originX[i], grid.originY[i], DTA_VirtualWidth, virtualX, DTA_VirtualHeight, virtualY, DTA_ALPHA, 0.4);
			}
			if (i < items.size()){
				item = items[i];
				sub = item.GetClassName(); sub = sub.Mid(0, 7);
				amt = String.Format("%i", item.amount);
				Screen.DrawText(SmallFont,Font.CR_BLUE, grid.originX[i]+24, grid.originY[i]+20, amt, DTA_VirtualWidth, virtualX, DTA_VirtualHeight, virtualY);
				Screen.DrawText(SmallFont,Font.CR_BLUE, grid.originX[i]+2, grid.originY[i]+50, sub, DTA_VirtualWidth, virtualX, DTA_VirtualHeight, virtualY);
				Screen.DrawTexture(item.Icon, true, grid.originX[i]+32, grid.originY[i]+32, DTA_VirtualWidth, virtualX, DTA_VirtualHeight, virtualY, DTA_ALPHA, 0.8, DTA_FULLSCREEN);
			}
		}
		console.printf("selected: %s", selectedItem);
	}
	
	override bool MenuEvent(int mkey, bool fromController) {
		if (mkey == MKEY_Left){
			if (selection % grid.cols == 0){
				selection += grid.cols - 1;
			}
			else{
				selection --;
			}
		}
		if (mkey == MKEY_Right){
			if (selection % grid.cols == (grid.cols-1)){
				selection -= (grid.cols - 1);
			}
			else{
				selection ++;
			}
		}
		if (mkey == MKEY_Up){
			selection -= grid.cols;
			if (selection < 0){
				selection += (grid.cols * grid.rows);
			}
		}
		if (mkey == MKEY_Down){
			selection += grid.cols;
			selection = selection % (grid.cols * grid.rows);
		}
		if (mkey == MKEY_Enter){
			EventHandler.SendNetworkEvent(selectedItem);
		}
		if (mkey == MKEY_Back){
			EventHandler.SendNetworkEvent("saveIndex", selection);
		}
		return Super.MenuEvent(mkey, fromController);
	}
	
	override bool MouseEvent(int type, int x, int y){
		if (type == MOUSE_Click){
			int newSelction = grid.CoordsToSelection(x, y);
			if (newSelction != -1){
				return MenuEvent(MKEY_Enter, true);
			}
		}
		if (type == MOUSE_Move){
			int newSelection = grid.CoordsToSelection(x, y);
			if (newSelection != -1){selection = newSelection;}
		}
		return Super.MouseEvent(type, x, y);
	}
	
	//generate a list of the player's inventory items to be drawn in the inventory
	void GenerateItemList(){
		items.Clear();
		for (Inventory item = p.Inv; item != null; item = item.Inv) {
			if (item.amount != 0){ Items.push(item); }
		}
	}
	
}


class ButtonGrid : Object{
	int rows; int cols;
	int size; // collision size of buttons, should match the sprite size of the button
	int offset; // how far apart buttons are spaced
	vector2 center; //where on screen(virtual coords) grid is centered
	Array<int> originX; //list of all buttons x origin, draw stuff or detect collision based on it
	Array<int> originY; //list of all buttons y origin
	int virtualX; int virtualY;	//virtual coordinate space buttons exist in
	

	ButtonGrid Init(int rows, int cols, int size, int offset, vector2 center, int virtualX, int virtualY){
		self.rows = rows;
		self.cols = cols;
		self.size = size;
		self.offset = offset;
		self.center = center;
		self.virtualX = virtualX;
		self.virtualY = virtualY;
		GenerateOrigins();
		return self;
	}
	
	void GenerateOrigins(){
		int totalPx = (cols * size) + ((cols - 1) * offset);
		int totalPy = (rows * size) + ((rows - 1) * offset);
		int x = center.x - (totalPx / 2);
		int y = center.y - (totalPy / 2);
		for (int i = 0; i < rows; i++){
			for (int j = 0; j < cols; j++){
				originX.push(x);
				originY.push(y);
				x += (size + offset);
			}
			x = center.x - (totalPx / 2);
			y += (size + offset);
		}
	}
	
	//translate mouse real XY coordinates to a new button selection index
	// returns -1 if no button selected
	int CoordsToSelection(int x, int y){
		int selection = -1;
		for (int i =0; i < originX.size(); i++){
			vector2 lower = Screen.VirtualToRealCoords((originX[i], originY[i]), (Screen.GetHeight(), Screen.GetWidth()), (virtualX, virtualY));
			vector2 upper = Screen.VirtualToRealCoords((originX[i]+size, originY[i]+size), (Screen.GetHeight(), Screen.GetWidth()), (virtualX, virtualY));
			if (x >= lower.x && x <= upper.x &&y >= lower.y && y <= upper.y){
				selection = i;
			}
		}
		return selection;
	}
	
}
