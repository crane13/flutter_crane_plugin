package cn.crane.crane_plugin.bview;

import android.app.Activity;
import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;

import com.bytedance.sdk.openadsdk.AdSlot;
import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdDislike;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTAppDownloadListener;
import com.bytedance.sdk.openadsdk.TTNativeExpressAd;

import java.util.List;

import cn.crane.crane_plugin.Const;
import cn.crane.crane_plugin.utils.TTUtils;


public class BannerUtils_tt {

    private static TTAdNative mTTAdNative;
    private static TTNativeExpressAd mTTAd;
    private static View adTT;

    public static void getBanner_tt(final Activity context, final LinearLayout linearLayout, boolean isLarge) {

//        isLarge = false;
        int w = 600;
        int h = isLarge ? 500 : 90;

        int viewW = isLarge ? 250 : 300;
        int viewH = isLarge ? 208 : 45;
//        //设置广告参数
        AdSlot adSlot = new AdSlot.Builder()
                .setCodeId(isLarge ? Const.INSTANCE.getTT_BANNER_600_500() : Const.INSTANCE.getTT_BANNER()) //广告位id
                .setSupportDeepLink(true)
                .setAdCount(3) //请求广告数量为1到3条
                .setUserID("")
                .setExpressViewAcceptedSize(viewW, viewH) //期望个性化模板广告view的size,单位dp
                .setImageAcceptedSize(w, h)//这个参数设置即可，不影响个性化模板广告的size
                .build();
        //加载广告
        if (mTTAdNative == null) {
            mTTAdNative = TTUtils.get().createAdNative(context);
        }
        mTTAdNative.loadBannerExpressAd(adSlot, new TTAdNative.NativeExpressAdListener() {
            @Override
            public void onError(int code, String message) {
//                TToast.show(NativeExpressActivity.this, "load error : " + code + ", " + message);
                if (linearLayout != null) {
                    linearLayout.removeAllViews();
                }
            }

            @Override
            public void onNativeExpressAdLoad(List<TTNativeExpressAd> ads) {
                if (ads == null || ads.size() == 0) {
                    return;
                }
                mTTAd = ads.get(0);
                mTTAd.setSlideIntervalTime(30 * 1000);//设置轮播间隔 ms,不调用则不进行轮播展示
                bindAdListener(context, mTTAd, linearLayout);
                mTTAd.render();//调用render开始渲染广告
            }
        });
    }

    private static void bindAdListener(Activity context, TTNativeExpressAd ad, final LinearLayout mExpressContainer) {
        ad.setExpressInteractionListener(new TTNativeExpressAd.ExpressAdInteractionListener() {
            @Override
            public void onAdClicked(View view, int type) {
//                TToast.show(mContext, "广告被点击");
            }

            @Override
            public void onAdShow(View view, int type) {
//                TToast.show(mContext, "广告展示");
            }

            @Override
            public void onRenderFail(View view, String msg, int code) {
//                Log.e("ExpressView","render fail:"+(System.currentTimeMillis() - startTime));
//                TToast.show(mContext, msg+" code:"+code);
            }

            @Override
            public void onRenderSuccess(View view, float width, float height) {
                //返回view的宽高 单位 dp
//                TToast.show(mContext, "渲染成功");
                //在渲染成功回调时展示广告，提升体验
                adTT = view;
//                Toast.makeText(context, "onRenderSuccess : " + mExpressContainer, 1).show();
                if (mExpressContainer != null) {
                    mExpressContainer.removeAllViews();
//                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                    mExpressContainer.setGravity(Gravity.CENTER);
                    mExpressContainer.addView(view);
                }
            }
        });
        //dislike设置
        bindDislike(context, mExpressContainer, ad, false);
        if (ad.getInteractionType() != TTAdConstant.INTERACTION_TYPE_DOWNLOAD) {
            return;
        }
        //可选，下载监听设置
        ad.setDownloadListener(new TTAppDownloadListener() {
            @Override
            public void onIdle() {
//                TToast.show(BannerExpressActivity.this, "点击开始下载", Toast.LENGTH_LONG);
            }

            @Override
            public void onDownloadActive(long totalBytes, long currBytes, String fileName, String appName) {
//                if (!mHasShowDownloadActive) {
//                    mHasShowDownloadActive = true;
//                    TToast.show(BannerExpressActivity.this, "下载中，点击暂停", Toast.LENGTH_LONG);
//                }
            }

            @Override
            public void onDownloadPaused(long totalBytes, long currBytes, String fileName, String appName) {
//                TToast.show(BannerExpressActivity.this, "下载暂停，点击继续", Toast.LENGTH_LONG);
            }

            @Override
            public void onDownloadFailed(long totalBytes, long currBytes, String fileName, String appName) {
//                TToast.show(BannerExpressActivity.this, "下载失败，点击重新下载", Toast.LENGTH_LONG);
            }

            @Override
            public void onInstalled(String fileName, String appName) {
//                TToast.show(BannerExpressActivity.this, "安装完成，点击图片打开", Toast.LENGTH_LONG);
            }

            @Override
            public void onDownloadFinished(long totalBytes, String fileName, String appName) {
//                TToast.show(BannerExpressActivity.this, "点击安装", Toast.LENGTH_LONG);
            }
        });
    }

    /**
     * 设置广告的不喜欢，开发者可自定义样式
     *
     * @param ad
     * @param customStyle 是否自定义样式，true:样式自定义
     */
    private static void bindDislike(Context context, final LinearLayout mExpressContainer, TTNativeExpressAd ad, boolean customStyle) {
        if(ad == null || mExpressContainer == null || context == null)
        {
            return;
        }
//        if (customStyle) {
//            //使用自定义样式
//            List<FilterWord> words = ad.getFilterWords();
//            if (words == null || words.isEmpty()) {
//                return;
//            }
//
//            final DislikeDialog dislikeDialog = new DislikeDialog(this, words);
//            dislikeDialog.setOnDislikeItemClick(new DislikeDialog.OnDislikeItemClick() {
//                @Override
//                public void onItemClick(FilterWord filterWord) {
//                    //屏蔽广告
//                    TToast.show(mContext, "点击 " + filterWord.getName());
//                    //用户选择不喜欢原因后，移除广告展示
//                    mExpressContainer.removeAllViews();
//                }
//            });
//            ad.setDislikeDialog(dislikeDialog);
//            return;
//        }
        //使用默认个性化模板中默认dislike弹出样式
        ad.setDislikeCallback((Activity) context, new TTAdDislike.DislikeInteractionCallback() {

            @Override
            public void onShow() {

            }

            @Override
            public void onSelected(int i, String s, boolean b) {
                if (mExpressContainer != null) {
                    mExpressContainer.removeAllViews();
                }
            }

            @Override
            public void onCancel() {
//                TToast.show(mContext, "点击取消 ");
            }
        });
    }

    public static void destory()
    {
        if(adTT != null)
        {
            adTT = null;
        }
    }

}
