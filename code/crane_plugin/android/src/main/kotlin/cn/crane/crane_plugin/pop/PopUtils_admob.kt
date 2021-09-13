package cn.crane.crane_plugin.pop

import android.app.Activity
import android.content.Context
import android.text.TextUtils
import cn.crane.crane_plugin.Const
import cn.crane.crane_plugin.EventCallback
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback

object PopUtils_admob {
    private var adLoaded = false
    private var videoCached = false
    private var interstitialAd: InterstitialAd? = null
    private var appId: String? = Const.ADMOB_ID
    private var positionId: String? = Const.ADMOB_POP
    private var eventCallback: EventCallback? = null
    fun setEventCallback(callback: EventCallback?) {
        eventCallback = callback
    }

    fun sendEvent(event: String?) {
        eventCallback?.sendEvent(String.format("Admob_%s", event))
    }

    fun setAppAndRewardId(appId: String?, rewardId: String?) {
        if (!TextUtils.isEmpty(appId) && !TextUtils.isEmpty(rewardId)) {
            PopUtils_admob.appId = appId
            positionId = rewardId
        }
    }

    fun initReward(context: Context?) {

        var adRequest = AdRequest.Builder().build()

        InterstitialAd.load(context, positionId, adRequest, object : InterstitialAdLoadCallback() {
            override fun onAdFailedToLoad(adError: LoadAdError) {
                interstitialAd = null
            }

            override fun onAdLoaded(interstitialAd: InterstitialAd) {
                PopUtils_admob.interstitialAd = interstitialAd
            }
        })
    }


    public fun showAd(context: Context): Boolean {
        adLoaded = false
        videoCached = false
        var shown = false

        if (interstitialAd != null) {
            interstitialAd?.fullScreenContentCallback = object : FullScreenContentCallback() {
                override fun onAdDismissedFullScreenContent() {
                    initReward(context)
                }

                override fun onAdFailedToShowFullScreenContent(adError: AdError?) {
                }

                override fun onAdShowedFullScreenContent() {
                    interstitialAd = null;
                }
            }
            interstitialAd?.show(context as Activity)
            shown = true
        } else {
            initReward(context);
        }

        return shown
    }


    val isReady: Boolean
        get() = interstitialAd != null

}