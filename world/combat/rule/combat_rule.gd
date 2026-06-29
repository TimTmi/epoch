class_name CombatRule


func before_damage_dealt(context: DamageContext) -> void:
	pass

func after_damage_dealt(context: DamageContext) -> void:
	pass

func before_damage_taken(context: DamageContext) -> void:
	pass

func after_damage_taken(context: DamageContext) -> void:
	pass

func before_healing_given(context: HealingContext) -> void:
	pass

func after_healing_given(context: HealingContext) -> void:
	pass

func before_healing_received(context: HealingContext) -> void:
	pass

func after_healing_received(context: HealingContext) -> void:
	pass

func before_health_change(context: HealthChangeContext) -> void:
	pass

func after_health_change(context: HealthChangeContext) -> void:
	pass
