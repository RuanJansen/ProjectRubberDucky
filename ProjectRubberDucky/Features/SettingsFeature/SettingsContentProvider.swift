//
//  SettingsContentProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/15.
//

import Foundation

protocol SettingsContentProvidable {
    func fetchPageTitle() async -> String
    func fetchLogoutText() async -> String
    func fetchLogoutAlertTitle() async -> String
    func fetchLogoutAlertMessage() async -> String
    func fetchLogoutAlertPrimaryActionText() async -> String
    func fetchLogoutAlertSecondaryActionText() async -> String
}

class SettingsContentProvider: SettingsContentProvidable {
    var contentFetcher: ContentFetcher

    init(contentFetcher: ContentFetcher) {
        self.contentFetcher = contentFetcher
    }

    func fetchPageTitle() async -> String {
        await fetch(content: "pageTitle", for: "settingsContent") ?? "-"
    }

    func fetchLogoutText() async -> String {
        await fetch(content: "logoutText", for: "settingsContent") ?? "-"
    }

    func fetchLogoutAlertTitle() async -> String {
        await fetch(content: "logoutAlertTitle", for: "settingsContent") ?? "-"
    }

    func fetchLogoutAlertMessage() async -> String {
        await fetch(content: "logoutAlertMessage", for: "settingsContent") ?? "-"
    }

    func fetchLogoutAlertPrimaryActionText() async -> String {
        await fetch(content: "logoutAlertPrimaryActionText", for: "settingsContent") ?? "-"
    }

    func fetchLogoutAlertSecondaryActionText() async -> String {
        await fetch(content: "logoutAlertSecondaryActionText", for: "settingsContent") ?? "-"
    }
}

extension SettingsContentProvider: ContentProvidable {
    func fetchAll(from table: String) async -> [String]? {
        do {
            return try await contentFetcher.fetchAll(from: table)
        } catch {
            return nil
        }
    }

    func fetch(content id: String, for table: String) async -> String? {
        do {
            return try await contentFetcher.fetch(content: id, from: table)
        } catch {
            return nil
        }
    }
}
