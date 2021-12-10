//
//  AppDelegate.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 02.12.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let model = Model(serverAgent: ServerAgent(baseURL: "https://api.themoviedb.org/3", apiKey: "c1f618b7255f013ad044c579d688e1c2"),
                      remoteImageAgent: RemoteImageAgent(baseURL: "http://image.tmdb.org/t/p/w780"),
                      loacalAgent: LocalAgent(rootFolderName: "cache"))
}

