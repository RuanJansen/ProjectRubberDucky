//
//  FirebaseRemoteConfig.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/11.
//

import Foundation
import FirebaseRemoteConfig

protocol ContentFetchable {
    func fetchContent(forKey table: String) -> Data
}

protocol FeatureFlagFetchable {
    func fetchFeatureFlag(forKey key: String) -> Bool
}

class FirebaseRemoteConfig {
    private var remoteConfig: RemoteConfig!

    let welcomeMessageConfigKey = "welcome_message"
    let welcomeMessageCapsConfigKey = "welcome_message_caps"

    init() {
        remoteConfigSetup()
        fetchConfigs()
        listenForConfigUpdates()
    }

    private func remoteConfigSetup() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings

        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }

    private func fetchConfigs() {
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate { changed, error in
                    // ...
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }

    private func listenForConfigUpdates() {
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard let configUpdate, error == nil else {
                print("Error listening for config updates: ", String(describing: error))
                return
            }

            print("Updated keys: \(configUpdate.updatedKeys)")

            self.remoteConfig.activate { changed, error in
                guard error == nil else { return print(error!) }
            }
        }
    }
}

extension FirebaseRemoteConfig: ContentFetchable {
    public func fetchContent(forKey table: String) -> Data {
        let value = remoteConfig.configValue(forKey: table)
        return value.dataValue
    }
}

extension FirebaseRemoteConfig: FeatureFlagFetchable {
    public func fetchFeatureFlag(forKey key: String) -> Bool {
        let value = remoteConfig.configValue(forKey: key)
        return value.boolValue
    }
}
