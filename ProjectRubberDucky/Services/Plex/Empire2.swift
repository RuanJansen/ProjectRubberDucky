//
//  Empire2.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/06.
//

import Foundation

struct PlexAuthentication {
    static let ruan = (username: "darthjansen@gmail.com",
                       password: "Ruan0209")
    static let rikus = (username: "rikus102@gmail.com",
                        password: "Acid3471")
    static let primaryToken = "-szo-akRdn4CDHkY3VpJ"
}

enum Empire2: String {
    /// Base URL
    case base = "https://172-29-6-20.6ff3f28836a64e218c04da392a2c3365.plex.direct:32400"

    /// Libraries
    case tvActive = "01 - TV Active"
    case tvEnded = "02 - TV Ended"
    case tvAnimated = "03 - TV Animated"
    case tvDocu = "04 - TV Docu"
    case moviesNew = "05 - Movies New"
    case moviesOld = "06 - Movies Old"
    case moviesDocu = "07 - Movies Docu"
    case comedy = "08 - Comedy"
    case musicFlac = "09 - Music FLAC"
    case musicMp4 = "10 - Music MP4"
    case musicDvd = "11 - Music DVD"
    case musicBlyray = "12 - Music Blu-Ray"
    case musicMp3 = "14 - Music MP3"
    case ruanTest = "15 - Ruan Test"
}
