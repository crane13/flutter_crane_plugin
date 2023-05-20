package cn.crane.crane_plugin.utils;

import android.content.Context;
import android.util.Log;

import com.bytedance.sdk.openadsdk.TTAdConfig;
import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdManager;
import com.bytedance.sdk.openadsdk.TTAdSdk;

import cn.crane.crane_plugin.Const;
import cn.crane.crane_plugin.R;


public class TTUtils {
    private static boolean sInit = false;


    public static TTAdManager get() {
        if (!sInit) {
//            throw new RuntimeException("TTAdSdk is not init, please check.");
//            init(App.);
        }
        return TTAdSdk.getAdManager();
    }

    public static void init(Context context) {
        doInit(context);
    }

    //step1:接入网盟广告sdk的初始化操作，详情见接入文档和穿山甲平台说明
    private static void doInit(Context context) {
        if (!sInit) {

//            LockerService.startService(this);
//            ExecuteTaskManager.getInstance().init();
//            DaemonEnv.initialize(this, TraceService.class, DaemonEnv.DEFAULT_WAKE_UP_INTERVAL);
//            TraceService.sShouldStopService = false;
//            DaemonEnv.startServiceMayBind(TraceService.class);

            TTAdSdk.init(context, buildConfig(context.getApplicationContext()), new TTAdSdk.InitCallback() {

                @Override
                public void success() {
                    Log.v("tttttt", "success");
                }

                @Override
                public void fail(int i, String s) {
                    Log.v("tttttt", "fail : " + i + ",, s : " + s);
                }
            });
            sInit = true;
        }
    }

//    private static TTAdConfig buildConfig(Context context) {
//        String id = Const.INSTANCE.getTT_ID();
//        Log.v("tttttt", "buildConfig : " + id);
//        return new TTAdConfig.Builder().appId(id).useTextureView(true) //使用TextureView控件播放视频,默认为SurfaceView,当有SurfaceView冲突的场景，可以使用TextureView
//                .appName(context.getString(R.string.app_name)).titleBarTheme(TTAdConstant.TITLE_BAR_THEME_DARK).allowShowNotify(true) //是否允许sdk展示通知栏提示
//                .allowShowPageWhenScreenLock(true) //是否在锁屏场景支持展示广告落地页
//                .debug(true) //测试阶段打开，可以通过日志排查问题，上线时去除该调用
//                .directDownloadNetworkType(TTAdConstant.NETWORK_STATE_WIFI, TTAdConstant.NETWORK_STATE_3G) //允许直接下载的网络状态集合
//                .supportMultiProcess(false)//是否支持多进程
//                .asyncInit(true).needClearTaskReset()
//                //.httpStack(new MyOkStack3())//自定义网络库，demo中给出了okhttp3版本的样例，其余请自行开发或者咨询工作人员。
//                .build();
//    }

    private static TTAdConfig buildConfig(Context context) {
        String id = Const.INSTANCE.getTT_ID();
        return new TTAdConfig.Builder()
//                .appId("5001121")
//                .appId("5074839")
                .appId(id)
                .useTextureView(true) //使用TextureView控件播放视频,默认为SurfaceView,当有SurfaceView冲突的场景，可以使用TextureView
                .allowShowNotify(true) //是否允许sdk展示通知栏提示
                .debug(true) //测试阶段打开，可以通过日志排查问题，上线时去除该调用

                .directDownloadNetworkType(TTAdConstant.NETWORK_STATE_WIFI, TTAdConstant.NETWORK_STATE_3G) //允许直接下载的网络状态集合
                .supportMultiProcess(false)//是否支持多进程
                .needClearTaskReset()
//                .injectionAuth(TTLiveTokenHelper.getInstance().useHostAuth() ? new TTInjectionAuthImpl() : null)
                .build();
    }

    public static void requestPermissionIfNecessary(Context context) {
        if (TTAdSdk.getAdManager() != null && context != null) {
            TTAdSdk.getAdManager().requestPermissionIfNecessary(context.getApplicationContext());
        }

    }


}
