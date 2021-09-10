package cn.crane.crane_plugin

import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import androidx.annotation.NonNull
import com.google.android.gms.ads.MobileAds
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine


open class CraneActivity : FlutterActivity() {

    private lateinit var linearLayout: LinearLayout
    private var ggView: GGView = GGView()

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
        ggView.loadBanner(this, linearLayout)
    }

    fun setShowBanner(show: Boolean) {
        if (show) {
            linearLayout.visibility = View.VISIBLE
        } else {
            linearLayout.visibility = View.INVISIBLE
        }
    }
}
