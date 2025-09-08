extends Resource
class_name Queue

var queue:Array = []

func enqueue(item)->void:
	queue.append(item)

func dequeue():
	if queue.size() > 0:
		return queue.pop_front()

func get_front():
	return dequeue()

func peek():
	if queue.size() > 0:
		return queue[0]
	return null

func size():
	return queue.size()

func is_empty():
	return size() == 0
