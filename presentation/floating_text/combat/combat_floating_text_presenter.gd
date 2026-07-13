class_name CombatFloatingTextPresenter


var presenter: FloatingTextPresenter
var configs: CombatFloatingTextConfigs


func _init(presenter: FloatingTextPresenter, configs: CombatFloatingTextConfigs) -> void:
	self.presenter = presenter
	self.configs = configs

func bind(combat: CombatEvents) -> void:
	combat.health_changed.connect(_on_health_changed)

func _on_health_changed(context: StatChangeContext) -> void:
	var change: float = context.new_stat - context.old_stat
	var config: FloatingTextConfig = configs.heal if change > 0 else configs.damage
	presenter.show_text(str(roundi(absf(change))), config, context.character.global_position)
