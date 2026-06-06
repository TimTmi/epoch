extends RandomNumberGenerator
class_name Random

static func chance(n: float):
	return randi_range(0, 9999) < (n * 100)
