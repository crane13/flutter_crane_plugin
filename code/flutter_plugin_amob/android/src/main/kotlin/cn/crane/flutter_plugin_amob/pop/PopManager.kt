package cn.crane.flutter_plugin_amob.pop

import android.content.Context
import cn.crane.flutter_plugin_amob.event.EventCallback
import java.util.*

object PopManager : BasePop() {
    var list: ArrayList<BasePop> = arrayListOf()
    var listZh: ArrayList<BasePop> = arrayListOf()

    init {
        list.add(PopUtils_admob)
    }

    override fun setEventCallback(callback: EventCallback?) {
        list.forEach { it.setEventCallback(callback) }
        listZh.forEach { it.setEventCallback(callback) }
        super.setEventCallback(callback)
    }

    override fun isReady(context: Context?): Boolean {
        if (isSysZh()) {
            if (listZh.size > 0) {
                for (item: BasePop in listZh) {
                    if (item.isReady(context)) {
                        return true
                    }
                }
            }
            if (list.size > 0) {
                for (item: BasePop in list) {
                    if (item.isReady(context)) {
                        return true
                    }
                }
            }
        } else {
            if (list.size > 0) {
                for (item: BasePop in list) {
                    if (item.isReady(context)) {
                        return true
                    }
                }
            }
            if (listZh.size > 0) {
                for (item: BasePop in listZh) {
                    if (item.isReady(context)) {
                        return true
                    }
                }
            }
        }
        return super.isReady(context)
    }


    override fun show(context: Context?): Boolean {
        if (isSysZh()) {
            if (listZh.size > 0) {
                for (item: BasePop in listZh) {
                    if (item.isReady(context)) {
                        return item.show(context)
                    }
                }
            }
            if (list.size > 0) {
                for (item: BasePop in list) {
                    if (item.isReady(context)) {
                        return item.show(context)
                    }
                }
            }
        } else {
            if (list.size > 0) {
                for (item: BasePop in list) {
                    if (item.isReady(context)) {
                        return item.show(context)
                    }
                }
            }
            if (listZh.size > 0) {
                for (item: BasePop in listZh) {
                    if (item.isReady(context)) {
                        return item.show(context)
                    }
                }
            }
        }
        return super.show(context)
    }

    fun isSysZh(): Boolean {
        return Locale.getDefault().language.contains("zh")
    }

}