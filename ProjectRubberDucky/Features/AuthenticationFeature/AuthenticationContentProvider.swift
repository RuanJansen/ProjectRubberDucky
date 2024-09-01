//
//  AuthenticationContentProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Foundation

protocol AuthenticationContentProvidable {
    func fetchLoginPageTitle() async -> String

    func fetchLoginSectionHeader1() async -> String
    func fetchLoginTextFieldDefault1() async -> String

    func fetchLoginSectionHeader2() async -> String
    func fetchLoginTextFieldDefault2() async -> String

    func fetchLoginPrimaryAction() async -> String
    func fetchLoginSecondaryAction() async -> String

    func fetchRegisterPageTitle() async -> String

    func fetchRegisterSectionHeader1() async -> String
    func fetchRegistrerTextFieldDefault1() async -> String

    func fetchRegisterSectionHeader2() async -> String
    func fetchRegistrerTextFieldDefault2() async -> String

    func fetchRegisterSectionHeader3() async -> String
    func fetchRegistrerTextFieldDefault3() async -> String

    func fetchRegisterSectionHeader4() async -> String
    func fetchRegistrerTextFieldDefault4() async -> String

    func fetchRegisterPrimaryAction() async -> String
}

class AuthenticationContentProvider: AuthenticationContentProvidable {
    var contentFetcher: ContentFetcher

    init(contentFetcher: ContentFetcher) {
        self.contentFetcher = contentFetcher
    }

    func fetchLoginPageTitle() async -> String {
        await fetch(content: "pageTitle", for: "loginContent") ?? "-"
    }
    
    func fetchLoginSectionHeader1() async -> String {
        await fetch(content: "sectionHeader1", for: "loginContent") ?? "-"
    }

    func fetchLoginTextFieldDefault1() async -> String {
        await fetch(content: "textFieldDefault1", for: "loginContent") ?? "-"
    }

    func fetchLoginSectionHeader2() async -> String {
        await fetch(content: "sectionHeader2", for: "loginContent") ?? "-"
    }

    func fetchLoginTextFieldDefault2() async -> String {
        await fetch(content: "textFieldDefault2", for: "loginContent") ?? "-"
    }

    func fetchLoginPrimaryAction() async -> String {
        await fetch(content: "primaryAction", for: "loginContent") ?? "-"
    }
    
    func fetchLoginSecondaryAction() async -> String {
        await fetch(content: "secondaryAction", for: "loginContent") ?? "-"
    }
    

    func fetchRegisterPageTitle() async -> String {
        await fetch(content: "pageTitle", for: "registerContent") ?? "-"
    }

    func fetchRegisterSectionHeader1() async -> String {
        await fetch(content: "sectionHeader1", for: "registerContent") ?? "-"
    }

    func fetchRegistrerTextFieldDefault1() async -> String {
        await fetch(content: "textFieldDefault1", for: "registerContent") ?? "-"
    }

    func fetchRegisterSectionHeader2() async -> String {
        await fetch(content: "sectionHeader2", for: "registerContent") ?? "-"
    }

    func fetchRegistrerTextFieldDefault2() async -> String {
        await fetch(content: "textFieldDefault2", for: "registerContent") ?? "-"
    }

    func fetchRegisterSectionHeader3() async -> String {
        await fetch(content: "sectionHeader3", for: "registerContent") ?? "-"

    }

    func fetchRegistrerTextFieldDefault3() async -> String {
        await fetch(content: "textFieldDefault3", for: "registerContent") ?? "-"
    }

    func fetchRegisterSectionHeader4() async -> String {
        await fetch(content: "sectionHeader4", for: "registerContent") ?? "-"

    }

    func fetchRegistrerTextFieldDefault4() async -> String {
        await fetch(content: "textFieldDefault4", for: "registerContent") ?? "-"
    }

    func fetchRegisterPrimaryAction() async -> String {
        await fetch(content: "primaryAction", for: "registerContent") ?? "-"
    }

}

extension AuthenticationContentProvider: ContentProvidable {
    func fetch(content id: String, for table: String) async -> String? {
        do {
            return try await contentFetcher.fetch(content: id, from: table)
        } catch {
            return nil
        }
    }
}
