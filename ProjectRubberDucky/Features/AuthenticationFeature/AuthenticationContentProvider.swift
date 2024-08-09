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
    func fetchLoginSectionHeader2() async -> String
    func fetchLoginPrimaryAction() async -> String
    func fetchLoginSecondaryAction() async -> String
    func fetchRegisterPageTitle() async -> String
    func fetchRegisterSectionHeader1() async -> String
    func fetchRegisterSectionHeader2() async -> String
    func fetchRegisterPrimaryAction() async -> String
}

class AuthenticationContentProvider: AuthenticationContentProvidable {
    func fetchLoginPageTitle() async -> String {
        await fetch(content: "pageTitle", for: "LoginContent") ?? "Login"
    }
    
    func fetchLoginSectionHeader1() async -> String {
        await fetch(content: "sectionHeader1", for: "LoginContent") ?? "Email"
    }
    
    func fetchLoginSectionHeader2() async -> String {
        await fetch(content: "sectionHeader2", for: "LoginContent") ?? "Password"
    }
    
    func fetchLoginPrimaryAction() async -> String {
        await fetch(content: "primaryAction", for: "LoginContent") ?? "Sign in with Email"
    }
    
    func fetchLoginSecondaryAction() async -> String {
        await fetch(content: "secondaryAction", for: "LoginContent") ?? "Not a member yet?"
    }
    

    func fetchRegisterPageTitle() async -> String {
        await fetch(content: "pageTitle", for: "Register") ?? "Register"
    }

    func fetchRegisterSectionHeader1() async -> String {
        await fetch(content: "sectionHeader1", for: "Register") ?? "Email"
    }

    func fetchRegisterSectionHeader2() async -> String {
        await fetch(content: "sectionHeader2", for: "Register") ?? "Password"
    }

    func fetchRegisterPrimaryAction() async -> String {
        await fetch(content: "primaryAction", for: "Register") ?? "Register"
    }

}

extension AuthenticationContentProvider: ContentProvidable {
    func fetch(content id: String, for table: String) async -> String? {
        do {
            return try await ContentFetcher.fetch(content: id, for: table)
        } catch {
            return nil
        }
    }
}
