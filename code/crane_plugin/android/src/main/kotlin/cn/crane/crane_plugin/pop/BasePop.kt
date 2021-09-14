package cn.crane.crane_plugin.pop

import android.content.Context
import cn.crane.crane_plugin.event.BaseEventUtils

open class BasePop : BaseEventUtils() {

    open fun loadAd(context: Context?) {}


    open fun isReady(context: Context?): Boolean {
        return false
    }

    open fun show(context: Context?): Boolean {
        return false
    }
}