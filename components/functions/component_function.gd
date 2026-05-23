extends Component
class_name ComponentFunction

var handlers: Array[Callable] = []


func handle(value: float):
	for i in handlers:
		value = i.call(value)
	return value

func add_handler(handler: Callable):
	handlers.append(handler)

func remove_handler(handler: Callable):
	var remove = func():
		handlers.erase(handler)
	remove.call_deferred()
