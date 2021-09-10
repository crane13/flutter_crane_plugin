//
//  FirebaseUtils.swift
//  Runner
//
//  Created by crane on 2021/6/19.
//

import Foundation
import Firebase
public class FireBaseUtils{
    
    static let sharedInstance = FireBaseUtils()
    
    func initFirebase()  {
        FirebaseApp.configure()
    }
    
    func logEvent(event : String)  {
//        firebaseAnalytic
//        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//          AnalyticsParameterItemID: "id-\(title!)",
//          AnalyticsParameterItemName: title!,
//          AnalyticsParameterContentType: "cont"
//          ])
     
   
//
    }
    
}
