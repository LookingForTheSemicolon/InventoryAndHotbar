class_name InventoryData extends Resource
## A Class for handling the Data of the Inventory e.g. drag and drop, searching for ItemData in the Slots etc.

## Fires when the UI should be updated because an Item was picked up or changed
signal inventory_updated(inventory_data: InventoryData)
## Fires when the Drag and Drop Functionality is used
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

## The Data of every Slot
@export var slot_datas: Array[SlotData]

## Grabs the Data from the Slot on [param index] and sets the Source Slot to an empty Slot[br]
## Return a SlotData Object
func grab_slot_data(index: int) -> SlotData:
    var slot_data = slot_datas[index]
    if slot_data:
        slot_datas[index] = null
        inventory_updated.emit(self)
        return slot_data
    else: 
        return null
        
## Drops the Data on the clicked Slot. 
## Two internal function calls are checking if the Item can merge with the Item in the Slot, if there is any.
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
    var slot_data = slot_datas[index]
    var return_slot_data: SlotData
    if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
        slot_data.fully_merge_with(grabbed_slot_data)
    else: 
        slot_datas[index] = grabbed_slot_data
        return_slot_data = slot_data
    
    inventory_updated.emit(self)
    return return_slot_data       
    
## This Method is used for the RightMouseButton Click.
## The dragged Item drops just one of it's Stack. 
func drop_single_slot_data(grabbed_slot_data: SlotData, index: int):
    var slot_data = slot_datas[index]
    if not slot_data:
        slot_datas[index] = grabbed_slot_data.create_single_slot_data()
    elif slot_data.can_merge_with(grabbed_slot_data):
        slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
        
    inventory_updated.emit(self)
    
    if grabbed_slot_data.quantity > 0:
        return grabbed_slot_data
    else:
        return null
        
## Handles a [Collectable] Item
func pick_up_slot_data(slot_data: SlotData):
    for index in slot_datas.size():
        if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
            slot_datas[index].fully_merge_with(slot_data)
            inventory_updated.emit(self)
            return true
            
    for index in slot_datas.size():
        if not slot_datas[index]:
            slot_datas[index] = slot_data
            inventory_updated.emit(self)
            return true
    return false
    
## Detect if the Hotbar or Inventory has a specific item
func has_item(item_data: ItemData):
    for index in slot_datas.size():
        if slot_datas[index] != null and slot_datas[index].item_data.name == item_data.name:
            return true
    return false

## Check if the Hotbar or Inventory is full
func has_free_slot():
    for index in slot_datas.size():
        if slot_datas[index] == null:
            return true
    return false

## Emits itself with the index and mousebutton that has been clicked (part of drag and drop)
func on_slot_clicked(index:int, button: int):
    inventory_interact.emit(self, index, button)
