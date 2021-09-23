package cn.crane.crane_plugin

import android.util.Log
import cn.crane.crane_plugin.event.EventCallback
import cn.crane.crane_plugin.pop.PopManager
import cn.crane.crane_plugin.reward.RewardManager
import cn.crane.crane_plugin.utils.CraneUtils
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/**
 *
 */
class FlutterGGPlugin : MethodCallHandler, FlutterPlugin {
    companion object {
        val TAG = FlutterGGPlugin::class.java.simpleName
        val KEY = "flutter_gg"
    }

    private var channel: MethodChannel? = null
    private var activity: CraneActivity? = null

    constructor(activity: CraneActivity) : super() {
        this.activity = activity
    }

    private var eventCallback: EventCallback = object : EventCallback {
        override fun sendEvent(event: String) {
            onEvent(event)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        if (call.method == null) return
        Log.v(TAG, "onMethodCall : " + call.method)

        when (call.method) {
            "getPlatformVersion" -> {
                result.success(CraneUtils.getAppVersionName(activity))
            }
            "showBannerEnable" -> {
                if (activity is CraneActivity) {
                    val activity = activity as CraneActivity
                    activity.setShowBanner(call.argument<Boolean>("showBanner")!!)
                }
                result.success(true)
            }
            "showbanner" -> {
                if (activity is CraneActivity) {
                    val activity = activity as CraneActivity
                    activity.loadBanner()
                }
                result.success(true)
            }

            "showPopAd" -> {
                PopManager.setEventCallback(eventCallback)
                result.success(PopManager.show(activity))
            }
            "isRewardVideoReady" -> {
                result.success(RewardManager.isReady(activity))
            }
            "showRewardAd" -> {
                RewardManager.setEventCallback(eventCallback)
                RewardManager.show(activity, result)
            }
            "isPad" -> {
                result.success(CraneUtils.isPad(activity))
            }
            "getChannel" -> {
                result.success("crane")
            }
            else -> result.notImplemented()
        }

    }


    private fun onEvent(event: String) {
        Log.v(TAG, "onEvent : $event")
//                if (!TextUtils.isEmpty(event) && eventChannel != null) {
//                    eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
//                        @Override
//                        public void onListen(Object o, EventChannel.EventSink eventSink) {
//                            if (eventSink != null) {
//                                eventSink.success(event);
//                            }
//                        }
//
//                        @Override
//                        public void onCancel(Object o) {
//
//                        }
//                    });
//                }
    }


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, KEY)
        channel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
        channel = null
    }


}
