extends CanvasLayer

onready var hurt_rect = $HurtColorRect
onready var recover_rect = $RecoverColorRect
onready var timer = $FeedbackTimer

func feedback_hurt():
	if !hurt_rect.visible:
		hurt_rect.visible = true
		timer.start(1)
		yield(timer, "timeout")
		hurt_rect.visible = false
	else:
		return

func feedback_recover():
	if !recover_rect.visible:
		recover_rect.visible = true
		timer.start(1)
		yield(timer, "timeout")
		recover_rect.visible = false
	else:
		return