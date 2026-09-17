class_name AudioManager
extends Node

## Audio synthesizer and manager for LOLCOW WRESTLING: OFFLINE MAYHEM.
## Generates and plays procedural 16-bit PCM audio streams for mat impacts,
## ring bell, referee slaps, strikes, ropes, crowd reactions, and announcer stingers.

static var instance: AudioManager

var sfx_players: Array[AudioStreamPlayer] = []
var crowd_player: AudioStreamPlayer
var fanfare_player: AudioStreamPlayer

# Pre-synthesized streams
var snd_bell: AudioStreamWAV
var snd_mat_slam: AudioStreamWAV
var snd_strike_clean: AudioStreamWAV
var snd_strike_blocked: AudioStreamWAV
var snd_ref_slap: AudioStreamWAV
var snd_rope: AudioStreamWAV
var snd_crowd_cheer: AudioStreamWAV
var snd_crowd_gasp: AudioStreamWAV
var snd_finisher_stinger: AudioStreamWAV
var snd_victory_fanfare: AudioStreamWAV
var snd_rope_break: AudioStreamWAV
var snd_counts: Array[AudioStreamWAV] = []

func _ready() -> void:
	if instance == null:
		instance = self
	_create_audio_streams()
	_setup_players()

func _setup_players() -> void:
	for i in range(10):
		var p: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(p)
		sfx_players.append(p)
		
	crowd_player = AudioStreamPlayer.new()
	add_child(crowd_player)

	fanfare_player = AudioStreamPlayer.new()
	add_child(fanfare_player)

