# InventoryAndHotbar
 A Inventory and Hotbar with Drag and Drop, inspired by Minecraft


The UI Layout and Classes are from the Tutorial created by DevLogLogan (https://www.youtube.com/watch?v=V79YabQZC1s)
but to implement a Minecraft like Inventory and Hotbar System a had to change the Structure a bit.

I keeped the Data Structure:

InventoryData extends Resource (Purpose: Handles the Slots and Interactions with it. It also can be used to create different Inventories (hotbar, inventory, external Inventories (Chests)))
-SlotData extends Resource (Purpose: Separates the Item from the Quantity and the Methodes for handling the Quantity changes)
--ItemData extends Resource (Purpose: Creating different Items based on the Properties of ItemdData)

Fixes that i did:
SlotData: quantity <= MAX_STACK_SIZE (Stopped at 98 otherwise) for "can_merge _with"and "can_fully_merge_with"

My Scene-Tree looks like this:

Global Script: Inventory_Manager

CanvasLayer
    Interfaces (Control-Node)
        InventoryUI (PanelContainer)
            MarginContainer
                ItemsUI (GridContainer)
        HotbarUI (PanelContainer)
            MarginContainer
                Selector (Sprite2D)
                ItemsUI (GridContainer)
        GrabbedSlot (PanelContainer)

In combination with the Global Script we have acces to the Items from anywhere

The HotbarUI Script extends the Script for IventoryUI, because i added a Selector-Frame for the currently selected Slot and the Methods for this just needed to be in the Hotbar-Script

First: I add "Inventory_Manager" to the Global-Scripts
The Inventory_Manager has both InventoryData for HotbarUI and InventoryUI.
I add a Variable of type Int for the "focused_slot".

When the Inventory_Manager is ready, we set the size for the Array "slot_datas". 
hotbar.slot_datas.resize(8) will be 8 Slots and inventory.slot_datas.resize(32) will be 32

In the Script for the Control "Interfaces" we set up the signals for both Components. 
We connect the "inventory_interact"-Signal to the "on_inventory_interact" Method and the "inventory_updated"-Signal to "hotbar_ui.populate_item_grid and "inventory_ui.populate_item_grid"

Afterwards we call populate_item_grid for both with the corresponding Data from the Inventory_Manager
    hotbar_ui.populate_item_grid(InventoryManager.hotbar)
    inventory_ui.populate_item_grid(InventoryManager.inventory)

If we want to add an Indicator for the selected Slot, we add a Sprite2D after the MarginContainer from HotbarUI.
The Size for the Texture is 60x60.
We have to set the Offset.Centered to false and set the default visbility to false.

In the extended Script for Hotbar_UI we add to Methodes to handle the Selection of the Slot aswell as the placement of the Sprite-Frame

