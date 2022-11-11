package cn.crane.crane_plugin.reward

import android.content.Context
import cn.crane.crane_plugin.event.BaseEventUtils
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