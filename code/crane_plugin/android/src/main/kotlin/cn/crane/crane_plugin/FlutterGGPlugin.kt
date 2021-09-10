package cn.crane.crane_plugin

import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import cn.crane.crane_plugin.pop.PopUtils_admob
import cn.crane.crane_plugin.reward.RewardUtils_admob
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*

/**
 *
 */
class FlutterGGPlugin : MethodCallHandler, FlutterPlugin {
    companion object {
        val TAG = FlutterGGPlugin::class.java.simpleName
        val KEY = "flutter_gg"
    }

    private var channel: MethodChannel? = null
    private var context: Context? = null
    private var activity: CraneActivity? = null

    constructor(activity: CraneActivity) : super() {
        this.activity = activity
    }


//    fun FlutterGGPlugin(activity: MainActivity) {
//        this.activity = activity
//    }

    private var eventCallback: EventCallback = object : EventCallback {
        override fun sendEvent(event: String) {
            onEvent(event)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        if (call.method == null) return
        Log.v(TAG, "onMethodCall : " + call.method)

        when (call.method) {
            "getPlatformVersion" -> result.success(getAppVersionName(context))
            "registerSid" -> {
            }
            "showBannerEnable" -> {

                if (activity is CraneActivity) {
                    val activity = activity as CraneActivity
                    activity.setShowBanner(call.argument<Boolean>("showBanner")!!)
                }
                result.success(true)
            }
            "registerAdmobId" ->
                //                    MobileAds.initialize(registrar.activity(), call.argument("admob_appId"));
                result.notImplemented()
            "showbanner" -> {
                showBanner(call)
                result.success(true)
            }
            "showPopAd" -> {
                PopUtils_admob.setEventCallback(eventCallback)
                result.success(PopUtils_admob.showAd(activity!!))
            }
            "showRewardAd" -> {
                RewardUtils_admob.setEventCallback(eventCallback)
//                RewardUtils_gdt.setEventCallback(eventCallback)
                showVideo(result)
            }
            "isPad" -> result.success(false)
            "getChannel" -> {
//                result.success(BuildConfig.channel)
            }
            "isRewardVideoReady" -> result.success(isVideoReady())

            else -> result.notImplemented()
        }

    }

    private fun showBanner(call: MethodCall) {
        try {

            if (activity is CraneActivity) {
                val activity = activity as CraneActivity
                activity.loadBanner()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    private fun isVideoReady(): Boolean {
//        val readyGDT: Boolean = RewardUtils_gdt.isReady(registrar!!.activity())
        val readyGDT: Boolean = false
        val readyMob = RewardUtils_admob.isReady(activity)
        return readyGDT || readyMob
    }

    private fun showVideo(result: Result) {
        if (RewardUtils_admob.isReady(activity)) {
            RewardUtils_admob.show(activity, result)
        }
//        if (isZh()) {
//            if (RewardUtils_gdt.isReady(registrar!!.activity())) {
//                RewardUtils_gdt.show(registrar.activity(), result)
//            } else if (RewardUtils_admob.isReady(registrar.activity())) {
//                RewardUtils_admob.show(registrar.activity(), result)
//            }
//        } else {
//            if (RewardUtils_admob.isReady(registrar!!.activity())) {
//                RewardUtils_admob.show(registrar.activity(), result)
//            } else if (RewardUtils_gdt.isReady(registrar.activity())) {
//                RewardUtils_gdt.show(registrar.activity(), result)
//            }
//        }
    }


    private fun isZh(): Boolean {
        return Locale.getDefault().language.contains("zh")
    }

    private fun onEvent(event: String) {
        Log.v(TAG, "onEvent : $event")
        //        if (!TextUtils.isEmpty(event) && eventChannel != null) {
        //            eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
        //                @Override
        //                public void onListen(Object o, EventChannel.EventSink eventSink) {
        //                    if (eventSink != null) {
        //                        eventSink.success(event);
        //                    }
        //                }
        //
        //                @Override
        //                public void onCancel(Object o) {
        //
        //                }
        //            });
        //        }
    }


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, KEY)
        context = binding.applicationContext
        channel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
        channel = null
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
}
