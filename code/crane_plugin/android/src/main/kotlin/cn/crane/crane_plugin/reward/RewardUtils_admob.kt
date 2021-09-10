package cn.crane.crane_plugin.reward

import android.app.Activity
import android.content.Context
import android.text.TextUtils
import cn.crane.crane_plugin.Const
import cn.crane.crane_plugin.EventCallback
import cn.crane.crane_plugin.CraneActivity
import cn.crane.crane_plugin.pop.PopUtils_admob
import com.google.android.gms.ads.*
import com.google.android.gms.ads.rewarded.RewardItem
import com.google.android.gms.ads.rewarded.RewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback
import io.flutter.plugin.common.MethodChannel

object RewardUtils_admob {
    private var rewardVideoAD: RewardedAd? = null
    private var adLoaded = false
    private var videoCached = false
    private var appId: String? = Const.ADMOB_ID
    private var rewardId: String? = Const.ADMOB_VIDEO
    private var eventCallback: EventCallback? = null
    private var result: MethodChannel.Result? = null
    fun setEventCallback(callback: EventCallback?) {
        eventCallback = callback
    }

    fun sendEvent(event: String?) {
        eventCallback?.sendEvent(String.format("Admob_%s", event))
    }

    fun setAppAndRewardId(appId: String?, rewardId: String?) {
        if (!TextUtils.isEmpty(appId) && !TextUtils.isEmpty(rewardId)) {
            RewardUtils_admob.appId = appId
            RewardUtils_admob.rewardId = rewardId
        }
    }


    fun loadAd(context: Context?): RewardedAd? {
        adLoaded = false
        videoCached = false
        rewardVideoAD = null
        var adRequest = AdRequest.Builder().build()
        RewardedAd.load(context, rewardId, adRequest, object : RewardedAdLoadCallback() {
            override fun onAdLoaded(var1: RewardedAd?) {
                rewardVideoAD = var1
            }

            override fun onAdFailedToLoad(var1: LoadAdError?) {}
        })
        return rewardVideoAD
    }

//    private fun loadAd(context: MainActivity?) {
//        adLoaded = false
//        videoCached = false
//        val adLoadCallback: RewardedAdLoadCallback = object : RewardedAdLoadCallback() {
//            override fun onRewardedAdLoaded() { // Ad successfully loaded.
//                sendEvent("onRewardedAdLoaded")
//            }
//
//            override fun onRewardedAdFailedToLoad(errorCode: Int) { // Ad failed to load.
//                sendEvent("onRewardedAdFailedToLoad")
//            }
//        }
//        getRewardVideoAD(context)!!.loadAd(AdRequest.Builder().addTestDevice("1AE526D5B3C57E01BA577BAA4D64F58A").build(), adLoadCallback)
//    }

    fun isReady(context: CraneActivity?): Boolean {
        return if (rewardVideoAD != null) {
            true
        } else {
            if (context != null) {
                loadAd(context)
            }
            false
        }
    }

    fun show(context: CraneActivity?, result: MethodChannel.Result?): Boolean {
        RewardUtils_admob.result = result
        return if (rewardVideoAD != null) {
            rewardVideoAD?.fullScreenContentCallback = object : FullScreenContentCallback() {
                override fun onAdDismissedFullScreenContent() {
                    PopUtils_admob.initReward(context)
                }

                override fun onAdFailedToShowFullScreenContent(adError: AdError?) {
                }

                override fun onAdShowedFullScreenContent() {
                    result?.success(false)
                    rewardVideoAD = null;
                }
            }
            val adCallback: OnUserEarnedRewardListener = object : OnUserEarnedRewardListener {
                override fun onUserEarnedReward(var1: RewardItem?) {
                    if (var1 != null) {
                        sendEvent("onUserEarnedReward")
                        result?.success(true)
                        loadAd(context)
                    } else {
                        result?.success(false)
                        loadAd(context)
                    }

                }
            }
            rewardVideoAD!!.show(context as Activity, adCallback)
            true
        } else {
            loadAd(context)
            false
        }
    }
}