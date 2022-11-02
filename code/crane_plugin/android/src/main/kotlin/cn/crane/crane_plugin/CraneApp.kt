package cn.crane.crane_plugin

import android.content.Context
import android.content.SharedPreferences
import android.util.Log

import androidx.multidex.MultiDex
import cn.crane.crane_plugin.privacy.PrivacyUtils
import cn.crane.crane_plugin.splash.AppOpenAdManager
import cn.crane.crane_plugin.utils.CheckUtils
import com.google.android.gms.ads.MobileAds
import io.flutter.app.FlutterApplication

open class CraneApp : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        fDensity = resources.displayMetrics.density

        val sW = resources.displayMetrics.widthPixels
        val sH = resources.displayMetrics.heightPixels
        screenW = Math.min(sW, sH)
        screenH = Math.max(sW, sH)
        MultiDex.install(this)

        sharedPreferences = getSharedPreferences(SP_NAME_SPLASH, Context.MODE_PRIVATE)

        if (PrivacyUtils.hasAgreePrivacy(this) && isAfter3Days() && CheckUtils.isEnable()) {
            MobileAds.initialize(
                this
            ) { }
            appOpenManager = AppOpenAdManager(this)
            appOpenManager?.loadAd(this)
        }
    }

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

    companion object {
        const val SP_NAME_SPLASH = "sp_name_splash"
        const val KEY_FIRST_INSTALL_TIME = "key_first_install_time"
        var fDensity = 0f
        var screenW = 0
        var screenH = 0

        var sharedPreferences: SharedPreferences? = null

        var appOpenManager: AppOpenAdManager? = null

        fun isAfter3Days(): Boolean {
            var lastTime = sharedPreferences?.getLong(KEY_FIRST_INSTALL_TIME, 0)
            Log.v("tttttt", "lastTime : " + lastTime)
            if (lastTime != null && lastTime > 10) {
                var duration = System.currentTimeMillis() - lastTime
                Log.v("tttttt", "lastTime : " + duration)
                if (duration > 1 * 24 * 60 * 60 * 1000) {
                    return true
                }
            }
            if (lastTime == null || lastTime < 10) {
                saveFirstTime()
            }
            return false
        }


        private fun saveFirstTime() {
            Log.v("tttttt", "saveFirstTime : " + System.currentTimeMillis())
            sharedPreferences?.edit()?.putLong(KEY_FIRST_INSTALL_TIME, System.currentTimeMillis())
                ?.apply()
        }
    }
}
