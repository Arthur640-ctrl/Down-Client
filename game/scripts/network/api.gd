extends Node
class_name API

@onready var http: HTTPRequest = HTTPRequest.new()

func _ready() -> void:
	add_child(http)

func request(config: Dictionary, callback: Callable) -> void:
	# Récupération des paramètres avec valeurs par défaut
	var method: String = config.get("method", "GET").to_upper()
	var url: String = config.get("url", "")
	var data: Dictionary = config.get("data", {})
	var headers: Array = config.get("headers", [])
	var use_json: bool = config.get("use_json", true)

	# Convertir la méthode en enum HTTPClient
	var method_enum := HTTPClient.METHOD_GET
	match method:
		"POST": method_enum = HTTPClient.METHOD_POST
		"PUT": method_enum = HTTPClient.METHOD_PUT
		"PATCH": method_enum = HTTPClient.METHOD_PATCH
		"DELETE": method_enum = HTTPClient.METHOD_DELETE
		"HEAD": method_enum = HTTPClient.METHOD_HEAD

	# Construction du corps de la requête
	var body := PackedByteArray()
	var final_headers := headers.duplicate()

	if use_json and method != "GET":
		var json_string := JSON.stringify(data)
		body = json_string.to_utf8_buffer()
		final_headers.append("Content-Type: application/json")

	# Nettoyage du signal précédent s’il existe
	if http.is_connected("request_completed", _on_request_completed):
		http.disconnect("request_completed", _on_request_completed)

	# Connexion avec paramètres liés
	http.connect("request_completed", _on_request_completed.bind(callback, use_json))

	# Envoi de la requête
	var err := http.request_raw(url, final_headers, method_enum, body)
	if err != OK:
		push_error("❌ HTTP Request failed to send: %s" % err)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, callback: Callable, use_json: bool) -> void:
	var response = {}
	if use_json:
		var json := JSON.new()
		var parse_result := json.parse(body.get_string_from_utf8())
		if parse_result == OK:
			response = json.get_data()
		else:
			response = {
				"error": "Invalid JSON",
				"raw": body.get_string_from_utf8()
			}
	else:
		response = body.get_string_from_utf8()

	callback.call(response, response_code)

	# Déconnexion pour éviter empilement de signaux
	if http.is_connected("request_completed", _on_request_completed):
		http.disconnect("request_completed", _on_request_completed)
