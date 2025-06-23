extends Control

@onready var password_input: LineEdit = $CanvasLayer/container/password_input
@onready var email_input: LineEdit = $CanvasLayer/container/Email_input
@onready var login_btn: TextureButton = $CanvasLayer/container/login
@onready var sign_up_text: Label = $CanvasLayer/container/sign_up_text

@export var url: String = "https://exemple.com"

func _ready():
	# Curseur "main" au survol
	sign_up_text.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	login_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_sign_up_text_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		OS.shell_open(url)

func _on_login_pressed() -> void:
	var email = email_input.text
	var password = password_input.text
	print("Email : ", email, " Password : ", password)
