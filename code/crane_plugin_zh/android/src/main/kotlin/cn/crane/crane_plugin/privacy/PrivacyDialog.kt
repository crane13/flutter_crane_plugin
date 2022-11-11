package cn.crane.crane_plugin.privacy

import android.app.Dialog
import android.content.Context
import android.content.DialogInterface
import android.content.res.Configuration
import android.os.Bundle
import android.text.Html
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import cn.crane.crane_plugin.CraneApp
import cn.crane.crane_plugin.R

class PrivacyDialog : Dialog {
    private var onBtnClickListener: OnBtnClickListener? = null
    private val text_content =
        //            "在您使用我们的服务之前，请认真阅读<a href=\"https://cranedev123.github.io/release/privacy_cn.html\">《用户协议》</a>和<a href=\"https://cranedev123.github.io/release/privacy_cn.html\">《隐私政策》</a>相关条款。<br/>" +
        "    1.为了更好的保护您的合法权益并向您提供更好的服务，我们将会收集用户信息和处理您的游戏交互数据。包括但不限于设备标识符、地理位置、游戏时长、过关数据等信息。<br/>" + "    2.未经您同意，我们不会将您的个人信息透露、出租或出售给任何第三方。<br/>" + "    如您同意，请点击\"同意\"按钮开始接受我们的服务。<br/><br/>" + "    您可以阅读完整版<a href=\"https://cranedev123.github.io/release/tos_cn.html\">《用户协议》</a>和<a href=\"https://cranedev123.github.io/release/privacy_cn.html\">《隐私政策》</a>"

    constructor(context: Context) : super(context) {}
    constructor(context: Context, themeResId: Int) : super(context, themeResId) {}
    protected constructor(
        context: Context, cancelable: Boolean, cancelListener: DialogInterface.OnCancelListener?
    ) : super(context, cancelable, cancelListener) {
    }

    fun setOnBtnClickListener(onBtnClickListener: OnBtnClickListener?) {
        this.onBtnClickListener = onBtnClickListener
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.dialog_privacy)
        setCancelable(false)
        setCanceledOnTouchOutside(false)
        initViews()
    }

    private fun isPortrait(): Boolean {
        return context?.resources?.configuration?.orientation == Configuration.ORIENTATION_PORTRAIT
    }

    private fun initViews() {
        val tvContent = findViewById<TextView>(R.id.tv_content)
        val bgLayout = findViewById<View>(R.id.bg_layout)


        if (!isPortrait()) {
            bgLayout.layoutParams.width = (CraneApp.getMaxW() * 0.5f).toInt()
        }else{
            bgLayout.layoutParams.width = (270 * CraneApp.fDensity).toInt()
        }

        tvContent.text = Html.fromHtml(text_content)
        TextViewUtils.dealwithLink(
            tvContent
        ) { url, title ->
            run {
                WebActivity.show(tvContent.context, url, title)
            }
        }
        findViewById<View>(R.id.btn_exit).setOnClickListener {
            if (onBtnClickListener != null) {
                onBtnClickListener!!.onCanceled()
            }
            //            dismiss();
            if (ownerActivity != null) {
                ownerActivity!!.finish()
            }
        }
        findViewById<View>(R.id.btn_agree).setOnClickListener {
            if (onBtnClickListener != null) {
                onBtnClickListener!!.onAgreed()
            }
            dismiss()
        }
    }

    override fun onStart() {
        super.onStart()
        if (window != null) {
            window!!.setGravity(Gravity.CENTER)
            window!!.attributes.width = ViewGroup.LayoutParams.MATCH_PARENT
            window!!.attributes.height = ViewGroup.LayoutParams.MATCH_PARENT
        }
    }

    interface OnBtnClickListener {
        fun onAgreed()
        fun onCanceled()
    }
}