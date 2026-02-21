extends MeshInstance3D
@onready var lifespan = $Lifespan

func _ready() -> void:
	lifespan.start()
	


func _on_lifespan_timeout() -> void:
	queue_free()