func _play_sfx(stream: AudioStreamWAV, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if not stream:
		return
	for p in sfx_players:
		if not p.playing:
			p.stream = stream
			p.volume_db = volume_db
			p.pitch_scale = pitch_scale
			p.play()
			return
	# Fallback to first player
	if not sfx_players.is_empty():
		sfx_players[0].stream = stream
		sfx_players[0].volume_db = volume_db
		sfx_players[0].pitch_scale = pitch_scale
		sfx_players[0].play()

func play_ring_bell() -> void:
	_play_sfx(snd_bell, 2.0, 1.0)

func play_mat_slam(is_heavy: bool = true) -> void:
	var pitch: float = randf_range(0.85, 1.05) if not is_heavy else randf_range(0.75, 0.9)
	var vol: float = 4.0 if is_heavy else 1.0
	_play_sfx(snd_mat_slam, vol, pitch)

func play_strike(is_blocked: bool = false) -> void:
	if is_blocked:
		_play_sfx(snd_strike_blocked, -2.0, randf_range(0.9, 1.1))
	else:
		_play_sfx(snd_strike_clean, 2.0, randf_range(0.95, 1.05))

func play_referee_slap() -> void:
	_play_sfx(snd_ref_slap, 3.0, randf_range(0.98, 1.02))

func play_rope_twang() -> void:
	_play_sfx(snd_rope, 0.0, randf_range(0.9, 1.1))

func play_crowd_cheer() -> void:
	if crowd_player:
		crowd_player.stream = snd_crowd_cheer
		crowd_player.volume_db = -4.0
		crowd_player.play()

func play_crowd_gasp() -> void:
	_play_sfx(snd_crowd_gasp, -1.0, 1.0)

func play_finisher_stinger() -> void:
	_play_sfx(snd_finisher_stinger, 4.0, 1.0)

func play_victory_fanfare() -> void:
	if fanfare_player:
		fanfare_player.stream = snd_victory_fanfare
		fanfare_player.volume_db = 2.0
		fanfare_player.play()

func play_rope_break_alert() -> void:
	_play_sfx(snd_rope_break, 1.0, 1.0)

func play_count_tone(count: int) -> void:
	if count >= 1 and count <= snd_counts.size():
		_play_sfx(snd_counts[count - 1], 3.0, 1.0)

# ==============================================================================
# Procedural Audio Synthesis (16-bit PCM Mono, 22050 Hz)
# ==============================================================================

func _create_audio_streams() -> void:
	snd_bell = _synthesize_bell()
	snd_mat_slam = _synthesize_mat_slam()
	snd_strike_clean = _synthesize_strike_clean()
	snd_strike_blocked = _synthesize_strike_blocked()
	snd_ref_slap = _synthesize_ref_slap()
	snd_rope = _synthesize_rope()
	snd_crowd_cheer = _synthesize_crowd(true)
	snd_crowd_gasp = _synthesize_crowd(false)
	snd_finisher_stinger = _synthesize_finisher_stinger()
	snd_victory_fanfare = _synthesize_victory_fanfare()
	snd_rope_break = _synthesize_rope_break()
	
	snd_counts.clear()
	for c in [1, 2, 3]:
		snd_counts.append(_synthesize_count_tone(c))

func _create_wav(samples: PackedByteArray, sample_rate: int = 22050) -> AudioStreamWAV:
	var wav: AudioStreamWAV = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = samples
	return wav

func _synthesize_bell() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 1.4
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	var freqs: Array[float] = [880.0, 1760.0, 2640.0, 3520.0, 420.0]
	var weights: Array[float] = [0.45, 0.25, 0.15, 0.1, 0.2]
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-3.8 * t)
		var sample_val: float = 0.0
		for k in range(freqs.size()):
			sample_val += sin(TAU * freqs[k] * t) * weights[k]
		sample_val *= env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_mat_slam() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.75
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-6.5 * t)
		var freq: float = lerp(90.0, 35.0, clamp(t / 0.35, 0.0, 1.0))
		var sub: float = sin(TAU * freq * t) * 0.75
		var noise_env: float = exp(-35.0 * t)
		var noise: float = (randf() * 2.0 - 1.0) * noise_env * 0.45
		var sample_val: float = (sub + noise) * env * 0.98
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_strike_clean() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.28
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-18.0 * t)
		var snap_env: float = exp(-45.0 * t)
		var punch: float = sin(TAU * 160.0 * t) * 0.55
		var snap: float = (randf() * 2.0 - 1.0) * snap_env * 0.65
		var sample_val: float = (punch + snap) * env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_strike_blocked() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.22
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-16.0 * t)
		var punch: float = sin(TAU * 110.0 * t) * 0.7
		var int16: int = clampi(int(punch * env * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_ref_slap() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.35
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-14.0 * t)
		var slap_noise: float = (randf() * 2.0 - 1.0) * exp(-40.0 * t) * 0.7
		var low_thump: float = sin(TAU * 120.0 * t) * 0.45
		var sample_val: float = (slap_noise + low_thump) * env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_rope() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.45
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-8.0 * t)
		var twang: float = sin(TAU * 65.0 * t) * 0.6 + sin(TAU * 130.0 * t) * 0.3
		var int16: int = clampi(int(twang * env * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_crowd(is_cheer: bool) -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 2.0 if is_cheer else 1.0
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	var last_noise: float = 0.0
	for i in range(num_samples):
		var t: float = float(i) / rate
		var raw_noise: float = randf() * 2.0 - 1.0
		last_noise = lerp(last_noise, raw_noise, 0.12)
		var env: float = 1.0
		if is_cheer:
			if t < 0.4:
				env = t / 0.4
			else:
				env = exp(-1.2 * (t - 0.4))
		else:
			env = exp(-2.5 * t)
			
		var sample_val: float = last_noise * env * 0.8
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_finisher_stinger() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 1.1
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	# Power chord with rising pitch sweep and distortion
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = min(t / 0.15, 1.0) * exp(-2.2 * t)
		var f_base: float = lerp(110.0, 220.0, clamp(t / 0.5, 0.0, 1.0))
		var chord: float = sin(TAU * f_base * t) * 0.4 + sin(TAU * (f_base * 1.5) * t) * 0.35 + sin(TAU * (f_base * 2.0) * t) * 0.25
		# Soft overdrive clipping
		var driven: float = clamp(chord * 1.8, -1.0, 1.0)
		var sample_val: float = driven * env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_victory_fanfare() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 2.4
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	# Fanfare notes: C4 (261.6), E4 (329.6), G4 (392.0), C5 (523.2)
	var notes: Array[float] = [261.63, 329.63, 392.00, 523.25]
	var note_starts: Array[float] = [0.0, 0.35, 0.70, 1.05]
	var note_durs: Array[float] = [0.35, 0.35, 0.35, 1.35]
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var sample_val: float = 0.0
		for n in range(notes.size()):
			var n_start: float = note_starts[n]
			var n_dur: float = note_durs[n]
			if t >= n_start and t < (n_start + n_dur):
				var local_t: float = t - n_start
				var env: float = min(local_t / 0.04, 1.0) * exp(-2.0 * local_t)
				var tone: float = sin(TAU * notes[n] * local_t) * 0.5 + sin(TAU * (notes[n] * 2.0) * local_t) * 0.25 + sin(TAU * (notes[n] * 3.0) * local_t) * 0.12
				sample_val += tone * env
		sample_val = clamp(sample_val * 0.85, -1.0, 1.0)
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_rope_break() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.5
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	# Dual-tone buzzer alert (220 Hz + 277 Hz)
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = min(t / 0.02, 1.0) * exp(-5.0 * t)
		var buzzer: float = (sin(TAU * 220.0 * t) + sin(TAU * 277.0 * t)) * 0.5
		# Square-ish grit
		var clipped: float = 0.7 if buzzer > 0.0 else -0.7
		var sample_val: float = clipped * env * 0.8
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_count_tone(count: int) -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.45
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	# Distinct pitch per count (count 1: 300 Hz, count 2: 400 Hz, count 3: 520 Hz)
	var base_freq: float = 260.0 + (count * 90.0)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = min(t / 0.015, 1.0) * exp(-7.5 * t)
		var tone: float = sin(TAU * base_freq * t) * 0.6 + sin(TAU * (base_freq * 2.0) * t) * 0.3
		var transient_noise: float = (randf() * 2.0 - 1.0) * exp(-40.0 * t) * 0.3
		var sample_val: float = (tone + transient_noise) * env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)
