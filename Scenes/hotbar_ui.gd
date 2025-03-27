class_name HotbarUI extends InventoryUI
## The Hotbar's UI funtionality e.g. changing the Selektor Position for the focused Hotbar Slot

## A [Sprite2D] Frame to show which [InventorySlot] is currently focused or selected
@onready var selector: Sprite2D = $MarginContainer/Selector

## Handles the Keys 1-8 for the Hotbar-Selector and saves the current Slot-Index to [Inventory_Manager]
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.is_pressed():
        if range(KEY_1, KEY_9).has(event.keycode):
            var keycodeString: String = OS.get_keycode_string(event.keycode)
            var keyCodeIndex: int = int(keycodeString) - 1
            set_highlight_slot(keyCodeIndex)

## Actives a Selector Frame for the chosen Slot and sets the [member global_position] to the same [member global_position] as the Slot
func set_highlight_slot(keyCodeIndex: int) -> void:
    if keyCodeIndex > -1:
        selector.global_position = items_ui.get_child(keyCodeIndex).global_position
        selector.show()
