class_name Inventory
extends Resource

# Key: StringName of ConsumableResource
# Value: ConsumableResource
var consumables: Dictionary = {}

var selected_consumable: ConsumableResource = null

var weapons: Array[WeaponResource] = []

@export var money: int = 0

@export_group("weapons")
@export var weapon_primary: WeaponResource = load("res://weapons/resources/m60.tres")
@export var weapon_secondary: WeaponResource = load("res://weapons/resources/shotgun.tres")

###############
# CONSUMABLES #
###############

func add_consumable(new_consumable: ConsumableResource) -> void:
	if consumables.has(new_consumable.name):
		consumables[new_consumable.name].count += new_consumable.count
	else:
		consumables[new_consumable.name] = new_consumable
	
	selected_consumable = new_consumable

func cycle_consumables() -> void:
	if consumables.size() == 0: return

	var consumables_keys: Array = consumables.keys()
	if selected_consumable == null:
		selected_consumable = consumables[consumables_keys[0]]
	
	var current_index: int = consumables_keys.find(selected_consumable.name)
	var new_index: int = (current_index + 1) % consumables_keys.size()
	selected_consumable = consumables[consumables_keys[new_index]]

func remove_consumable() -> void:
	var consumable_to_remove: ConsumableResource = consumables[selected_consumable.name]
	consumable_to_remove.count -= 1
	if consumable_to_remove.count == 0:
		consumables.erase(consumable_to_remove.name)
		selected_consumable = null
		cycle_consumables()

func use_consumable() -> void:
	if selected_consumable == null: return
	selected_consumable.effect()
	remove_consumable()

###########
# WEAPONS #
###########

func add_weapon(new_weapon: WeaponResource) -> void:
	if weapons.has(new_weapon): return
	weapons.append(new_weapon.duplicate())

func equip_weapon_primary(new_weapon: WeaponResource) -> void:
	if not weapons.has(new_weapon):
		push_error("weapon was not found")
	weapon_primary = new_weapon

#########
# MONEY #
#########

func add_money(amount: int) -> void:
	money += amount

func pay_money(amount: int) -> bool:
	if amount > money: return false
	money -= amount
	return true
