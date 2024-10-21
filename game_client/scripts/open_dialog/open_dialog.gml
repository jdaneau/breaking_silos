function get_dialog_depth() {
	var dep = -150;
	for(var i=0; i<instance_number(objDialogWindow); i++) {
		var d = instance_find(objDialogWindow,i);
		if d.depth <= dep { dep = d.depth-1 }
	}
	return dep
}

function open_dialog(msg,confirm_function){
	var dialog = instance_create_depth(0,0,get_dialog_depth(),objDialogWindow);
	dialog.prompt = msg
	dialog.confirm = confirm_function
}

function open_dialog_info(msg){
	var dialog = instance_create_depth(0,0,get_dialog_depth(),objDialogWindow);
	dialog.prompt = msg
	dialog.options = ["OK"]
}

function open_dialog_option(msg,options,confirm_function){
	var dialog = instance_create_depth(0,0,get_dialog_depth(),objDialogWindow);
	dialog.prompt = msg
	dialog.options = options
	dialog.confirm = confirm_function
}

function open_dialog_question(msg,confirm_function){
	var dialog = instance_create_depth(0,0,get_dialog_depth(),objDialogWindow);
	dialog.prompt = msg
	dialog.question = true
	dialog.confirm = confirm_function
}