#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import "Xtend.h"

@implementation Xtend {}

/*
INITIALIZATION
*/

// iOS sets display mode automatically - no init necessary!


/*
FUNCTIONS
*/

/// @function		display_get_bbox_left();
/// @requires		xtend, ext_xtend
/// @description	Android/iOS only. Returns the width in pixels of the left bounding box
///                 (or pillarbox) of a display with cutout. Will return 0 on other displays.
///					Note that bounding box will change depending on device orientation.
///
/// @example        var str = "Hello, world!";
///                 var xoffset = display_get_bbox_left();
///
///                 draw_text(xoffset, 50, "Hello, world!");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

- (double) display_get_bbox_left {
    if (@available(iOS 11.0, *)) {
        // Get display scale offset
        CGFloat Scale = [[UIScreen mainScreen] nativeScale];

        // Return boundary
        return (UIApplication.sharedApplication.keyWindow.safeAreaInsets.left*Scale);
    } else {
        return 0;
    }
}


/// @function		display_get_bbox_right();
/// @requires		xtend, ext_xtend
/// @description	Android/iOS only. Returns the width in pixels of the right bounding box 
///                 (or pillarbox) of a display with cutout. Will return 0 on other displays.
///					Note that bounding box will change depending on device orientation.
///
/// @example        var str = "Hello, world!";
///                 var xoffset = display_get_width() - display_get_bbox_right() - string_width(str);
///
///                 draw_text(50, xoffset, "Hello, world!");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

- (double) display_get_bbox_right {
    if (@available(iOS 11.0, *)) {
        // Get display scale offset
        CGFloat Scale = [[UIScreen mainScreen] nativeScale];

        // Return boundary
        return (UIApplication.sharedApplication.keyWindow.safeAreaInsets.right*Scale);
    } else {
        return 0;
    }
}



/// @function		display_get_bbox_top();
/// @requires		xtend, ext_xtend
/// @description	Android/iOS only. Returns the height in pixels of the top bounding box 
///                 (or letterbox) of a display with cutout. Will return 0 on other displays.
///					Note that bounding box will change depending on device orientation.
///
/// @example        var str = "Hello, world!";
///                 var yoffset = display_get_bbox_top();
///
///                 draw_text(50, yoffset, "Hello, world!");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

- (double) display_get_bbox_top {
    if (@available(iOS 11.0, *)) {
        // Get display scale offset
        CGFloat Scale = [[UIScreen mainScreen] nativeScale];

        // Return boundary
        return (UIApplication.sharedApplication.keyWindow.safeAreaInsets.top*Scale);
    } else {
        return 0;
    }
}



/// @function		display_get_bbox_bottom();
/// @requires		xtend, ext_xtend
/// @description	Android/iOS only. Returns the height in pixels of the bottom bounding box
///                 (or letterbox) of a display with cutout. Will return 0 on other displays.
///					Note that bounding box will change depending on device orientation.
///
/// @example        var str = "Hello, world!";
///                 var yoffset = display_get_height() - display_get_bbox_bottom() - string_height(str);
///
///                 draw_text(50, maxheight - 32, "Hello, world!");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

- (double) display_get_bbox_bottom {
    if (@available(iOS 11.0, *)) {
        // Get display scale offset
        CGFloat Scale = [[UIScreen mainScreen] nativeScale];

        // Return boundary
        return (UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom*Scale);
    } else {
        return 0;
    }
}

@end
