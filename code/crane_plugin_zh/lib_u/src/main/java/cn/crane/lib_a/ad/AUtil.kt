package cn.crane.lib_a.ad

import com.unity3d.mediation.IInitializationListener
import com.unity3d.mediation.InitializationConfiguration
import com.unity3d.mediation.UnityMediation
import com.unity3d.mediation.errors.SdkInitializationError

object AUtil {
    fun init(aID: String) {
        val configuration = InitializationConfiguration.builder()
            .setGameId(aID)
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