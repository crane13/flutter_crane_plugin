package cn.crane.crane_plugin.pop

import android.app.Activity
import android.content.Context
import cn.crane.crane_plugin.Const
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback

object PopUtils_admob : BasePop() {
    private var adLoaded = false
    private var videoCached = false
    private var interstitialAd: InterstitialAd? = null

    override fun loadAd(context: Context?) {
        context?.let {
            var adRequest = AdRequest.Builder().build()
            InterstitialAd.load(context, Const.ADMOB_POP, adRequest, object : InterstitialAdLoadCallback() {
                override fun onAdFailedToLoad(adError: LoadAdError) {
                    interstitialAd = null
                    sendEvent("onAdFailedToLoad")
                }

                override fun onAdLoaded(interstitialAd: InterstitialAd) {
                    PopUtils_admob.interstitialAd = interstitialAd
                    sendEvent("onAdLoaded")
                }
            })
        }

    }


    override fun show(context: Context?): Boolean {
        adLoaded = false
        videoCached = false
        var shown = false

        if (interstitialAd != null) {
            interstitialAd?.fullScreenContentCallback = object : FullScreenContentCallback() {
                override fun onAdDismissedFullScreenContent() {
                    loadAd(context)
                    sendEvent("onAdDismissedFullScreenContent")
                }

                override fun onAdFailedToShowFullScreenContent(p0: AdError) {
                    sendEvent("onAdFailedToShowFullScreenContent")
                }

                override fun onAdShowedFullScreenContent() {
                    interstitialAd = null;
                    sendEvent("onAdShowedFullScreenContent")
                }
            }
            interstitialAd?.show(context as Activity)
            shown = true
        } else {
            loadAd(context);
        }

        return shown
    }

    override fun isReady(context: Context?): Boolean {
        return if (interstitialAd != null) {
            true
        } else {
            if (context != null) {
                loadAd(context)
            }
            false
        }
    }


}