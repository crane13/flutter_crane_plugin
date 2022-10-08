//
//  AppOpen.swift
//  Runner
//
//  Created by ruifeng yu on 2022/9/30.
//

import Foundation
import GoogleMobileAds


protocol AppOpenAdManagerDelegate: AnyObject {
  /// Method to be invoked when an app open ad is complete (i.e. dismissed or fails to show).
  func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager)
}

class AppOpenAdManager: NSObject {
  /// Ad references in the app open beta will time out after four hours,
  /// but this time limit may change in future beta versions. For details, see:
  /// https://support.google.com/admanager/answer/9351867?hl=en
  let timeoutInterval: TimeInterval = 4 * 3_600
  /// The app open ad.
  var appOpenAd: GADAppOpenAd?
  /// Maintains a reference to the delegate.
  weak var appOpenAdManagerDelegate: AppOpenAdManagerDelegate?
  /// Keeps track of if an app open ad is loading.
  var isLoadingAd = false
  /// Keeps track of if an app open ad is showing.
  var isShowingAd = false
  /// Keeps track of the time when an app open ad was loaded to discard expired ad.
  var loadTime: Date?
    
    var isFirst: Bool = true
    
    var startLoadTime: Int = 0
    
    

  static let shared = AppOpenAdManager()

  private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
    // Check if ad was loaded more than n hours ago.
    if let loadTime = loadTime {
      return Date().timeIntervalSince(loadTime) < timeoutInterval
    }
    return false
  }

  private func isAdAvailable() -> Bool {
    // Check if ad exists and can be shown.
    return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
  }

  private func appOpenAdManagerAdDidComplete() {
    // The app open ad is considered to be complete when it dismisses or fails to show,
    // call the delegate's appOpenAdManagerAdDidComplete method if the delegate is not nil.
    appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
  }

  func loadAd() {
    // Do not load ad if there is an unused ad or one is already loading.
    if isLoadingAd || isAdAvailable() {
      return
    }
    isLoadingAd = true
    print("Start loading app open ad.")
      self.startLoadTime = Int(Date().timeIntervalSince1970)
    GADAppOpenAd.load(
        withAdUnitID: Const.ADMOB_SPLASH,
      request: GADRequest(),
      orientation: UIInterfaceOrientation.portrait
    ) { ad, error in
      self.isLoadingAd = false
      if let error = error {
        self.appOpenAd = nil
        self.loadTime = nil
        print("App open ad failed to load with error: \(error.localizedDescription).")
        return
      }

      self.appOpenAd = ad
      self.appOpenAd?.fullScreenContentDelegate = self
      self.loadTime = Date()
        if(self.isFirst){
            self.isFirst = false;
            let duration = Int(Date().timeIntervalSince1970) - self.startLoadTime
            print("duration: \(duration).")
            if(duration > 0 && duration < 5){
                self.showFirst();
            }
            

        }
      print("App open ad loaded successfully.")
    }
  }
    
    func showFirst() {
        let rootViewController = UIApplication.shared.windows.first(
            where: { $0.isKeyWindow })?.rootViewController
        if let rootViewController = rootViewController {
            // Do not show app open ad if the current view controller is SplashViewController.
            
            showAdIfAvailable(viewController: rootViewController)
        }
        
    }

  func showAdIfAvailable(viewController: UIViewController) {
    // If the app open ad is already showing, do not show the ad again.
    if isShowingAd {
      print("App open ad is already showing.")
      return
    }
    // If the app open ad is not available yet but it is supposed to show,
    // it is considered to be complete in this example. Call the appOpenAdManagerAdDidComplete
    // method and load a new ad.
    if !isAdAvailable() {
      print("App open ad is not ready yet.")
      appOpenAdManagerAdDidComplete()
      loadAd()
      return
    }
    if let ad = appOpenAd {
      print("App open ad will be displayed.")
      isShowingAd = true
      ad.present(fromRootViewController: viewController)
    }
  }
}

extension AppOpenAdManager: GADFullScreenContentDelegate {
  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("App open ad is will be presented.")
  }

  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    appOpenAd = nil
    isShowingAd = false
    print("App open ad was dismissed.")
    appOpenAdManagerAdDidComplete()
    loadAd()
  }

  func ad(
    _ ad: GADFullScreenPresentingAd,
    didFailToPresentFullScreenContentWithError error: Error
  ) {
    appOpenAd = nil
    isShowingAd = false
    print("App open ad failed to present with error: \(error.localizedDescription).")
    appOpenAdManagerAdDidComplete()
    loadAd()
  }
}
