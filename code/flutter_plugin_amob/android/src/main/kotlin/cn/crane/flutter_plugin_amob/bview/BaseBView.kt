package cn.crane.flutter_plugin_amob.bview

import android.content.Context
import android.view.View
import android.widget.LinearLayout
import cn.crane.flutter_plugin_amob.event.BaseEventUtils

open class BaseBView : BaseEventUtils() {
    open fun isReady(): Boolean {
        return false
    }

    open fun loadView(context: Context, layoutView: LinearLayout, isLarge: Boolean) {
    }

    open fun getView(): View? {
        return null
    }
}