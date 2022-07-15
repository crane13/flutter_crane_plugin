package cn.crane.crane_plugin.utils

import cn.crane.crane_plugin.Const
import com.unity3d.mediation.IInitializationListener
import com.unity3d.mediation.InitializationConfiguration
import com.unity3d.mediation.UnityMediation
import com.unity3d.mediation.errors.SdkInitializationError


class MergeUtils {
    fun init() {
        val configuration = InitializationConfiguration.builder()
            .setGameId(Const.U_ID)
            .setInitializationListener(object : IInitializationListener {
                override fun onInitializationComplete() {
                    // Unity Mediation is initialized. Try loading an ad.
                    println("Unity Mediation is successfully initialized.")
                }

                override fun onInitializationFailed(
                    errorCode: SdkInitializationError?,
                    msg: String?
                ) {
                    // Unity Mediation failed to initialize. Printing failure reason...
                    System.out.println("Unity Mediation Failed to Initialize : $msg")
                }
            }).build()

        UnityMediation.initialize(configuration)
    }
}