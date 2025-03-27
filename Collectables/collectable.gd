extends Node2D

@export var slot_data: SlotData
@onready var icon_sprite = $Sprite2D

func _ready() -> void:
    icon_sprite.texture = slot_data.item_data.texture

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player") and slot_data:
       body.pickup_collactable(slot_data)
       self.queue_free()
