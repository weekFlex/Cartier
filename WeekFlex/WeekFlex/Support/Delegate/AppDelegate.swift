//
//  AppDelegate.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/03.
//

import AuthenticationServices
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let emotionMascot = [("empty","선택안함"),("good","꽤 괜찮았어요"),("merong","열심히 놀았어요"),("yaho","뿌듯해요"),("sad","후회해요"),
                         ("angry","화가 났어요"),("bad","아쉬웠어요"),("kiki-disable","최고였어요"),("pissed-disable","아찔했어요"),
                         ("crazy-disable","정신 없었어요"),("iku-disable","미래의 나에게!"),("sowhat-disable","눈막귀막"),("vomit-disable","너무 힘들었어요")]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: "") { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    break // The Apple ID credential is valid.
                case .revoked, .notFound:
                    print("revoked or notfound")
                    break
                default:
                    break
                }
            }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

