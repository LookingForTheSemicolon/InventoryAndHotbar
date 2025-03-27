class_name InventoryUI extends PanelContainer
## The Inventorie's UI funtionality e.g. changing the Selektor Position for the focused Hotbar Slot

## A [GridContainer] to display the Inventory
@onready var items_ui: GridContainer = $MarginContainer/ItemsUI

## Inventory-Slot Scene to fill the [GridContainer]
const SLOT: PackedScene = preload("res://Scenes/inventory_slot.tscn")

## Fills the Inventory Slots depending on the given [InventoryData]   
func populate_item_grid(data: InventoryData) -> void:
    clear_grid_container()
    
    for slot_data: SlotData in data.slot_datas:
        var slot: Node = SLOT.instantiate()
        items_ui.add_child(slot)
        slot.slot_clicked.connect(data.on_slot_clicked)
        if slot_data:
            slot.set_slot_data(slot_data)

## Clears the [GridContainer] Children when the Inventory is updated
func clear_grid_container() -> void:
    for child: Node in items_ui.get_children():
        child.queue_free()
    
