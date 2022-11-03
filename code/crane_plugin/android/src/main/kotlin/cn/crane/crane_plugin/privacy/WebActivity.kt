package cn.crane.crane_plugin.privacy

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.net.http.SslError
import android.os.Build
import android.os.Bundle
import android.view.KeyEvent
import android.view.View
import android.webkit.*
import android.widget.ProgressBar
import android.widget.TextView
import cn.crane.crane_plugin.R

open class WebActivity : Activity() {

    var url: String? = ""
    var title: String? = ""
    var tvTitle: TextView? = null
    var webview: WebView? = null
    var ivBack: View? = null
    var mProgressBar: ProgressBar? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.ac_web)
        tvTitle = findViewById(R.id.tv_title)
        webview = findViewById(R.id.webview)
        ivBack = findViewById(R.id.iv_back)
        mProgressBar = findViewById(R.id.progress_bar)
        ivBack?.setOnClickListener { onBackClicked() }
        initWebview()

        url = intent?.getStringExtra(KEY_URL)
        title = intent?.getStringExtra(KEY_TITLE)

        tvTitle?.text = title
        url?.let { webview?.loadUrl(it) }

    }

    private fun initWebview() {
        try {
            if (webview == null) return
            var mWebview: WebView = webview!!
            mWebview.let {
                mWebview.settings.setSupportZoom(false)
                mWebview.settings.builtInZoomControls = false
                mWebview.settings.javaScriptEnabled = true
                mWebview.settings.pluginState = WebSettings.PluginState.ON
                mWebview.settings.blockNetworkImage = false
                mWebview.settings.setRenderPriority(WebSettings.RenderPriority.HIGH)
                // 应用数据
                mWebview.settings.domStorageEnabled = true
                mWebview.settings.allowFileAccess = true
                mWebview.isVerticalScrollBarEnabled = false
                mWebview.setVerticalScrollbarOverlay(false)
                mWebview.isHorizontalScrollBarEnabled = false
                mWebview.setHorizontalScrollbarOverlay(false)
                mWebview.settings.allowContentAccess = true
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                    mWebview.settings.allowFileAccessFromFileURLs = true
                }

                // Cache
                mWebview.settings.setAppCacheEnabled(true)
                mWebview.settings.databaseEnabled = true
                if (isConnected(this)) {
                    mWebview.settings.cacheMode =
                        WebSettings.LOAD_DEFAULT // 根据cache-control决定是否从网络上取数据
                } else {
                    mWebview.settings.cacheMode =
                        WebSettings.LOAD_CACHE_ELSE_NETWORK // 先查找缓存，没有的情况下从网络获取。
                }
                mWebview.settings.layoutAlgorithm = WebSettings.LayoutAlgorithm.NARROW_COLUMNS
                mWebview.settings.javaScriptCanOpenWindowsAutomatically = true
                mWebview.settings.useWideViewPort = true
                mWebview.settings.loadWithOverviewMode = true
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    mWebview.settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
                }
                val ua: String = mWebview.settings.userAgentString
                mWebview.settings.userAgentString = "$ua; crane-studio"
                mWebview.requestFocus(View.FOCUS_DOWN)
                mWebview.requestFocusFromTouch()
                mWebview.webChromeClient = object : WebChromeClient() {
                    override fun onProgressChanged(view: WebView, newProgress: Int) {
                        super.onProgressChanged(view, newProgress)
                        if (mProgressBar != null) {
                            mProgressBar?.visibility =
                                if (newProgress >= 100) View.GONE else View.VISIBLE
                            mProgressBar?.progress = newProgress
                        }
                    }
                }
                mWebview.webViewClient = object : WebViewClient() {
                    override fun onReceivedSslError(
                        view: WebView, handler: SslErrorHandler?, error: SslError
                    ) {
                        super.onReceivedSslError(view, handler, error)
                        handler?.proceed()
                    }
                }
            }

        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    open fun isConnected(context: Context?): Boolean {
        if (null != context) {
            val connectivity = context.getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager
            if (null != connectivity) {
                val info = connectivity.activeNetworkInfo
                if (null != info && info.isConnected) {
                    if (info.state == NetworkInfo.State.CONNECTED) {
                        return true
                    }
                }
            }
        }
        return false
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            onBackClicked();
            return true;
        }
        return super.onKeyDown(keyCode, event)
    }

    private fun onBackClicked() {
        if (webview != null) {
            if (webview!!.canGoBack()) {
                webview?.goBack()
                return
            }
        }
        finish()
    }

    companion object {
        const val KEY_URL = "key_url"
        const val KEY_TITLE = "key_title"

        fun show(context: Context?, url: String?, title: String?) {
            try {
                var intent = Intent(context, WebActivity::class.java)
                intent.putExtra(KEY_URL, url)
                intent.putExtra(KEY_TITLE, title)
                context?.startActivity(intent)
            } catch (e: Exception) {

            }
        }
    }


}
