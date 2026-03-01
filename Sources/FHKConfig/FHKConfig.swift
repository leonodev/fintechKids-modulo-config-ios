// The Swift Programming Language
// https://docs.swift.org/swift-book

import FHKDomain

public class FHKConfiguration: FHKConfigurationProtocol {
    public var environmentType: EnvironmentType = .production
    
    public init() {}
    
    public func setEnvironment(_ environmentType: EnvironmentType) {
        self.environmentType = environmentType
    }

    public func getEnvironment() -> EnvironmentType {
        self.environmentType
    }
}
