package cn.crane.flutter_plugin_amob.reward

import android.app.Activity
import android.content.Context
import cn.crane.flutter_plugin_amob.Const
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

    private var hasEarnReward : Boolean = false

    override fun loadAd(context: Context?) {
        adLoaded = false
        videoCached = false
        rewardVideoAD = null
        var adRequest = AdRequest.Builder().build()
        RewardedAd.load(context, rewardId, adRequest, object : RewardedAdLoadCallback() {
            override fun onAdLoaded(var1: RewardedAd?) {

                rewardVideoAD = var1
                sendEvent("onAdLoaded")
            }

            override fun onAdFailedToLoad(var1: LoadAdError?) {
                sendEvent("onAdFailedToLoad")
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
        hasEarnReward = false
        RewardUtils_admob.result = result
        return if (rewardVideoAD != null) {
            rewardVideoAD?.fullScreenContentCallback = object : FullScreenContentCallback() {
                override fun onAdDismissedFullScreenContent() {
                    result?.success(hasEarnReward)
                    loadAd(context)
                }

                override fun onAdFailedToShowFullScreenContent(adError: AdError?) {
                    loadAd(context)
                }

                override fun onAdShowedFullScreenContent() {
                    rewardVideoAD = null;

                }
            }
            val adCallback: OnUserEarnedRewardListener = object : OnUserEarnedRewardListener {
                override fun onUserEarnedReward(var1: RewardItem?) {
                    if (var1 != null) {
                        hasEarnReward = true;
                        loadAd(context)
                        sendEvent( "onUserEarnedReward_true")
                    } else {
                        hasEarnReward = false;
                        loadAd(context)
                        sendEvent("onUserEarnedReward_false")
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