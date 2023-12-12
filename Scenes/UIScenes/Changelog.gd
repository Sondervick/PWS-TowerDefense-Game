extends Control

func _on_back_pressed():
	get_tree().reload_current_scene()


func _on_bug_report_pressed():
	OS.shell_open("https://forms.office.com/e/zpKjAB8cDJ")
