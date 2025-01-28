//
//  AccountContentProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/15.
//

import Foundation

protocol AccountContentProvidable {
    func fetchPageTitle() async -> String
    func fetchSectionHeader1() async -> String
    func fetchSectionHeader2() async -> String
    func fetchDeleteText() async -> String
    func fetchAccountAlertTitle() async -> String
    func fetchAccountAlertMessage() async -> String
    func fetchAccountAlertPrimaryActionText() async -> String
    func fetchAccountAlertSecondaryActionText() async -> String
}

class AccountContentProvider: AccountContentProvidable {
    var contentFetcher: ContentFetcher

    init(contentFetcher: ContentFetcher) {
        self.contentFetcher = contentFetcher
    }

    func fetchPageTitle() async -> String {
        await fetch(content: "pageTitle", for: "accountContent") ?? "-"
    }

    func fetchSectionHeader1() async -> String {
        await fetch(content: "sectionHeader1", for: "accountContent") ?? "-"
    }

    func fetchSectionHeader2() async -> String {
        await fetch(content: "sectionHeader2", for: "accountContent") ?? "-"
    }

    func fetchDeleteText() async -> String {
        await fetch(content: "deleteText", for: "accountContent") ?? "-"
    }

    func fetchAccountAlertTitle() async -> String {
        await fetch(content: "deleteAccountAlertTitle", for: "accountContent") ?? "-"
    }

    func fetchAccountAlertMessage() async -> String {
        await fetch(content: "deleteAccountAlertMessage", for: "accountContent") ?? "-"
    }

    func fetchAccountAlertPrimaryActionText() async -> String {
        await fetch(content: "deleteAccountAlertPrimaryActionText", for: "accountContent") ?? "-"
    }

    func fetchAccountAlertSecondaryActionText() async -> String {
        await fetch(content: "deleteAccountAlertSecondaryActionText", for: "accountContent") ?? "-"
    }
}

extension AccountContentProvider: ContentProvidable {
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
