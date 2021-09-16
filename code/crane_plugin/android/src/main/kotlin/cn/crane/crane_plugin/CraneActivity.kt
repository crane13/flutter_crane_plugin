package cn.crane.crane_plugin

import android.os.Build
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import cn.crane.crane_plugin.bview.BView_admob
import com.google.android.gms.ads.MobileAds
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine


open class CraneActivity : FlutterActivity() {

    private lateinit var linearLayout: LinearLayout

    private var decorView: View? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        flutterEngine.plugins.add(CranePlugin())
        flutterEngine.plugins.add(FlutterGGPlugin(this))
        GGViewFactory.registerWith(flutterEngine, this)

        MobileAds.initialize(this) {}
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        linearLayout = LinearLayout(this)

        linearLayout.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        )


        var params = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.WRAP_CONTENT
        )
        params.gravity = Gravity.BOTTOM
        params.bottomMargin = 0
        linearLayout.gravity = Gravity.CENTER
        addContentView(linearLayout, params)

        decorView = window.decorView
    }

    fun loadBanner() {
        setShowBanner(true)

        BView_admob.loadView(context, linearLayout, false)
    }

    fun setShowBanner(show: Boolean) {
        if (show) {
            linearLayout.visibility = View.VISIBLE
        } else {
            linearLayout.visibility = View.INVISIBLE
        }
    }

    override fun onStart() {
        //调用配置
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            init()
        }
        super.onStart()
    }


    @RequiresApi(Build.VERSION_CODES.KITKAT)
    private fun init() {
        val flag = (View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION // hide

                //  | View.SYSTEM_UI_FLAG_FULLSCREEN // 不隐藏状态栏，因为隐藏了比如时间电量等信息也会隐藏
                or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY)
        //判断当前版本在4.0以上并且存在虚拟按键，否则不做操作
        if (Build.VERSION.SDK_INT < 19 || !checkDeviceHasNavigationBar()) {
            //一定要判断是否存在按键，否则在没有按键的手机调用会影响别的功能。如之前没有考虑到，导致图传全屏变成小屏显示。
            return
        } else {
            //自定义工具，设置状态栏颜色是透明
//      ViewUtil.setWindowStatusBarColor(this, R.color.transparent)
            // 获取属性
            decorView?.systemUiVisibility = flag
        }
    }

    /**
     * 判断是否存在虚拟按键
     * @return
     */
    fun checkDeviceHasNavigationBar(): Boolean {
        var hasNavigationBar = false
        val rs = resources
        val id = rs.getIdentifier("config_showNavigationBar", "bool", "android")
        if (id > 0) {
            hasNavigationBar = rs.getBoolean(id)
        }
        try {
            val systemPropertiesClass = Class.forName("android.os.SystemProperties")
            val m = systemPropertiesClass.getMethod("get", String::class.java)
            val navBarOverride = m.invoke(systemPropertiesClass, "qemu.hw.mainkeys") as String
            if ("1" == navBarOverride) {
                hasNavigationBar = false
            } else if ("0" == navBarOverride) {
                hasNavigationBar = true
            }
        } catch (e: Exception) {

        }

        return hasNavigationBar
    }
}
