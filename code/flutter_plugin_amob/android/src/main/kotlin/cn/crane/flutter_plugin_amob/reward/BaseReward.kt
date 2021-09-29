package cn.crane.flutter_plugin_amob.reward

import android.content.Context
import cn.crane.flutter_plugin_amob.event.BaseEventUtils
import io.flutter.plugin.common.MethodChannel

open class BaseReward : BaseEventUtils() {
    open fun loadAd(context: Context?) {}

    open fun isReady(context: Context?): Boolean {
        return false
    }

    open fun show(context: Context?, result: MethodChannel.Result?): Boolean {
        return false
    }
}