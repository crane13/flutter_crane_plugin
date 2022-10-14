package cn.crane.crane_plugin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import cn.crane.crane_plugin.privacy.PrivacyUtils

open class PrivacyActivity : Activity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (!PrivacyUtils.hasAgreePrivacy(this)) {
            PrivacyUtils.check(this, object : PrivacyUtils.Callback {
                override fun onAgreed() {
                    jumpMainPage();
                }
            })
        } else {
            jumpMainPage();
        }

    }

    private fun jumpMainPage() {
        var intent = Intent(this, CraneActivity::class.java)
        startActivity(intent)
        finish()
    }

}
