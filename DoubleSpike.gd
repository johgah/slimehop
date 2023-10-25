extends Area2D

func _on_body_entered(body):
	if(body.name == "Player"):
		body.state_machine.set_state(body, "death")
