class_name CallableArray


var array: Array[Callable]


func call_all(...args) -> void:
	for callable: Callable in array:
		callable.callv(args)

func append(callable: Callable) -> void:
	array.append(callable)

func erase(callable: Callable) -> void:
	array.erase(callable)
