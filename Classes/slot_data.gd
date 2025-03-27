class_name SlotData extends Resource
## The [SlotData] Class holds Information about an Item ([ItemData] and its Quantity

## Max Stack Size
const MAX_STACK_SIZE: int = 99
## The Item to hold
@export var item_data: ItemData
## Quantity
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1: set = set_quantity

## Check if a single Item can be merged with the Item from the Slot with a check on [member MAX_STACK_SIZE]
func can_merge_with(other_slot_data: SlotData) -> bool:
    return item_data == other_slot_data.item_data or item_data.name == other_slot_data.item_data.name \
    and item_data.stackable \
    and quantity <= MAX_STACK_SIZE

## Check if two Stack can be merged together with a check on [member MAX_STACK_SIZE]
func can_fully_merge_with(other_slot_data: SlotData) -> bool:
    return (item_data == other_slot_data.item_data or item_data.name == other_slot_data.item_data.name) \
    and item_data.stackable \
    and quantity + other_slot_data.quantity <= MAX_STACK_SIZE

## Reduces the Item-Quantity on the Slot by 1 and duplicates the [ItemData] from the Source
func create_single_slot_data() -> SlotData:
    var new_slot_data: SlotData = duplicate()
    new_slot_data.quantity = 1
    quantity -= 1
    return new_slot_data

## Merges two Slot-Items into one Slot
func fully_merge_with(other_slot_data: SlotData) -> void:
    quantity += other_slot_data.quantity

## Set Quantity on the Slot
func set_quantity(value: int) -> void:
    quantity = value
    if quantity > 1 and not item_data.stackable:
        quantity = 1
        push_error("%s is not stackable, setting quantity to 1" % item_data.name)
