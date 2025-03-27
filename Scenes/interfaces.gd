class_name Interfaces extends Control
## The [Interfaces] Class handles actions between the Hotbar-Inventory, the Player-Inventory 
## and the the Slot that is used for Drag and Drop

## The Slot Information that should be dragged or dropped
var grabbed_slot_data: SlotData
@onready var grabbed_slot: PanelContainer = %GrabbedSlot
## The Hotbar-Inventory Panel[br]
## A [PanelContainer] to handle the [Player]'s Hotbar and the containing Data
@onready var hotbar_ui: HotbarUI = $HotbarUI
## The Inventory Panel[br]
## A [PanelContainer] to handle the [Player]'s Inventory and the containing Data
@onready var inventory_ui: InventoryUI = $InventoryUI

func _ready() -> void:
    InventoryManager.inventory.inventory_interact.connect(on_inventory_interact)
    InventoryManager.inventory.inventory_updated.connect(inventory_ui.populate_item_grid)
    
    InventoryManager.hotbar.inventory_interact.connect(on_inventory_interact)
    InventoryManager.hotbar.inventory_updated.connect(hotbar_ui.populate_item_grid)
    
    hotbar_ui.populate_item_grid(InventoryManager.hotbar)
    inventory_ui.populate_item_grid(InventoryManager.inventory)
    
## When the Slot has been grabbed and been set to visible, it follows the Mouse with a slite offset
func _physics_process(_delta: float) -> void:
    if grabbed_slot.visible:
        grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)
        
## Gives the [member grabbed_slot_data] different behaviors.
## The LeftMouseButton grabs or releases the Data from the Slot[br]
## The RightMouseButton drops a Quantity of 1 from the current Stack
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int):
    match [grabbed_slot_data, button]:
        [null, MOUSE_BUTTON_LEFT]:
            grabbed_slot_data = inventory_data.grab_slot_data(index)
        [_, MOUSE_BUTTON_LEFT]:
            grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
        [null, MOUSE_BUTTON_RIGHT]:
            pass
        [_, MOUSE_BUTTON_RIGHT]:
            grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
    update_grabbed_slot()

## Updates a [InventorySlot] Component that is used for Drag&Drop.
## The Slot will be visible on the Mouse Position to show which [InventorySlot] is currently being grabbed
func update_grabbed_slot():
    if grabbed_slot_data != null:
        grabbed_slot.show()
        grabbed_slot.set_slot_data(grabbed_slot_data)
    else:
        grabbed_slot.hide()
