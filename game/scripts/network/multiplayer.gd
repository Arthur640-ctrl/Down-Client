extends Node3D

@onready var player: CharacterBody3D = $Player

signal connect_to_game()

var udp = PacketPeerUDP.new()
var timer = 0.0
var connected = false
var player_id = ""
var player_token = ""
var delta = 0
var send_rate := 60.0
var accumulator := 0.0
var blocked = false

func _ready():
	udp.connect_to_host("127.0.0.1", 8000)
	udp.set_dest_address("127.0.0.1", 8000)
	player_id = Globals.player_id
	player_token = Globals.player_token
	
	PacketsHandler.register_player(player)
	NetworkPlayerManager.connect("send_input_packet", send_packet)

func _process(_delta):
	delta = _delta
	NetwordWordManager.delta = _delta 
	while udp.get_available_packet_count() > 0:
		var response = udp.get_packet().get_string_from_utf8()

		var json = JSON.new()
		var result = json.parse(response)
		if result == OK:
			var data = json.get_data()
			
			if data.has("message") and data["message"] == "Connexion réussie":
				connected = true
				emit_signal("connect_to_game")
				PacketsHandler.set_connect_state(connected)
			elif connected: 
				PacketsHandler.handle(data)

	if not connected and not blocked:
		var login_packet = {
			"request": "login",
			"player_id": player_id,
			"player_token": player_token
		}
		send_packet(login_packet, true)

	# Une fois connecté, on envoie les inputs
	if not blocked and connected and Globals.INPUT_DIR != null or Globals.EVENT_MOUSE != {}:
		accumulator += _delta
		if accumulator >= 1.0 / send_rate:
			accumulator = 0.0
			send_input()

func send_input():
	var input_packet = {
		"request": "player_actualisation",
		"player_id": player_id,
		"input_dir": [Globals.INPUT_DIR.x, Globals.INPUT_DIR.y],
		"mouse_event": Globals.EVENT_MOUSE,
		"is_jumping": Globals.IS_JUMPING,
		"is_running": Globals.IS_RUNNING,
		"is_crouched": Globals.IS_CROUSHED,
		"is_shooting": Globals.IS_SHOOTING,
		"is_aiming": Globals.IS_AIMING,
		"is_interact": Globals.IS_INTERACT,
		"is_reloading": Globals.IS_RELOADING,
		"is_use_gadget": Globals.IS_USE_GADGET,
		
		"inv_up": Globals.INV_DOWN,
		"inv_down": Globals.INV_UP,
	}
	send_packet(input_packet, true)
	Globals.EVENT_MOUSE = {}

func send_packet(data: Variant, isJson: bool) -> void:
	if isJson:
		var bytes: PackedByteArray = JSON.stringify(data).to_utf8_buffer()
		udp.put_packet(bytes)
	else:
		udp.put_var(data)
