extends Node

var jump_player: AudioStreamPlayer
var die_player: AudioStreamPlayer
var point_player: AudioStreamPlayer

const JUMP_SOUND_PATH = "res://assets/audio/player/jump.wav"
const DIE_SOUND_PATH = "res://assets/audio/player/die.wav"
const POINT_SOUND_PATH = "res://assets/audio/point.wav"

func _ready() -> void:
	_setup_audio_buses()
	_create_audio_players()

func _setup_audio_buses() -> void:
	if AudioServer.get_bus_index("SFX") == -1:
		var sfx_bus_idx = AudioServer.bus_count
		AudioServer.add_bus(sfx_bus_idx)
		AudioServer.set_bus_name(sfx_bus_idx, "SFX")
		AudioServer.set_bus_send(sfx_bus_idx, "Master")

func _create_audio_players() -> void:
	"""Crea los nodos AudioStreamPlayer para cada tipo de sonido"""
	jump_player = _create_audio_player("JumpPlayer", JUMP_SOUND_PATH)
	die_player = _create_audio_player("DiePlayer", DIE_SOUND_PATH)
	point_player = _create_audio_player("PointPlayer", POINT_SOUND_PATH)

func _create_audio_player(player_name: String, sound_path: String) -> AudioStreamPlayer:
	"""Crea un AudioStreamPlayer configurado correctamente"""
	var player = AudioStreamPlayer.new()
	player.name = player_name
	player.bus = "SFX"
	
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if ResourceLoader.exists(sound_path):
		player.stream = load(sound_path)
	else:
		push_warning("Audio file not found: " + sound_path)
	
	add_child(player)
	return player

func play_jump() -> void:
	"""Reproduce el sonido de salto del jugador"""
	if jump_player and jump_player.stream:
		jump_player.play()

func play_die() -> void:
	"""Reproduce el sonido de muerte del jugador"""
	if die_player and die_player.stream:
		die_player.play()

func play_point() -> void:
	"""Reproduce el sonido de puntuación (cada 100 puntos)"""
	if point_player and point_player.stream:
		point_player.play()

func set_sfx_volume(db: float) -> void:
	"""Establece el volumen del bus SFX en dB"""
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus, db)

func get_sfx_volume() -> float:
	"""Obtiene el volumen actual del bus SFX en dB"""
	var sfx_bus = AudioServer.get_bus_index("SFX")
	return AudioServer.get_bus_volume_db(sfx_bus)
