package cn.crane.crane_plugin.utils

import android.content.Context
import cn.crane.crane_plugin.Const
import com.bytedance.sdk.openadsdk.TTAdConfig
import com.bytedance.sdk.openadsdk.TTAdConstant
import com.bytedance.sdk.openadsdk.TTAdSdk
import com.bytedance.sdk.openadsdk.TTCustomController


object MergeUtils {
    fun init(context: Context, debug: Boolean) {

        //强烈建议在应用对应的Application#onCreate()方法中调用，避免出现content为null的异常
        TTAdSdk.init(context, TTAdConfig.Builder().appId(Const.TT_ID)//xxxxxxx为穿山甲媒体平台注册的应用ID
            .useTextureView(true) //默认使用SurfaceView播放视频广告,当有SurfaceView冲突的场景，可以使用TextureView
//            .appName("APP测试媒体")
            .titleBarTheme(TTAdConstant.TITLE_BAR_THEME_DARK)//落地页主题
            .allowShowNotify(true) //是否允许sdk展示通知栏提示,若设置为false则会导致通知栏不显示下载进度
            .debug(debug) //测试阶段打开，可以通过日志排查问题，上线时去除该调用
            .directDownloadNetworkType(TTAdConstant.NETWORK_STATE_WIFI) //允许直接下载的网络状态集合,没有设置的网络下点击下载apk会有二次确认弹窗，弹窗中会披露应用信息
            .supportMultiProcess(false) //是否支持多进程，true支持
            .customController(object : TTCustomController() {

            })
            .asyncInit(true) //是否异步初始化sdk,设置为true可以减少SDK初始化耗时。3450版本开始废弃~~
            //.httpStack(new MyOkStack3())//自定义网络库，demo中给出了okhttp3版本的样例，其余请自行开发或者咨询工作人员。
            .build(),
            object : TTAdSdk.InitCallback {
            override fun success() {
            }

            override fun fail(p0: Int, p1: String?) {
            }

        })
        //如果明确某个进程不会使用到广告SDK，可以只针对特定进程初始化广告SDK的content
        //if (PROCESS_NAME_XXXX.equals(processName)) {
        //   TTAdSdk.init(context, config);
        //}
    }
}