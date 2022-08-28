global css html
	ff:sans
	fs: 18px
	$bgc:rgb(4, 6, 12)
	$c:rgb(255, 238, 238)
	$acc-bgc: #252749
	$acc-bgc-hover: #383a6d
	bgc: $bgc
	c: $c

	*
		box-sizing: border-box;
		scrollbar-color: $acc-bgc rgba(0, 0, 0, 0);
		scrollbar-width: auto;
		margin: 0;
		padding: 0;

		transition-timing-function: cubic-bezier(0.455, 0.03, 0.515, 0.955);
		transition-delay: 0;
		transition-duration: 450ms;
		transition-property: color, background, width, height, transform, opacity, max-height, max-width, top, left, bottom, right, visibility, fill, stroke, margin, padding, font-size, border-color, box-shadow, border-radius;
