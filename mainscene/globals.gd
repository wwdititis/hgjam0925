extends Node

var room = preload("res://mainscene/room.tscn")
var messages = preload("res://controls/messages.tscn")
var paint = preload("res://minigames/paint/paint.tscn")
var gameover = preload("res://mainscene/gameover.tscn")

var maxSleep = 100
var currentSleep = maxSleep
var maxFood = 100
var currentFood = maxFood
var maxSocial = 100
var currentSocial = maxSocial
