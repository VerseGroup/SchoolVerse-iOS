//
//  App+Injection.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/18/22.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { FirebaseAuthenticationManager() }
            .scope(.application)
        register { TaskRepository() }
            .scope(.application)
        register { APIService() }
            .scope(.application)
    }
}
