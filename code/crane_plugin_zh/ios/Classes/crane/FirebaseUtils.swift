//
//  FirebaseUtils.swift
//  Runner
//
//  Created by crane on 2021/6/19.
//

import Foundation
import FirebaseAnalytics
import FirebaseCore
open class FireBaseUtils{

    static public let sharedInstance = FireBaseUtils()

    public func initFirebase()  {
        FirebaseApp.configure()
    }

    public func logEvent(event : String)  {
//        firebaseAnalytic
//        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//          AnalyticsParameterItemID: "id-\(title!)",
//          AnalyticsParameterItemName: title!,
//          AnalyticsParameterContentType: "cont"
//          ])
//
    }

}
