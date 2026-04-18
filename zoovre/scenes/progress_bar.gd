extends ProgressBar

func _ready() -> void:
	Gamemanager.prog_bar = self
	self.value = 6
