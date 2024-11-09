function ext_ToggleHTMLFullScreen() {
	if ((document.fullScreenElement && document.fullScreenElement !== null) || (!document.mozFullScreen && !document.webkitIsFullScreen)) {
		if (document.documentElement.requestFullScreen) {
			document.documentElement.requestFullScreen();
		} else if (document.documentElement.mozRequestFullScreen) {
			document.documentElement.mozRequestFullScreen();
		} else if (document.documentElement.webkitRequestFullScreen) {
			document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
		}
	}
	else {
		if (document.cancelFullScreen) {
			document.cancelFullScreen();
		} else if (document.mozCancelFullScreen) {
			document.mozCancelFullScreen();
		} else if (document.webkitCancelFullScreen) {
			document.webkitCancelFullScreen();
		}
	}
}

function ext_GetCanvasPosition() {
	return JSON.stringify({	"x": document.getElementById("canvas").getBoundingClientRect().left,
							"y": document.getElementById("canvas").getBoundingClientRect().top,
							"width": document.getElementById("canvas").getBoundingClientRect().width,
							"height": document.getElementById("canvas").getBoundingClientRect().height});
}