class_name CombatFloatingTextPresenter


var presenter: FloatingTextPresenter
var configs: CombatFloatingTextConfigs


func _init(presenter: FloatingTextPresenter, configs: CombatFloatingTextConfigs) -> void:
	self.presenter = presenter
	self.configs = configs

func bind(combat: CombatSystem) -> void:
	combat.damage_taken.connect(_on_damage_taken)
	combat.healing_received.connect(_on_healing_received)

func _on_damage_taken(context: DamageContext) -> void:
	presenter.show_text(str(roundi(context.amount)), configs.damage, context.target.global_position)

func _on_healing_received(context: HealingContext) -> void:
	presenter.show_text(str(roundi(context.amount)), configs.heal, context.target.global_position)
