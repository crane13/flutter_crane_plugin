package lib_u.src.main.java.cn.crane.lib_a.track;

import android.content.Context;

import com.google.firebase.analytics.FirebaseAnalytics;

public class FireBaseAUtils {
    private static FirebaseAnalytics mFirebaseAnalytics;

    public static void init(Context context) {
        mFirebaseAnalytics = FirebaseAnalytics.getInstance(context);
    }
}
