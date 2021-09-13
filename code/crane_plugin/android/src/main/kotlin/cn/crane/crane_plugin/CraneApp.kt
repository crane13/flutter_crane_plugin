package cn.crane.crane_plugin

import android.content.Context

import androidx.multidex.MultiDex
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
    }

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

    companion object {
        var fDensity = 0f
        var screenW = 0
        var screenH = 0
    }
}
