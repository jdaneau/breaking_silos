package ${YYAndroidPackageName};

import android.app.Activity;
import android.os.Build;
import android.view.WindowManager;

public class Xtend {

    /*
    INITIALIZATION
    */

    // Get GameMaker Android runner
    Activity Runner = RunnerActivity.CurrentActivity;

    // Set Android display mode
    public void Init() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            Runner.getWindow().getAttributes().layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
        }
    }


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

    public double display_get_bbox_left() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            return Runner.getWindow().getDecorView().getRootWindowInsets().getDisplayCutout().getSafeInsetLeft();
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

    public double display_get_bbox_right() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            return Runner.getWindow().getDecorView().getRootWindowInsets().getDisplayCutout().getSafeInsetRight();
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

    public double display_get_bbox_top() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            return Runner.getWindow().getDecorView().getRootWindowInsets().getDisplayCutout().getSafeInsetTop();
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

    public double display_get_bbox_bottom() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            return Runner.getWindow().getDecorView().getRootWindowInsets().getDisplayCutout().getSafeInsetBottom();
        } else {
            return 0;
        }
    }
}
