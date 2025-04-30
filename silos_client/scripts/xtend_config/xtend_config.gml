/// @description	XGASOFT Xtend Configuration File
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

/*
	Defines values for common Xtend behaviors.

	By default, base width, height, and DPI will be determined automatically at run-
	time, but can be set manually for best results.

	DPI scaling is used to produce consistent physical dimensions across a variety
	of display resolutions. On Windows, 96 DPI is considered 100% scaling at around
	1080p on a desktop monitor. Smaller 1080p displays or 4K desktop monitors are
	typically considered 200% scaling. Other platforms may require a different base
	DPI for best results.

	Xtend also offers several additional scaling modes to handle changes in physical
	display shape. These include `aspect`, `axis_x` `axis_y`, `pixel`, and `linear`. 
	If you're not sure which to use, `aspect` is preferred. All scaling modes will
	apply changes to a view camera, numbered 0-7, with 0 being default. The chosen
	view camera will be activated automatically.
	
	# Linear
	Linear scaling will crop or extend both dimensions to match available screen area 
	on a 1:1 basis. Ideal for desktop-style applications.
	
	# Aspect Ratio
	Aspect ratio scaling will preserve the base area of the view (width AND height) 
	and extend the longer axis to fill the screen. Never crops. Recommended.
	
	# Axis X/Y
	Single-axis scaling will preserve either width OR height at the cost of either
	cropping or extending the other axis to fill the screen. Ideal for splitscreen.
	
	# Pixel
	Pixel scaling is designed for retro art styles with very low resolution. It will
	find the nearest integer scale on larger resolutions and crop or extend width and
	height only as necessary to fill aspect ratio. Square pixels are preserved at all 
	costs.
*/

function xtend_config() {
	xtend = {
		win: {
			dpi_enabled: true,
			dpi_base: 96,
			width_base: 1600,
			height_base: 900,
			aspect_min: 16/9,
			aspect_max: 16/9,
		},
		
		scale: {
			enabled: true,
			filter: true,
			gui: true,
			mode: aspect,
			view: 0,
			sample: 1,
			preserve: false,
		},
		
		debug: {
			hints_enabled: false,
			//hints_alpha: 0.5,
			//hints_color: c_aqua,
			stats_enabled: false,
			//stats_color: c_lime,
		},
	}
}