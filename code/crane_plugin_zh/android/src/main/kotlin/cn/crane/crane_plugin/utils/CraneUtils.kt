package cn.crane.crane_plugin.utils

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.net.Uri
import android.os.Build
import android.text.TextUtils
import cn.crane.crane_plugin.R
import kotlin.math.pow
import kotlin.math.sqrt

object CraneUtils {

    private fun isHuaweiMateX(): Boolean {
        return Build.MODEL.lowercase().contains("TAH-AN00m".lowercase())
    }

    fun isPad(context: Context?): Boolean {

        try {
            if (isHuaweiMateX()) {
                return false
            }

            val dm = context?.resources?.displayMetrics
            if (dm != null) {
                val x = (dm.widthPixels / dm.xdpi).toDouble().pow(2.0)
                val y = (dm.heightPixels / dm.ydpi).toDouble().pow(2.0)
                val screenInches = sqrt(x + y)
                // 屏幕大于7尺寸则为Pad
                return screenInches >= 7.0 || isPad11(context)
            }
        } catch (e: Exception) {
        }
        return false
    }

    fun isPad11(context: Context?): Boolean {
        context?.resources?.configuration?.let {
            return it.screenLayout.and(Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE
        }
        return false
    }

    fun getAppVersionName(context: Context?): String {
        var appVersionName = ""
        try {
            val packageInfo =
                context!!.applicationContext.packageManager.getPackageInfo(context.packageName, 0)
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

    fun share(context: Context?, str: String?) {
        if (context != null) {
            val sendIntent = Intent()
            sendIntent.action = Intent.ACTION_SEND
            sendIntent.type = "text/*"
            sendIntent.putExtra(Intent.EXTRA_TEXT, str)
            context.startActivity(
                Intent.createChooser(
                    sendIntent, context.getString(R.string.title_share_to)
                )
            )
        }
    }

    fun opneUrl(context: Context?, url: String?) {
        if (context != null && !TextUtils.isEmpty(url)) {
            var intent = Intent()
            intent.data = Uri.parse(url)
            if (context !is Activity) {
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            intent.action = "android.intent.action.VIEW"
            context.startActivity(intent)
        }
    }

}