package cn.crane.flutter_plugin_amob.pop

import android.content.Context
import cn.crane.flutter_plugin_amob.event.BaseEventUtils

open class BasePop : BaseEventUtils() {

    open fun loadAd(context: Context?) {}


    open fun isReady(context: Context?): Boolean {
        return false
    }

    open fun show(context: Context?): Boolean {
        return false
    }
}