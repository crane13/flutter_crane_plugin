package cn.crane.crane_plugin

import android.app.Activity
import android.content.Context
import android.text.TextUtils
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import cn.crane.crane_plugin.bview.BViewManager
import com.google.android.gms.ads.*
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
    private var adView: AdView? = null
    private val admob_bannerId = Const.ADMOB_BANNER
    private var size: String? = null
    private var isGDT = false
    private var eventSink: EventSink? = null

    constructor() {}


    internal constructor(context: Context?, messenger: BinaryMessenger?, id: Int, params: Map<String?, Any>?) {
        if (params != null) {
            if (params.containsKey("size")) {
                size = params["size"].toString()
            }
        }
        loadBanner(context, null)

        messenger?.let {
            methodChannel = MethodChannel(messenger, PLUGIN_VIEW + "_\$id")
            eventChannel = EventChannel(messenger, PLUGIN_VIEW)
            eventChannel!!.setStreamHandler(this)
            methodChannel!!.setMethodCallHandler(this)
        }
    }

    fun loadBanner(context: Context?, linearLayout: LinearLayout?): View? {
        val adRequest: AdRequest = if (Const.TEST_DEVICE) {
            RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("132F365BB511B8350BC1081E2BB87D15"));
            AdRequest.Builder()
//                    .addTestDevice("132F365BB511B8350BC1081E2BB87D15")
                    .build()
        } else {
            AdRequest.Builder()
                    .build()
        }
        getAdBanner(context as Activity?, linearLayout).loadAd(adRequest)
        return adView
    }


    override fun getView(): View {
        return adView!!
    }

    override fun dispose() {
    }

    private val isLarge: Boolean
        private get() = "large".equals(size, ignoreCase = true)

    private fun getAdBanner(activity: Activity?, linearLayout: LinearLayout?): AdView {
        if (adView != null) {
            linearLayout?.removeAllViews()
            adView!!.destroy()
        }
        adView = AdView(activity)
        adView!!.adSize = if (isLarge) AdSize.MEDIUM_RECTANGLE else AdSize.BANNER
        adView!!.adUnitId = admob_bannerId
        adView!!.alpha = 1f
        adView!!.adListener = object : AdListener() {
            override fun onAdClosed() {
                onEventAdmob("onAdClosed")
            }

            override fun onAdOpened() {
                onEventAdmob("onAdOpened")
            }

            override fun onAdLoaded() {
                onEventAdmob("onAdLoaded")
            }

            override fun onAdClicked() {
                onEventAdmob("onAdClicked")
            }

            override fun onAdImpression() {
                adView!!.alpha = 1f
                onEventAdmob("onAdImpression")
            }
        }
        if (linearLayout != null) {
            linearLayout.removeAllViews()
            val params = LinearLayout.LayoutParams((320 * CraneApp.fDensity).toInt(), (50 * CraneApp.fDensity).toInt())
            linearLayout.addView(adView, params)
        }
        return adView as AdView
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
