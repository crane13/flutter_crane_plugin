//package cn.crane.crane_plugin.pop;
//
//import android.app.Activity;
//import android.content.Context;
//
//import com.bytedance.sdk.openadsdk.AdSlot;
//import com.bytedance.sdk.openadsdk.TTAdConstant;
//import com.bytedance.sdk.openadsdk.TTAdDislike;
//import com.bytedance.sdk.openadsdk.TTAdNative;
//import com.bytedance.sdk.openadsdk.TTAppDownloadListener;
//import com.bytedance.sdk.openadsdk.TTInteractionAd;
//
//import cn.crane.crane_plugin.Const;
//import cn.crane.crane_plugin.utils.TTUtils;
//
//
//public class PopUtils_tt {
//    public static final String TAG = PopUtils_tt.class.getSimpleName();
//
//    private static PopUtils_tt instace;
//    private static TTAdNative mTTAdNative;
//    private static TTInteractionAd interactionAd;
//    private static boolean isLoaded = false;
//
//    public static PopUtils_tt getInstace() {
//        if (instace == null) {
//            instace = new PopUtils_tt();
//        }
//        return instace;
//    }
//
//    public static void loadAd(Context context) {
//        loadInteractionAd(context);
//    }
//
//    private static void loadInteractionAd(Context context) {
//        isLoaded = false;
//        //step4:创建插屏广告请求参数AdSlot,具体参数含义参考文档
//        AdSlot adSlot = new AdSlot.Builder()
//                .setCodeId(Const.INSTANCE.getTT_POP())
//                .setSupportDeepLink(true)
//                .setImageAcceptedSize(600, 600) //根据广告平台选择的尺寸，传入同比例尺寸
//                .build();
//        //step5:请求广告，调用插屏广告异步请求接口
//        if (mTTAdNative == null) {
//            mTTAdNative = TTUtils.get().createAdNative(context);
//        }
//        mTTAdNative.loadInteractionAd(adSlot, new TTAdNative.InteractionAdListener() {
//            @Override
//            public void onError(int code, String message) {
////                TToast.show(getApplicationContext(), "code: " + code + "  message: " + message);
//            }
//
//            @Override
//            public void onInteractionAdLoad(TTInteractionAd ttInteractionAd) {
////                TToast.show(getApplicationContext(), "type:  " + ttInteractionAd.getInteractionType());
//                ttInteractionAd.setAdInteractionListener(new TTInteractionAd.AdInteractionListener() {
//                    @Override
//                    public void onAdClicked() {
////                        Log.d(TAG, "被点击");
////                        TToast.show(mContext, "广告被点击");
//                    }
//
//                    @Override
//                    public void onAdShow() {
////                        Log.d(TAG, "被展示");
////                        TToast.show(mContext, "广告被展示");
//                        isLoaded = false;
//                    }
//
//                    @Override
//                    public void onAdDismiss() {
////                        Log.d(TAG, "插屏广告消失");
////                        TToast.show(mContext, "广告消失");
//                    }
//                });
//                //如果是下载类型的广告，可以注册下载状态回调监听
//                if (ttInteractionAd.getInteractionType() == TTAdConstant.INTERACTION_TYPE_DOWNLOAD) {
//                    ttInteractionAd.setDownloadListener(new TTAppDownloadListener() {
//                        @Override
//                        public void onIdle() {
////                            Log.d(TAG, "点击开始下载");
////                            TToast.show(mContext, "点击开始下载");
//                        }
//
//                        @Override
//                        public void onDownloadActive(long totalBytes, long currBytes, String fileName, String appName) {
////                            Log.d(TAG, "下载中");
////                            TToast.show(mContext, "下载中");
//                        }
//
//                        @Override
//                        public void onDownloadPaused(long totalBytes, long currBytes, String fileName, String appName) {
////                            Log.d(TAG, "下载暂停");
////                            TToast.show(mContext, "下载暂停");
//                        }
//
//                        @Override
//                        public void onDownloadFailed(long totalBytes, long currBytes, String fileName, String appName) {
////                            Log.d(TAG, "下载失败");
////                            TToast.show(mContext, "下载失败");
//                        }
//
//                        @Override
//                        public void onDownloadFinished(long totalBytes, String fileName, String appName) {
////                                Log.d(TAG, "下载完成");
////                            TToast.show(mContext, "下载完成");
//                        }
//
//                        @Override
//                        public void onInstalled(String fileName, String appName) {
////                            Log.d(TAG, "安装完成");
////                            TToast.show(mContext, "安装完成");
//                        }
//                    });
//                }
//                ttInteractionAd.setShowDislikeIcon(new TTAdDislike.DislikeInteractionCallback() {
//                    @Override
//                    public void onSelected(int position, String value) {
//                        //TToast.show(mContext, "反馈了 " + value);
////                        TToast.show(mContext,"\t\t\t\t\t\t\t感谢您的反馈!\t\t\t\t\t\t\n我们将为您带来更优质的广告体验",3);
//                    }
//
//                    @Override
//                    public void onCancel() {
////                        TToast.show(mContext, "点击取消 ");
//                    }
//
//                    @Override
//                    public void onRefuse() {
////                        TToast.show(mContext,"您已成功提交反馈，请勿重复提交哦！",3);
//                    }
//                });
//                //弹出插屏广告
//                interactionAd = ttInteractionAd;
//                isLoaded = true;
//            }
//        });
//    }
//
//
//    public static boolean isReady(Context context) {
//        boolean isReady = interactionAd != null && isLoaded;
//        if(!isReady)
//        {
//            loadAd(context);
//        }
//        return isReady;
//    }
//
//    public static boolean show(Context context) {
//        if (isReady(context)) {
//            if (context instanceof Activity) {
//                interactionAd.showInteractionAd((Activity) context);
//                isLoaded = false;
//                return true;
//            }
//        }
//
//        return false;
//    }
//}
