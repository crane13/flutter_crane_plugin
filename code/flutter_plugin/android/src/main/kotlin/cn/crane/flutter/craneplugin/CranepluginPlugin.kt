package cn.crane.flutter.craneplugin

import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** CranepluginPlugin */
public class CranepluginPlugin : FlutterPlugin, MethodCallHandler {
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "craneplugin")
        channel.setMethodCallHandler(CranepluginPlugin());
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        val TAG = CranepluginPlugin::class.java.simpleName
        private lateinit var registrar: Registrar;
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            this.registrar = registrar;
            val channel = MethodChannel(registrar.messenger(), "craneplugin")
            channel.setMethodCallHandler(CranepluginPlugin())
        }

        fun getAppVersionName(context: Context): String {
            var appVersionName = ""
            try {
                val packageInfo = context.applicationContext
                        .packageManager
                        .getPackageInfo(context.packageName, 0)
                appVersionName = packageInfo.versionName
            } catch (e: PackageManager.NameNotFoundException) {
//                Log.e("", e.message)
            }

            return appVersionName
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
//    if (call.method == "getPlatformVersion") {
//      result.success("Android ${android.os.Build.VERSION.RELEASE}")
//    } else {
//      result.notImplemented()
//    }
        if (call != null) {
            Log.v(TAG, "onMethodCall : " + call.method)
            when (call.method) {
                "getPlatformVersion" -> result.success(getAppVersionName(registrar.activity()))
                "registerSid" -> {
                }
//                "showBannerEnable" -> {
//                    if (registrar != null && registrar.activity() is MainActivity) {
//                        val activity: MainActivity = registrar.activity() as MainActivity
//                        activity.setShowBanner(call.argument("showBanner"))
//                    }
//                    result.success(true)
//                }
                "registerAdmobId" ->  //                    MobileAds.initialize(registrar.activity(), call.argument("admob_appId"));
                    result.notImplemented()
//                "showbanner" -> {
//                    showBanner(call)
//                    result.success(true)
//                }
//                "showPopAd" -> {
//                    PopUtils_admob.setEventCallback(eventCallback)
//                    result.success(PopUtils_admob.show(registrar.activity()))
//                }
//                "showRewardAd" -> {
//                    RewardUtils_admob.setEventCallback(eventCallback)
//                    RewardUtils_gdt.setEventCallback(eventCallback)
//                    showVideo(result)
//                }
                "isPad" -> result.success(false)
//                "isRewardVideoReady" -> result.success(isVideoReady())
                else -> result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

}
