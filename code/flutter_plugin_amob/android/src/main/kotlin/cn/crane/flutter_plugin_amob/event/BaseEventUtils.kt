package cn.crane.flutter_plugin_amob.event

import android.content.res.Resources
import android.util.TypedValue

open class BaseEventUtils {

    val Float.dp
        get() = TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP,
                this,
                Resources.getSystem().displayMetrics
        )
    private var eventCallback: EventCallback? = null
    open fun setEventCallback(callback: EventCallback?) {
        eventCallback = callback
    }

    fun sendEvent(event: String?) {
        eventCallback?.sendEvent(String.format("%s_%s", javaClass.simpleName, event))
    }

}