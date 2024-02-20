extends Node

@export var mob_scene = PackedScene.new()
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StarterPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	#Create a new instance
	var mob = mob_scene.instantiate()
	
	#Choose a random location on path2d
	var mob_spawn_location = $MobPath/MobPathLocation
	mob_spawn_location.progress_ratio = randf()
	
	#Set mob's direction perpendicular to path direction. (90deg)
	var direction = mob_spawn_location.rotation + PI / 2
	
	#Add randomness to direction (-45/45deg)
	direction += randf_range(-PI / 4, PI /4)

	mob.rotation = direction
	
	#set position to random location
	mob.position = mob_spawn_location.position
	
	#Choose velocity for mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	print('velocity: ', velocity.rotated(direction))
	#Spawn mob by adding to main scene
	add_child(mob)
