package cn.crane.crane_plugin.pop

import android.app.Activity
import android.content.Context
import cn.crane.crane_plugin.Const.TT_POP
import cn.crane.crane_plugin.utils.TTUtils
import com.bytedance.sdk.openadsdk.AdSlot
import com.bytedance.sdk.openadsdk.TTAdNative
import com.bytedance.sdk.openadsdk.TTAdNative.FullScreenVideoAdListener
import com.bytedance.sdk.openadsdk.TTFullScreenVideoAd
import com.bytedance.sdk.openadsdk.TTFullScreenVideoAd.FullScreenVideoAdInteractionListener

object FullVideoUtils_tt : BasePop() {
    const val MIN_DURATION = (2 * 20 * 1000).toLong()
    private var mTTAdNative: TTAdNative? = null
    private var mttFullVideoAd: TTFullScreenVideoAd? = null
    private var isLoaded = false
    private var lastShowTime: Long = 0
    private fun loadInteractionAd(context: Context?) {
        isLoaded = false
        //step4:创建插屏广告请求参数AdSlot,具体参数含义参考文档
        val adSlot = AdSlot.Builder().setCodeId(TT_POP)
            .setSupportDeepLink(true) //                .setOrientation()
            .setImageAcceptedSize(1920, 1080) //根据广告平台选择的尺寸，传入同比例尺寸
            .build()
        //step5:请求广告，调用插屏广告异步请求接口
        if (mTTAdNative == null) {
            mTTAdNative = TTUtils.get().createAdNative(context)
        }
        mTTAdNative!!.loadFullScreenVideoAd(adSlot, object : FullScreenVideoAdListener {
            override fun onError(code: Int, message: String) {
//                TToast.show(getApplicationContext(), "code: " + code + "  message: " + message);
            }

            override fun onFullScreenVideoAdLoad(ttFullScreenVideoAd: TTFullScreenVideoAd) {
                mttFullVideoAd = ttFullScreenVideoAd
                mttFullVideoAd!!.setFullScreenVideoAdInteractionListener(object :
                    FullScreenVideoAdInteractionListener {
                    override fun onAdShow() {
//                        TToast.show(FullScreenVideoActivity.this, "FullVideoAd show");
                    }

                    override fun onAdVideoBarClick() {
//                        TToast.show(FullScreenVideoActivity.this, "FullVideoAd bar click");
                    }

                    override fun onAdClose() {
//                        TToast.show(FullScreenVideoActivity.this, "FullVideoAd close");
                    }

                    override fun onVideoComplete() {
//                        TToast./show(FullScreenVideoActivity.this, "FullVideoAd complete");
                    }

                    override fun onSkippedVideo() {
//                        TToast.show(FullScreenVideoActivity.this, "FullVideoAd skipped");
                    }
                })
            }

            override fun onFullScreenVideoCached() {
                isLoaded = true
            }

            override fun onFullScreenVideoCached(ttFullScreenVideoAd: TTFullScreenVideoAd) {}
        })
    }

    override fun loadAd(context: Context?) {
        loadInteractionAd(context)
    }

    override fun isReady(context: Context?): Boolean {
        val isReady = mttFullVideoAd != null && isLoaded
        if (!isReady) {
            loadAd(context)
        }
        val current = System.currentTimeMillis()
        val duration = current - lastShowTime
        return if (duration < MIN_DURATION) {
            false
        } else isReady
    }

    override fun show(context: Context?): Boolean {
        if (isReady(context)) {
            if (context is Activity) {
                lastShowTime = System.currentTimeMillis()
                mttFullVideoAd!!.showFullScreenVideoAd(context as Activity?)
                isLoaded = false
                loadAd(context)
                return true
            }
        }
        return false
    }

}