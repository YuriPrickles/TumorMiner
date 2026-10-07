class_name Utils
extends Node

##ugh
static func snakeificate(string:String) -> String:
	var positions_array:Array[int]=[]
	for i in range(string.length()):
		if string[i] == string[i].to_upper():
			positions_array.append(i)
	positions_array.pop_front()
	positions_array.reverse()
	for position in positions_array:
		string = string.insert(position,"_")
	return string.to_lower()
