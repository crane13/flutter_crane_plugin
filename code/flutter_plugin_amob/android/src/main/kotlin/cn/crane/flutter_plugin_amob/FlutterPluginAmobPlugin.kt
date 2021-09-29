package cn.crane.flutter_plugin_amob

import android.app.Activity
import android.util.Log
import androidx.annotation.NonNull
import cn.crane.flutter_plugin_amob.event.EventCallback
import cn.crane.flutter_plugin_amob.pop.PopManager
import cn.crane.flutter_plugin_amob.reward.RewardManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterPluginAmobPlugin */
class FlutterPluginAmobPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null


    private var eventCallback: EventCallback = object : EventCallback {
        override fun sendEvent(event: String) {
            onEvent(event)
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_plugin_amob")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == null) return
        Log.v(TAG, "onMethodCall : " + call.method)

        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
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
            "getChannel" -> {
                result.success("crane")
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    companion object {
        val TAG = FlutterPluginAmobPlugin::class.simpleName
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

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }
}
