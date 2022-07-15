package cn.crane.crane_plugin.reward

import android.app.Activity
import android.content.Context
import cn.crane.crane_plugin.Const
import com.unity3d.mediation.IReward
import com.unity3d.mediation.IRewardedAdLoadListener
import com.unity3d.mediation.IRewardedAdShowListener
import com.unity3d.mediation.RewardedAd
import com.unity3d.mediation.errors.LoadError
import com.unity3d.mediation.errors.ShowError
import io.flutter.plugin.common.MethodChannel

object RewardUtils_u : BaseReward() {
    private var rewardVideoAD: RewardedAd? = null
    private var adLoaded = false
    private var videoCached = false
    private var rewardId: String? = Const.ADMOB_VIDEO
    private var result: MethodChannel.Result? = null

    private var hasEarnReward: Boolean = false

    override fun loadAd(context: Context?) {
        adLoaded = false
        videoCached = false
        rewardVideoAD = null

        context?.let {
            rewardVideoAD = RewardedAd(context as Activity, Const.U_REWARD)
            rewardVideoAD?.load(object : IRewardedAdLoadListener {
                override fun onRewardedLoaded(p0: RewardedAd?) {
                    rewardVideoAD = p0
                    sendEvent("onAdLoaded")
                }

                override fun onRewardedFailedLoad(p0: RewardedAd?, p1: LoadError?, p2: String?) {
                    rewardVideoAD = null
                    sendEvent("onAdFailedToLoad")
                }

            })
        }
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
        RewardUtils_u.result = result


        return if (rewardVideoAD != null) {

            rewardVideoAD?.show(object : IRewardedAdShowListener {
                override fun onRewardedShowed(p0: RewardedAd?) {
                    rewardVideoAD = null;
                }

                override fun onRewardedClicked(p0: RewardedAd?) {
                }

                override fun onRewardedClosed(p0: RewardedAd?) {
                    result?.success(hasEarnReward)
                    loadAd(context)
                }

                override fun onRewardedFailedShow(p0: RewardedAd?, p1: ShowError?, p2: String?) {
                    loadAd(context)
                }

                override fun onUserRewarded(p0: RewardedAd?, p1: IReward?) {
                    if (p1 != null) {
                        hasEarnReward = true;
                        loadAd(context)
                        sendEvent("onUserEarnedReward_true")
                    } else {
                        hasEarnReward = false;
                        loadAd(context)
                        sendEvent("onUserEarnedReward_false")
                    }

                }

            })
            true
        } else {
            loadAd(context)
            false
        }
    }
}