package cn.crane.crane_plugin.splash

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import androidx.lifecycle.ProcessLifecycleOwner
import cn.crane.crane_plugin.Const
import cn.crane.crane_plugin.CraneApp
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.appopen.AppOpenAd
import java.util.*

class AppOpenAdManager(app: CraneApp) : LifecycleObserver, Application.ActivityLifecycleCallbacks {
    private var appOpenAd: AppOpenAd? = null
    private var isLoadingAd = false
    var isShowingAd = false
    private var isFirstShow = true
    private var lastShowTime: Long = 0
    private var currentActivity: Activity? = null
    private val app: CraneApp

    /**
     * Keep track of the time an app open ad is loaded to ensure you don't show an expired ad.
     */
    private var loadTime: Long = 0
    private var startLoadTime: Long = 0

    /**
     * Load an ad.
     *
     * @param context the context of the activity that loads the ad
     */
    fun loadAd(context: Context?) {
        // Do not load ad if there is an unused ad or one is already loading.
        if (context == null) {
            return
        }
        if (isLoadingAd || isAdAvailable) {
            return
        }
        startLoadTime = System.currentTimeMillis()
        isLoadingAd = true
        val request = AdRequest.Builder().build()
        AppOpenAd.load(
            context,
            AD_UNIT_ID,
            request,
            if (Const.PORTRAIT) AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT else AppOpenAd.APP_OPEN_AD_ORIENTATION_LANDSCAPE,
            object : AppOpenAd.AppOpenAdLoadCallback() {
                /**
                 * Called when an app open ad has loaded.
                 *
                 * @param ad the loaded app open ad.
                 */
                override fun onAdLoaded(ad: AppOpenAd) {
                    appOpenAd = ad
                    isLoadingAd = false
                    loadTime = Date().time
                    Log.d(LOG_TAG, "onAdLoaded.")
                    //                        Toast.makeText(context, "onAdLoaded", Toast.LENGTH_SHORT).show();
                    if (isFirstShow) {
                        isFirstShow = false
                        val duration = System.currentTimeMillis() - startLoadTime
                        if (duration < 2 * 1000) {
                            showAdIfAvailable(currentActivity)
                        }
                    }
                }

                /**
                 * Called when an app open ad has failed to load.
                 *
                 * @param loadAdError the error.
                 */
                override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                    isLoadingAd = false
                    Log.d(
                        LOG_TAG,
                        "onAdFailedToLoad: " + if (loadAdError != null) loadAdError.getMessage() else ""
                    )
                    //                        Toast.makeText(context, "onAdFailedToLoad", Toast.LENGTH_SHORT).show();
                }
            })
    }

    /**
     * Check if ad was loaded more than n hours ago.
     */
    private fun wasLoadTimeLessThanNHoursAgo(numHours: Long): Boolean {
        val dateDifference = Date().time - loadTime
        val numMilliSecondsPerHour: Long = 3600000
        return dateDifference < numMilliSecondsPerHour * numHours
    }// Ad references in the app open beta will time out after four hours, but this time limit
    // may change in future beta versions. For details, see:
    // https://support.google.com/admob/answer/9341964?hl=en
    /**
     * Check if ad exists and can be shown.
     */
    private val isAdAvailable: Boolean
        private get() =// Ad references in the app open beta will time out after four hours, but this time limit
        // may change in future beta versions. For details, see:
            // https://support.google.com/admob/answer/9341964?hl=en
            appOpenAd != null && wasLoadTimeLessThanNHoursAgo(4)
    /**
     * Show the ad if one isn't already showing.
     *
     * @param activity                 the activity that shows the app open ad
     * @param onShowAdCompleteListener the listener to be notified when an app open ad is complete
     */
    /**
     * Show the ad if one isn't already showing.
     *
     * @param activity the activity that shows the app open ad
     */
    @JvmOverloads
    fun showAdIfAvailable(
        activity: Activity?,
        onShowAdCompleteListener: OnShowAdCompleteListener =
            object : OnShowAdCompleteListener {
                override fun onShowAdComplete() {
                    // Empty because the user will go back to the activity that shows the ad.
                }
            }
    ) {
        // If the app open ad is already showing, do not show the ad again.
        if (activity == null) {
            return
        }
        if (isShowingAd) {
            Log.d(LOG_TAG, "The app open ad is already showing.")
            return
        }


        // If the app open ad is not available yet, invoke the callback then load the ad.
        if (!isAdAvailable) {
            Log.d(LOG_TAG, "The app open ad is not ready yet.")
            onShowAdCompleteListener.onShowAdComplete()
            if (isLoadingAd) {
                Log.d(LOG_TAG, "The app open ad is Loading.")
                return
            }
            loadAd(activity)
            return
        }
        Log.d(LOG_TAG, "Will show ad.")

//        long duration = System.currentTimeMillis() - lastShowTime;
//        if(duration < DURATION){
//            return;
//        }
        appOpenAd?.fullScreenContentCallback = object : FullScreenContentCallback() {
            /** Called when full screen content is dismissed.  */
            override fun onAdDismissedFullScreenContent() {
                // Set the reference to null so isAdAvailable() returns false.
                appOpenAd = null
                isShowingAd = false
                Log.d(LOG_TAG, "onAdDismissedFullScreenContent.")
                //                        Toast.makeText(activity, "onAdDismissedFullScreenContent", Toast.LENGTH_SHORT).show();
                onShowAdCompleteListener.onShowAdComplete()
                loadAd(activity)
            }

            /** Called when fullscreen content failed to show.  */
            override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                appOpenAd = null
                isShowingAd = false
                Log.d(
                    LOG_TAG,
                    "onAdFailedToShowFullScreenContent: " + (adError.message ?: "")
                )
                //                        Toast.makeText(activity, "onAdFailedToShowFullScreenContent", Toast.LENGTH_SHORT)
                //                                .show();
                onShowAdCompleteListener.onShowAdComplete()
                loadAd(activity)
            }

            /** Called when fullscreen content is shown.  */
            override fun onAdShowedFullScreenContent() {
                Log.d(LOG_TAG, "onAdShowedFullScreenContent.")
                //                        Toast.makeText(activity, "onAdShowedFullScreenContent", Toast.LENGTH_SHORT).show();
            }
        }
        isShowingAd = true
        appOpenAd?.show(activity)
        lastShowTime = System.currentTimeMillis()
    }

    override fun onActivityCreated(activity: Activity, bundle: Bundle?) {}
    override fun onActivityStarted(activity: Activity) {
        currentActivity = activity
    }

    override fun onActivityResumed(activity: Activity) {
        currentActivity = activity
    }

    override fun onActivityPaused(activity: Activity) {}
    override fun onActivityStopped(activity: Activity) {}
    override fun onActivitySaveInstanceState(activity: Activity, bundle: Bundle) {}
    override fun onActivityDestroyed(activity: Activity) {
        currentActivity = null
    }

    /** LifecycleObserver methods  */
    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    fun onStart() {
        showAdIfAvailable(currentActivity)
        Log.d(LOG_TAG, "onStart")
    }

    companion object {
        private const val LOG_TAG = "AppOpenAdManager"
        private val AD_UNIT_ID: String = Const.ADMOB_SPLASH

        //    private static final long DURATION = 0;
        private const val DURATION = (5 * 60 * 1000).toLong()
    }

    /**
     * Constructor.
     */
    init {
        this.app = app
        this.app.registerActivityLifecycleCallbacks(this)
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
    }
}