extends Node

const SOUND_CORRECT = "correct"
const SOUND_SALAMANDER = "salamander"
const SOUND_MISS = "miss"
const SOUND_BONE = "bone"
const SOUND_CUT = "cut"


var SOUNDS = {
	SOUND_CORRECT: preload("res://assets/sfx/correct_sound6.mp3"),
	SOUND_SALAMANDER: preload("res://assets/sfx/spelt_salamander.mp3"),
	SOUND_MISS: preload("res://assets/sfx/SalamanderPass.mp3"),
	SOUND_BONE: preload("res://assets/sfx/BoneSnap.mp3"),
	SOUND_CUT: preload("res://assets/sfx/slice.mp3")
}

func play_clip(player: AudioStreamPlayer, clip_key: String):
	if SOUNDS.has(clip_key) == false:
		return
	player.stream = SOUNDS[clip_key]
	player.play()
