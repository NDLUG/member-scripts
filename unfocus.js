function unfocus(e){
	// bound to escape(27) - other option is 0 (48)
        // also bound to capslock(20)
	if (e.keyCode == 27 || e.keyCode == 20) {
		document.activeElement.blur();
	}
}

document.onkeydown=unfocus;
