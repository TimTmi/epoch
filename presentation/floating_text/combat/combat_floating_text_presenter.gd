class_name CombatFloatingTextPresenter


var presenter: FloatingTextPresenter
var configs: CombatFloatingTextConfigs


func _init(presenter: FloatingTextPresenter, configs: CombatFloatingTextConfigs) -> void:
	self.presenter = presenter
	self.configs = configs

func bind(combat: CombatSystem) -> void:
	combat.damage_taken.connect(_on_damage_taken)
	combat.healed.connect(_on_healed)

func _on_damage_taken(amount: float, target: Character, _source: Character) -> void:
	presenter.show_text(str(roundi(amount)), configs.damage, target.global_position)

func _on_healed(amount: float, target: Character, _source: Character) -> void:
	presenter.show_text(str(roundi(amount)), configs.heal, target.global_position)
