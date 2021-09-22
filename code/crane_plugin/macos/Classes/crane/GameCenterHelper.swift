//
//  GameCenterHelper.swift
//  Runner
//
//  Created by crane on 2019/10/11.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import GameKit

public class GameCenterHelper: NSObject ,GKGameCenterControllerDelegate {

    static public let helper = GameCenterHelper()


    var viewController: NSViewController?


    override init() {
        super.init()
    }


    public func authenticateLocalPlayer(controller:NSViewController)  {
        print("authenticateLocalPlayer")
        self.viewController = controller
        GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
            if GKLocalPlayer.local.isAuthenticated {
                print("Authenticated to Game Center!")
            } else if let vc = gcAuthVC {
                self.viewController?.presentAsModalWindow(vc)
            }
            else {
                self.openSettings();
                print("Error authentication to GameCenter: " +
                    "\(error?.localizedDescription ?? "none")")
            }
        }
    }
    func reportScore(rankId: String, score:Int) {
        //check if user is alredy logged in game center
        if GKLocalPlayer.local.isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: rankId)
            scoreReporter.value = Int64(score)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: {(error : Error?) -> Void in
                if error != nil {
                    print("error:%@", error)
                }
            })
        }
    }
    //    func reportScore(score:Int) {
    //        //check if user is alredy logged in game center
    //        if GKLocalPlayer.localPlayer().isAuthenticated {
    //            let scoreReporter = GKScore(leaderboardIdentifier: "score")
    //            scoreReporter.value = Int64(score)
    //            let scoreArray: [GKScore] = [scoreReporter]
    //            GKScore.report(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
    //                if error != nil {
    //                    print("error:%@", error)
    //                }
    //        }
    //        }
    //    }

    func showLeader()  {

        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        self.viewController?.presentAsModalWindow(gc)
    }

    func openSettings()
    {


    }

    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(gameCenterViewController)


    }
}
