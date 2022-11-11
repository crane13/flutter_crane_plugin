package cn.crane.crane_plugin.event

open class BaseEventUtils {
    private var eventCallback: EventCallback? = null
    open fun setEventCallback(callback: EventCallback?) {
        eventCallback = callback
    }

    fun sendEvent(event: String?) {
        eventCallback?.sendEvent(String.format("%s_%s", javaClass.simpleName, event))
    }

}