extends Node

func message(str: String, sender: Node) -> void:
	print(str + '\tfrom: ' + str(sender) + '\tat: ' + str(Time.get_ticks_usec()))
