//
//  CommonsInjection.swift
//  FHKConfig
//
//  Created by Fredy Leon on 22/2/26.
//

import FHKInjections
import FHKDomain

public extension DependenciesInjection {
    var storageManager: any FHKStorageManagerProtocol {
        get { self[(any FHKStorageManagerProtocol).self] }
        set { self[(any FHKStorageManagerProtocol).self] = newValue }
    }
}
