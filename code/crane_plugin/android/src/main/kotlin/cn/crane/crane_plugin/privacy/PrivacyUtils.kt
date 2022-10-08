package cn.crane.crane_plugin.privacy

import android.app.Activity
import android.content.Context
import android.content.SharedPreferences
import cn.crane.crane_plugin.Const
import cn.crane.crane_plugin.R
import cn.crane.crane_plugin.privacy.PrivacyDialog.OnBtnClickListener

object PrivacyUtils {
    private const val SHPRE_NAME = "privacy_cache"
    private const val KEY_HAS_AGREE = "key_has_agree"
    private var sharedPreferences: SharedPreferences? = null
    fun check(context: Context?, callback: Callback) {
        if (context == null) return
        if (!Const.SHOW_PRIVACY) {
            callback?.onAgreed()
            return
        }
        sharedPreferences =
            context.applicationContext.getSharedPreferences(SHPRE_NAME, Context.MODE_PRIVATE)
        val agreed = sharedPreferences?.getBoolean(KEY_HAS_AGREE, false)
        if (agreed != null && !agreed) {
            showDialog(context, callback)
        } else {
            callback?.onAgreed()
        }
    }

    fun hasAgreePrivacy(context: Context?): Boolean {
        if (sharedPreferences == null) {
            if (context != null) {
                sharedPreferences = context.getSharedPreferences(SHPRE_NAME, Context.MODE_PRIVATE)
            }
        }
        var agreed = false
        if (sharedPreferences != null) {
            agreed = sharedPreferences!!.getBoolean(KEY_HAS_AGREE, false)
        }
        return agreed
    }

    private fun showDialog(context: Context?, callback: Callback?) {
        context?.let {
            val dialog = PrivacyDialog(context, R.style.MyDialog)
            if (context is Activity) {
                dialog.setOwnerActivity(context)
            }
            dialog.setOnBtnClickListener(object : OnBtnClickListener {
                override fun onAgreed() {
                    sharedPreferences!!.edit().putBoolean(KEY_HAS_AGREE, true).apply()
                    callback?.onAgreed()
                }

                override fun onCanceled() {}
            })
            dialog.show()
        }
    }

    interface Callback {
        fun onAgreed()
    }
}