package cn.crane.crane_plugin.pop

import android.app.Activity
import android.content.Context
import cn.crane.crane_plugin.Const
import com.unity3d.mediation.IInterstitialAdLoadListener
import com.unity3d.mediation.IInterstitialAdShowListener
import com.unity3d.mediation.InterstitialAd
import com.unity3d.mediation.errors.LoadError
import com.unity3d.mediation.errors.ShowError

object PopUtils_u : BasePop() {
    private var adLoaded = false
    private var videoCached = false
    private var interstitialAd: InterstitialAd? = null

    override fun loadAd(context: Context?) {
        context?.let {
            interstitialAd = InterstitialAd(context as Activity, Const.U_POP)
            interstitialAd?.load(object : IInterstitialAdLoadListener{
                override fun onInterstitialLoaded(p0: InterstitialAd?) {
                    interstitialAd = p0
//                sendEvent("onAdLoaded")
                }

                override fun onInterstitialFailedLoad(
                    p0: InterstitialAd?,
                    p1: LoadError?,
                    p2: String?
                ) {
                    interstitialAd = null
                sendEvent("onAdFailedToLoad")
                }

            })
        }
    }


    override fun show(context: Context?): Boolean {
        adLoaded = false
        videoCached = false
        var shown = false

        if (interstitialAd != null) {

            interstitialAd?.show(object : IInterstitialAdShowListener {
                override fun onInterstitialShowed(p0: InterstitialAd?) {
                    interstitialAd = null;
                    sendEvent("onAdShowedFullScreenContent")
                }

                override fun onInterstitialClicked(p0: InterstitialAd?) {
                }

                override fun onInterstitialClosed(p0: InterstitialAd?) {
                    loadAd(context)
                    sendEvent("onAdDismissedFullScreenContent")
                }

                override fun onInterstitialFailedShow(
                    p0: InterstitialAd?,
                    p1: ShowError?,
                    p2: String?
                ) {
                    sendEvent("onAdFailedToShowFullScreenContent")
                }

            })
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