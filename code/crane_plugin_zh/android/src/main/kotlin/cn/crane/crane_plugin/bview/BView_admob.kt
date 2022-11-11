//package cn.crane.crane_plugin.bview
//
//import android.content.Context
//import android.view.View
//import android.widget.LinearLayout
//import cn.crane.crane_plugin.Const
//import cn.crane.crane_plugin.CraneApp
//import cn.crane.crane_plugin.utils.CheckUtils
//import com.google.android.gms.ads.*
//import java.util.*
//
//object BView_admob : BaseBView() {
//    private var adView: AdView? = null
//
//
//    override fun loadView(context: Context, linearLayout: LinearLayout, isLarge: Boolean) {
//        if(!CheckUtils.isEnable()) return
//        val adRequest: AdRequest = if (Const.TEST_DEVICE) {
//            RequestConfiguration.Builder()
//                .setTestDeviceIds(Arrays.asList("132F365BB511B8350BC1081E2BB87D15"));
//            AdRequest.Builder()
////                    .addTestDevice("132F365BB511B8350BC1081E2BB87D15")
//                .build()
//        } else {
//            AdRequest.Builder()
//                .build()
//        }
//
//        if (adView != null) {
//            adView!!.destroy()
//        }
//        var av1 = AdView(context)
//        av1.setAdSize(if (isLarge) AdSize.MEDIUM_RECTANGLE else AdSize.BANNER)
//        av1.adUnitId = Const.ADMOB_BANNER
//        av1.alpha = 1f
//        av1.adListener = object : AdListener() {
//            override fun onAdClosed() {
//                sendEvent("onAdClosed")
//            }
//
//            override fun onAdOpened() {
//                sendEvent("onAdOpened")
//            }
//
//            override fun onAdLoaded() {
//                sendEvent("onAdLoaded")
//            }
//
//            override fun onAdClicked() {
//                sendEvent("onAdClicked")
//            }
//
//            override fun onAdImpression() {
//                av1.alpha = 1f
//                sendEvent("onAdImpression")
//            }
//        }
//        if (linearLayout != null) {
//            linearLayout.removeAllViews()
//            val params = LinearLayout.LayoutParams(
//                (320 * CraneApp.fDensity).toInt(),
//                (50 * CraneApp.fDensity).toInt()
//            )
//            linearLayout.addView(av1, params)
//        } else {
//            adView = av1
//        }
//        av1.loadAd(adRequest)
//    }
//
//    override fun isReady(): Boolean {
//        return adView != null
//    }
//
//
//    override fun getView(): View? {
//        return adView
//    }
//}