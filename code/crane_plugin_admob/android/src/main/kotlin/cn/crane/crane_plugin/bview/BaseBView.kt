package cn.crane.crane_plugin.bview

import android.content.Context
import android.view.View
import android.widget.LinearLayout
import cn.crane.crane_plugin.event.BaseEventUtils

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