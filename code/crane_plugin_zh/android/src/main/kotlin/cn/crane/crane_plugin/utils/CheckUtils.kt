package cn.crane.crane_plugin.utils

import java.util.*

object CheckUtils {
    val TAG = CheckUtils.javaClass.simpleName
    fun isEnable(): Boolean {
        try {
            var now = Calendar.getInstance()
            var online = Calendar.getInstance()
            online.set(2022, 11 - 1, 12)
            return now.after(online)
        } catch (e: Exception) {

        }
        return true
    }
}