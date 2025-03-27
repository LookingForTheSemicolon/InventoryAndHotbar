class_name ItemData extends Resource 
## A Base Resource Class for Items that are added to [SlotData]

## The Item Name
@export var name: String = ""
## A Description of the Item
@export_multiline var description: String = ""
## Is the Item stackable
@export var stackable: bool = false
## A Texture for the Item
@export var texture: Texture
