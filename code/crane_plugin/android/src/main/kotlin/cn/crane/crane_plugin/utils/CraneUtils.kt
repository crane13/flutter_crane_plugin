package cn.crane.crane_plugin.utils

import android.content.Context
import android.content.pm.PackageManager
import kotlin.math.pow
import kotlin.math.sqrt

object CraneUtils {
    fun isPad(context: Context?): Boolean {
        try {
            val dm = context?.resources?.displayMetrics
            if (dm != null) {
                val x = (dm.widthPixels / dm.xdpi).toDouble().pow(2.0)
                val y = (dm.heightPixels / dm.ydpi).toDouble().pow(2.0)
                val screenInches = sqrt(x + y)
                // 屏幕大于6尺寸则为Pad
                return screenInches >= 6.0
            }
        } catch (e: Exception) {
        }
        return false
    }


    fun getAppVersionName(context: Context?): String {
        var appVersionName = ""
        try {
            val packageInfo = context!!.applicationContext
                    .packageManager
                    .getPackageInfo(context.packageName, 0)
            appVersionName = packageInfo.versionName
        } catch (e: PackageManager.NameNotFoundException) {
        }

        return appVersionName
    }

    fun getPackageName(context: Context?): String {
        if (context != null) {
            return context.packageName
        }
        return ""
    }

}