package cn.crane.flutter_plugin_amob.reward

import android.content.Context
import cn.crane.flutter_plugin_amob.event.EventCallback
import cn.crane.flutter_plugin_amob.pop.PopManager
import io.flutter.plugin.common.MethodChannel
import java.util.*

object RewardManager : BaseReward() {
    var list: ArrayList<BaseReward> = arrayListOf()
    var listZh: ArrayList<BaseReward> = arrayListOf()

    init {
        list.add(RewardUtils_admob)
    }

    override fun setEventCallback(callback: EventCallback?) {
        PopManager.list.forEach { it.setEventCallback(callback) }
        PopManager.listZh.forEach { it.setEventCallback(callback) }
        super.setEventCallback(callback)
    }

    override fun isReady(context: Context?): Boolean {
        if (isSysZh()) {
            if (listZh.size > 0) {
                for (item: BaseReward in listZh) {
                    if (item.isReady(context)) {
                        return true
                    }
                }
            }
            if (list.size > 0) {
                for (item: BaseReward in list) {
                    if (item.isReady(context)) {
                        return true
                    }
                }
            }
        } else {
            if (list.size > 0) {
                for (item: BaseReward in list) {
                    if (item.isReady(context)) {
                        return true
                    }
                }
            }
            if (listZh.size > 0) {
                for (item: BaseReward in listZh) {
                    if (item.isReady(context)) {
                        return true
                    }
                }
            }
        }
        return super.isReady(context)
    }


    override fun show(context: Context?, result: MethodChannel.Result?): Boolean {
        if (isSysZh()) {
            if (listZh.size > 0) {
                for (item: BaseReward in listZh) {
                    if (item.isReady(context)) {
                        return item.show(context, result)
                    }
                }
            }
            if (list.size > 0) {
                for (item: BaseReward in list) {
                    if (item.isReady(context)) {
                        return item.show(context, result)
                    }
                }
            }
        } else {
            if (list.size > 0) {
                for (item: BaseReward in list) {
                    if (item.isReady(context)) {
                        return item.show(context, result)
                    }
                }
            }
            if (listZh.size > 0) {
                for (item: BaseReward in listZh) {
                    if (item.isReady(context)) {
                        return item.show(context, result)
                    }
                }
            }
        }
        return super.show(context, result)
    }

    fun isSysZh(): Boolean {
        return Locale.getDefault().language.contains("zh")
    }

}