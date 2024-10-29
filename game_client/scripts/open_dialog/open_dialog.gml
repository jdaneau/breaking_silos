function get_dialog_depth() {
	var dep = -150;
	for(var i=0; i<instance_number(objDialogWindow); i++) {
		var d = instance_find(objDialogWindow,i);
		if d.depth <= dep { dep = d.depth-1 }
	}
	return dep
}

function open_dialog(msg,confirm_function,return_depth=0){
	var dialog = instance_create_depth(0,0,get_dialog_depth(),objDialogWindow);
	dialog.prompt = msg
	dialog.confirm = confirm_function
	dialog.old_depth = return_depth
}

function open_dialog_info(msg,return_depth=0){
	var dialog = instance_create_depth(0,0,get_dialog_depth(),objDialogWindow);
	dialog.prompt = msg
	dialog.options = ["OK"]
	dialog.old_depth = return_depth
}

function open_dialog_option(msg,options,confirm_function,return_depth=0){
	var dialog = instance_create_depth(0,0,get_dialog_depth(),objDialogWindow);
	dialog.prompt = msg
	dialog.options = options
	dialog.confirm = confirm_function
	dialog.old_depth = return_depth
}

function open_dialog_question(msg,confirm_function,return_depth=0){
	var dialog = instance_create_depth(0,0,get_dialog_depth(),objDialogWindow);
	dialog.prompt = msg
	dialog.question = true
	dialog.confirm = confirm_function
	dialog.old_depth = return_depth
}