package cn.crane.flutter_plugin_amob.bview

import android.content.Context
import android.view.View
import android.widget.LinearLayout
import cn.crane.flutter_plugin_amob.event.EventCallback
import java.util.*

object BViewManager : BaseBView() {
    var list: ArrayList<BaseBView> = arrayListOf()
    var listZh: ArrayList<BaseBView> = arrayListOf()

    init {
        list.add(BView_admob)
    }

    override fun setEventCallback(callback: EventCallback?) {
        list.forEach { it.setEventCallback(callback) }
        listZh.forEach { it.setEventCallback(callback) }
        super.setEventCallback(callback)
    }

    override fun loadView(context: Context, layoutView: LinearLayout, isLarge: Boolean) {
        if (isSysZh()) {
            if (listZh.size > 0) {
                for (item: BaseBView in listZh) {
                    if (!item.isReady()) {
                        item.loadView(context, layoutView, isLarge)
                    } else {
                        return
                    }
                }
            }
            if (list.size > 0) {
                for (item: BaseBView in list) {
                    if (item.isReady()) {
                        return
                    }
                }
            }
        } else {
            if (list.size > 0) {
                for (item: BaseBView in list) {
                    if (item.isReady()) {
                        return
                    }
                }
            }
            if (listZh.size > 0) {
                for (item: BaseBView in listZh) {
                    if (item.isReady()) {
                        return
                    }
                }
            }
        }
    }

    override fun getView(): View? {
        if (isSysZh()) {
            if (listZh.size > 0) {
                for (item: BaseBView in listZh) {
                    if (item.isReady()) {
                        return item.getView()
                    }
                }
            }
            if (list.size > 0) {
                for (item: BaseBView in list) {
                    if (item.isReady()) {
                        return item.getView()
                    }
                }
            }
        } else {
            if (list.size > 0) {
                for (item: BaseBView in list) {
                    if (item.isReady()) {
                        return item.getView()
                    }
                }
            }
            if (listZh.size > 0) {
                for (item: BaseBView in listZh) {
                    if (item.isReady()) {
                        return item.getView()
                    }
                }
            }
        }
        return super.getView()
    }


    fun isSysZh(): Boolean {
        return Locale.getDefault().language.contains("zh")
    }

}