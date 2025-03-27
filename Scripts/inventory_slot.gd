extends PanelContainer

@onready var item_icon: TextureRect = $MarginContainer/Item_Icon
@onready var item_quantity_label = $Item_Quantity

signal slot_clicked(index:int, button: int)

func set_slot_data(slot_data: SlotData):
    if slot_data and slot_data.item_data:
        var item_data = slot_data.item_data
        item_icon.texture = item_data.texture
        tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
        if slot_data.quantity > 1:
            item_quantity_label.text = "%s" % slot_data.quantity
            item_quantity_label.show()
        else: 
            item_quantity_label.hide()
    
func _on_gui_input(_event: InputEvent) -> void:
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
        if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
            slot_clicked.emit(get_index(), MOUSE_BUTTON_LEFT)
        elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
            slot_clicked.emit(get_index(), MOUSE_BUTTON_RIGHT)
