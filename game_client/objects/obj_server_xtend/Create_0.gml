/// @description XGASOFT XTEND

// Disallow multiple instances of this object
if (instance_number(object_index) > 1) {
	instance_destroy(id, false);
	exit;
}

// Force object visible (required to enable processing)
visible = true;

// Force object persistent
persistent = true;