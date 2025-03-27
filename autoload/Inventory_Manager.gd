class_name Inventory_Manager extends Node
## The Inventory Manager handles the communication between the Szenes and the Inventory-Information
## Add or removes Items (Hotbar or Inventory) and gives feedback to the Player if a specific Weapon is in a Slot
## where the Selector/Focus is activ.

## THe Data for the Hotbar
var hotbar: InventoryData = InventoryData.new()
## The Data for the Inventory
var inventory: InventoryData = InventoryData.new()

## The Slot-Index that a Focus-Frame is displayed on
var focused_slot: int = -1

## Set the current focused slot
func on_focused_slot_changed(index: int) -> void:#
    focused_slot = index

func _ready() -> void:
    hotbar.slot_datas.resize(8)
    inventory.slot_datas.resize(36)
    
    var item = SlotData.new()
    item.item_data = preload("res://Collectables/Stick.tres")
    var item2 = SlotData.new()
    item2.item_data = preload("res://Collectables/Stick.tres")
    sort_collactable(item)
    sort_collactable(item2)

## Adds a new [Collectable] to either the Hotbar or the Inventory.[br]
## If the Hotbar is full and doesn't have an Item to stack upon it's added to the Inventory
func sort_collactable(slot_data: SlotData) -> void:
    if hotbar.has_item(slot_data.item_data) and slot_data.item_data.stackable:
       hotbar.pick_up_slot_data(slot_data)
    elif inventory.has_item(slot_data.item_data):
        inventory.pick_up_slot_data(slot_data)
    elif hotbar.has_free_slot():
       hotbar.pick_up_slot_data(slot_data)
    else:
        inventory.pick_up_slot_data(slot_data)
        
## Removes x of the given Item from the Inventory depending on the amount
func remove_item_from_inventory(item: ItemData, amount: int) -> void:
    var index: int = inventory.get_item_index(item)
    if index and inventory.slot_datas[index].quantity > amount:
        inventory.slot_datas[index].quantity -= amount
        inventory.inventory_updated.emit(inventory)
    else:
        inventory.slot_datas[index] = null
        inventory.inventory_updated.emit(inventory)
            
## Remove an Item from the Hotbar or Inventory
func remove_item(item: ItemData, amount:int) -> void:
    var total_amount:int = amount #if someone decides to split the stack between inventory and hotbar
    if hotbar.has_item(item):
        var index: int = hotbar.get_item_index(item)
        if hotbar.slot_datas[index].quantity > total_amount: # 3 > 2
            hotbar.slot_datas[index].quantity -= total_amount # 3 - 2
            hotbar.inventory_updated.emit(hotbar)
        else: # 2 > 3
            total_amount -= hotbar.slot_datas[index].quantity
            hotbar.slot_datas[index] = null
            hotbar.inventory_updated.emit(hotbar)
    if total_amount > 0 and inventory.has_item(item):
        remove_item_from_inventory(item, total_amount)
    elif inventory.has_item(item):
        remove_item_from_inventory(item, total_amount)
    
