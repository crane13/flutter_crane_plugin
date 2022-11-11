package cn.crane.crane_plugin

import android.app.Activity
import android.content.Context
import android.text.TextUtils
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import cn.crane.crane_plugin.bview.BannerUtils_tt
import com.bytedance.sdk.openadsdk.TTAdNative
import com.bytedance.sdk.openadsdk.TTNativeExpressAd
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import java.util.*

class GGView : PlatformView, MethodCallHandler, EventChannel.StreamHandler {
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private val enableGDT = true
    private var size: String? = null
    private var isGDT = false
    private var eventSink: EventSink? = null
    private val mTTAdNative: TTAdNative? = null
    private val mTTAd: TTNativeExpressAd? = null
    private val adTT: View? = null
    private var llTT: LinearLayout? = null

    constructor() {}

    fun setIds(
        gdt_appId: String?,
        gdt_bannerId: String?,
        admob_appId: String?,
        admob_bannerId: String?
    ) {
//        if (!TextUtils.isEmpty(admob_appId) && !TextUtils.isEmpty(admob_bannerId)) {
//            this.admob_appId = admob_appId;
//            this.admob_bannerId = admob_bannerId;
//        }
//        if (!TextUtils.isEmpty(gdt_appId) && !TextUtils.isEmpty(gdt_bannerId)) {
//            this.gdt_appId = gdt_appId;
//            this.gdt_bannerId = gdt_bannerId;
//        }
    }

    internal constructor(
        context: Context?,
        messenger: BinaryMessenger?,
        id: Int,
        params: Map<String?, Any>?
    ) {
//        linearLayout = new LinearLayout(context);
//        linearLayout.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
//        linearLayout.setBackgroundColor(Color.TRANSPARENT);
        if (params != null) {
//            if (params.containsKey("gdt_appId")) {
//                gdt_appId = params.get("gdt_appId").toString();
//            }
//            if (params.containsKey("gdt_bannerId")) {
//                gdt_bannerId = params.get("gdt_bannerId").toString();
//            }
//            if (params.containsKey("admob_appId")) {
//                admob_appId = params.get("admob_appId").toString();
//            }
//            if (params.containsKey("admob_bannerId")) {
//                admob_bannerId = params.get("admob_bannerId").toString();
//            }
            if (params.containsKey("size")) {
                size = params["size"].toString()
            }
        }
        llTT = LinearLayout(context)
        loadBanner(context, llTT)
        methodChannel = MethodChannel(messenger!!, PLUGIN_VIEW + "_\$id")
        eventChannel = EventChannel(messenger, PLUGIN_VIEW)
        eventChannel!!.setStreamHandler(this)
        methodChannel!!.setMethodCallHandler(this)
    }

    fun loadBanner(context: Context?, linearLayout: LinearLayout?): View? {
        isGDT = isGDT(context)
        //
        return if (isGDT) {
            BannerUtils_tt.getBanner_tt(context as Activity?, linearLayout, isLarge)
            adTT
        } else {
            null
        }
    }

    fun loadBanner_() {
//
        if (isGDT) {
//            if (mBannerAd != null) {
//                mBannerAd.loadAD()
//            }
        } else {
        }
    }

    override fun getView(): View? {
        return if (isGDT) {
            llTT
        } else {
            null
        }
    }

    override fun dispose() {
//        if (mBannerAd != null) {
//            try {
//                mBannerAd.destroy()
//            } catch (e: Exception) {
//                e.printStackTrace()
//            }
//        }
        mTTAd?.destroy()
    }

    private val isLarge: Boolean
        private get() = "large".equals(size, ignoreCase = true)


    private fun chooseWhich() {
//        canGDT = zh && hasPermission && hasId;
//        canAdmob = hasappid && hasbannerId;
//
//        if(zh)
//        {
//            if(canGDT)
//            {
//                return gdt;
//            }else {
//                return Admob;
//            }
//        }else {
//            if(canAdmob)
//            {
//                return Admob;
//            }else {
//                return gdt;
//            }
//        }
    }

    private fun isGDT(context: Context?): Boolean {
        return true
    }

    private fun hasPermission(context: Context): Boolean {
//        if (Build.VERSION.SDK_INT >= 23) {
//            if (context != null) {
//                return context.checkSelfPermission(Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED
//                        && context.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
//                        && context.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
//            } else {
//                return false;
//            }
//
//        } else {
//            return true;
//        }
        return true
    }

    private fun onEventGDT(event: String) {
        var event = event
        Log.v("qqqq", "lonEventGDT: $event")
        if (!TextUtils.isEmpty(event)) {
            if (!event.contains("GDT_banner_")) {
                event = "GDT_banner_$event"
            }
            onEvent(event)
        }
    }

    private fun onEventAdmob(event: String) {
        var event = event
        if (!TextUtils.isEmpty(event)) {
            if (!event.contains("Admob_banner_")) {
                event = "Admob_banner_$event"
            }
            onEvent(event)
        }
    }

    private fun onEvent(event: String) {
        Log.v(TAG, "onEvent : $event")
        //        if (!TextUtils.isEmpty(event) && eventChannel != null) {
//            final String finalEvent = event;
//            if (eventSink != null) {
//                eventSink.success(finalEvent);
//            }
////            eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
////                @Override
////                public void onListen(Object o, EventChannel.EventSink eventSink) {
////                    if (eventSink != null) {
////                        eventSink.success(finalEvent);
////                    }
////                }
////
////                @Override
////                public void onCancel(Object o) {
////
////                }
////            });
//        }
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        result.notImplemented()
    }

    override fun onListen(o: Any, eventSink: EventSink) {
        this.eventSink = eventSink
    }

    override fun onCancel(o: Any) {}

    companion object {
        val TAG = GGView::class.java.simpleName
        const val PLUGIN_VIEW = "plugins.crane.view/GGView"
        const val PLUGIN_EVENT = "plugins.crane.view/GGEvent"
    }
}