package cn.crane.crane_plugin.gcenter;

import android.app.Activity;
import android.content.Intent;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.games.Games;
import com.google.android.gms.tasks.OnCanceledListener;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;

import androidx.annotation.NonNull;

import cn.crane.crane_plugin.R;

public class GameCenterHelper {

    private static final String LEADERBOARD_ID = "Score Rank";

    private static final int RC_LEADERBOARD_UI = 9004;
    private static final int RC_SIGN_IN = 1000;

//    private FirebaseAnalytics mFirebaseAnalytics;
    protected static GameCenterHelper instance;
    
    private String rankId = "score_rank";
    private int score = 0;

    public static GameCenterHelper getInstance() {
        if (instance == null) {
            instance = new GameCenterHelper();
        }
        return instance;
    }

    public void init(Activity activity)
    {
//        mFirebaseAnalytics = FirebaseAnalytics.getInstance(activity);
    }

//    public void sigin()
//    {
////        GoogleSignInAccount.createDefault();
//
//
//    }

    public void signIn(Activity activity) {
        GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_GAMES_SIGN_IN)
                .requestIdToken(activity.getString(R.string.server_client_id))
//                .requestScopes(Games.SCOPE_GAMES_LITE, Games.SCOPE_GAMES)
//                .requestScopes(Drive.SCOPE_APPFOLDER)
                .requestEmail()
                .build();
        GoogleSignInClient mGoogleSignInClient = GoogleSignIn.getClient(activity, gso);


//        mGoogleSignInClient.silentSignIn().addOnCompleteListener(activity,
//                new OnCompleteListener<GoogleSignInAccount>() {
//                    @Override
//                    public void onComplete(@NonNull Task<GoogleSignInAccount> task) {
//                        // Handle UI updates based on being signed in or not.
////                        enableUIButtons(task.isSuccessful());
//                        // It is OK to cache the account for later use.
//                        handleSignInResult(activity, task);
//                    }
//                });

        Intent signInIntent = mGoogleSignInClient.getSignInIntent();
        activity.startActivityForResult(signInIntent, RC_SIGN_IN);
    }

    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);

        // Result returned from launching the Intent from GoogleSignInClient.getSignInIntent(...);
        if (requestCode == RC_SIGN_IN) {
            // The Task returned from this call is always completed, no need to attach
            // a listener.
            Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
            handleSignInResult(activity, task);
        }
    }

    private void handleSignInResult(final Activity activity, Task<GoogleSignInAccount> completedTask) {
        try {
            GoogleSignInAccount account = completedTask.getResult(ApiException.class);

            if(account != null)
            {
                if(score > 0)
                {
                    reportScore(activity, rankId, score);
                }
                Games.getLeaderboardsClient(activity, account)
                        .getLeaderboardIntent(rankId)
                        .addOnCompleteListener(new OnCompleteListener<Intent>() {
                            @Override
                            public void onComplete(@NonNull Task<Intent> task) {

                            }
                        })
                        .addOnCanceledListener(new OnCanceledListener() {
                            @Override
                            public void onCanceled() {

                            }
                        })
                        .addOnSuccessListener(new OnSuccessListener<Intent>() {
                            @Override
                            public void onSuccess(Intent intent) {
                                activity.startActivityForResult(intent, RC_LEADERBOARD_UI);
                            }
                        });
            }
            // Signed in successfully, show authenticated UI.
//            updateUI(account);
        } catch (ApiException e) {
            e.printStackTrace();
            // The ApiException status code indicates the detailed failure reason.
            // Please refer to the GoogleSignInStatusCodes class reference for more information.
//            Log.w(TAG, "signInResult:failed code=" + e.getStatusCode());
//            updateUI(null);
        }
    }


    public void reportScore(Activity activity, String rankId, int score) {
        if(hasSignin(activity))
        {
            Games.getLeaderboardsClient(activity, GoogleSignIn.getLastSignedInAccount(activity))
                    .submitScore(rankId, score);
            this.score = 0;
        }
//        else {
//            signIn(activity);
//        }

    }

    public boolean hasSignin(Activity activity)
    {
        return GoogleSignIn.getLastSignedInAccount(activity) != null;
    }

    public void showLeaderboard(final Activity activity, String rankId, int score) {
        if (activity == null)
        {
            return;
        }
        if(hasSignin(activity))
        {

            Games.getLeaderboardsClient(activity, GoogleSignIn.getLastSignedInAccount(activity))
                    .getLeaderboardIntent(rankId)
                    .addOnSuccessListener(new OnSuccessListener<Intent>() {
                        @Override
                        public void onSuccess(Intent intent) {
                            activity.startActivityForResult(intent, RC_LEADERBOARD_UI);
                        }
                    });
        }else {
            this.score = score;
            this.rankId = rankId;
            signIn(activity);
        }

    }
}
