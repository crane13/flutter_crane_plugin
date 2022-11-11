package cn.crane.crane_plugin.reward

import android.app.Activity
import android.content.Context
import android.os.Bundle
import cn.crane.crane_plugin.Const.TT_REWARD
import cn.crane.crane_plugin.event.EventCallback
import cn.crane.crane_plugin.utils.TTUtils
import com.bytedance.sdk.openadsdk.*
import com.bytedance.sdk.openadsdk.TTAdNative.RewardVideoAdListener
import com.bytedance.sdk.openadsdk.TTRewardVideoAd.RewardAdInteractionListener
import io.flutter.plugin.common.MethodChannel

object RewardUtils_tt : BaseReward() {
    private var adLoaded = false
    private var videoCached = false
    private val eventCallback: EventCallback? = null
    private var result: MethodChannel.Result? = null
    private val rewardId = TT_REWARD
    private var hasComplete = false
    private var mTTAdNative: TTAdNative? = null
    private var mttRewardVideoAd: TTRewardVideoAd? = null
    private val ttAppDownloadListener: TTAppDownloadListener = object : TTAppDownloadListener {
        override fun onIdle() {}
        override fun onDownloadActive(l: Long, l1: Long, s: String, s1: String) {}
        override fun onDownloadPaused(l: Long, l1: Long, s: String, s1: String) {}
        override fun onDownloadFailed(l: Long, l1: Long, s: String, s1: String) {}
        override fun onDownloadFinished(l: Long, s: String, s1: String) {}
        override fun onInstalled(s: String, s1: String) {}
    }
    private val isValid: Boolean
        private get() {
            var valid = false
            if (mttRewardVideoAd != null) {
                valid = true
            }
            return valid
        }

    override fun loadAd(context: Context?) {
        adLoaded = false
        videoCached = false
        val adSlot = AdSlot.Builder().setCodeId(rewardId).setSupportDeepLink(true).setAdCount(2)
            .setImageAcceptedSize(1080, 1920) //                .setRewardName("life") //奖励的名称
            //                .setRewardAmount(1)   //奖励的数量
            //必传参数，表来标识应用侧唯一用户；若非服务器回调模式或不需sdk透传
            //可设置为空字符串
            .setUserID("")
            .setOrientation(TTAdConstant.HORIZONTAL) //设置期望视频播放的方向，为TTAdConstant.HORIZONTAL或TTAdConstant.VERTICAL
            .setMediaExtra("media_extra") //用户透传的信息，可不传
            .build()
        if (mTTAdNative == null) {
            mTTAdNative = TTUtils.get().createAdNative(context)
        }
        mTTAdNative!!.loadRewardVideoAd(adSlot, object : RewardVideoAdListener {
            override fun onError(i: Int, s: String) {}
            override fun onRewardVideoAdLoad(ttRewardVideoAd: TTRewardVideoAd) {
                sendEvent("onADLoad")
                adLoaded = true
                mttRewardVideoAd = ttRewardVideoAd
                //mttRewardVideoAd.setShowDownLoadBar(false);
                if (mttRewardVideoAd != null) {
                    mttRewardVideoAd!!.setRewardAdInteractionListener(object :
                        RewardAdInteractionListener {
                        override fun onAdShow() {}
                        override fun onAdVideoBarClick() {}
                        override fun onAdClose() {
                            sendEvent("onADClose")
                            if (result != null) {
                                result!!.success(hasComplete)
                            }
                            loadAd(context)
                        }

                        override fun onVideoComplete() {
                            sendEvent("onVideoComplete")
                            hasComplete = true
                        }

                        override fun onVideoError() {}
                        override fun onRewardVerify(
                            b: Boolean, i: Int, s: String, i1: Int, s1: String
                        ) {
                        }

                        override fun onRewardArrived(b: Boolean, i: Int, bundle: Bundle) {}
                        override fun onSkippedVideo() {}
                    })
                    mttRewardVideoAd!!.setDownloadListener(ttAppDownloadListener)
                }
            }

            override fun onRewardVideoCached() {
                videoCached = true
                sendEvent("onVideoCached")
            }

            override fun onRewardVideoCached(ttRewardVideoAd: TTRewardVideoAd) {}
        })
    }

    override fun isReady(context: Context?): Boolean {
        return if (isValid) {
            true
        } else {
            loadAd(context)
            false
        }
    }

    override fun show(context: Context?, result: MethodChannel.Result?): Boolean {
        this.result = result
        hasComplete = false
        if (adLoaded && mttRewardVideoAd != null) {
            mttRewardVideoAd!!.showRewardVideoAd(context as Activity?)
            adLoaded = false
            return true
        }
        return false
    }
}