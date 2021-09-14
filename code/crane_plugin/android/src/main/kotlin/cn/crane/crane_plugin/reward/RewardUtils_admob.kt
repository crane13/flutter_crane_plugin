package cn.crane.crane_plugin.reward

import android.app.Activity
import android.content.Context
import cn.crane.crane_plugin.Const
import com.google.android.gms.ads.*
import com.google.android.gms.ads.rewarded.RewardItem
import com.google.android.gms.ads.rewarded.RewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback
import io.flutter.plugin.common.MethodChannel

object RewardUtils_admob : BaseReward() {
    private var rewardVideoAD: RewardedAd? = null
    private var adLoaded = false
    private var videoCached = false
    private var rewardId: String? = Const.ADMOB_VIDEO
    private var result: MethodChannel.Result? = null

    override fun loadAd(context: Context?) {
        adLoaded = false
        videoCached = false
        rewardVideoAD = null
        var adRequest = AdRequest.Builder().build()
        RewardedAd.load(context, rewardId, adRequest, object : RewardedAdLoadCallback() {
            override fun onAdLoaded(var1: RewardedAd?) {

                rewardVideoAD = var1
                sendEvent(javaClass.simpleName + "onAdLoaded")
            }

            override fun onAdFailedToLoad(var1: LoadAdError?) {
                sendEvent(javaClass.simpleName + "onAdFailedToLoad")
            }
        })
    }

    override fun isReady(context: Context?): Boolean {
        return if (rewardVideoAD != null) {
            true
        } else {
            if (context != null) {
                loadAd(context)
            }
            false
        }
    }

    override fun show(context: Context?, result: MethodChannel.Result?): Boolean {
        RewardUtils_admob.result = result
        return if (rewardVideoAD != null) {
            rewardVideoAD?.fullScreenContentCallback = object : FullScreenContentCallback() {
                override fun onAdDismissedFullScreenContent() {
                    loadAd(context)
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
                        sendEvent(javaClass.simpleName + "onUserEarnedReward_true")
                    } else {
                        result?.success(false)
                        loadAd(context)
                        sendEvent(javaClass.simpleName + "onUserEarnedReward_false")
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