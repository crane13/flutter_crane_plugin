package cn.crane.crane_plugin

import android.util.Log
import cn.crane.crane_plugin.event.EventCallback
import cn.crane.crane_plugin.gcenter.GameCenterHelper
import cn.crane.crane_plugin.pop.PopManager
import cn.crane.crane_plugin.reward.RewardManager
import cn.crane.crane_plugin.utils.CheckUtils
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
            "getPackageName" -> {
                result.success(CraneUtils.getPackageName(activity))
            }
            "showLeader" -> {
                if(!CheckUtils.isEnable()){
                    result.success(false)
                    return
                }
                var iScore = call.argument<Boolean>("score") as Int
                var rankId = call.argument<Boolean>("rankId") as String
                GameCenterHelper.getInstance().showLeaderboard(activity, rankId, iScore)
                result.success(true)
            }
            "reportScore" -> {
                if(!CheckUtils.isEnable()){
                    result.success(false)
                    return
                }
                var iScore = call.argument<Boolean>("score") as Int
                var rankId = call.argument<Boolean>("rankId") as String
                GameCenterHelper.getInstance().reportScore(activity, rankId, iScore)
                result.success(true)
            }
            "showBannerEnable" -> {
                if(!CheckUtils.isEnable()){
                    result.success(false)
                    return
                }
                if (activity is CraneActivity) {
                    val activity = activity as CraneActivity
                    activity.setShowBanner(call.argument<Boolean>("showBanner")!!)
                }
                result.success(true)
            }
            "showbanner" -> {
                if(!CheckUtils.isEnable()){
                    result.success(false)
                    return
                }
                if (activity is CraneActivity) {
                    val activity = activity as CraneActivity
                    activity.loadBanner()
                }
                result.success(true)
            }

            "showPopAd" -> {
                if(!CheckUtils.isEnable()){
                    result.success(false)
                    return
                }
                PopManager.setEventCallback(eventCallback)
                result.success(PopManager.show(activity))
            }
            "isRewardVideoReady" -> {
                if(!CheckUtils.isEnable()){
                    result.success(false)
                    return
                }
                result.success(RewardManager.isReady(activity))
            }
            "showRewardAd" -> {
                if(!CheckUtils.isEnable()){
                    result.success(false)
                    return
                }
                RewardManager.setEventCallback(eventCallback)
                RewardManager.show(activity, result)
            }
            "isPad" -> {
                result.success(CraneUtils.isPad(activity))
            }
            "getChannel" -> {
                result.success("crane")
            }
            "share" -> {
                var content: String = call.argument<String>("content") as String
                var url: String = call.argument<String>("url") as String
                CraneUtils.share(activity, content + url)
                result.success(true)
            }
            "lanchView" -> {
                var content: String = call.argument<String>("page") as String
                CraneUtils.opneUrl(activity, content )
                result.success("true")
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
