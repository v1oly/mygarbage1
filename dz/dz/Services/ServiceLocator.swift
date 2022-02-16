import Foundation

private protocol ServiceLocating {
    func getService<T>() -> T!
}

final class ServiceLocator: ServiceLocating {
    static let shared = ServiceLocator()
    
    private lazy var services = [String: Any]()
    
    private func typeName(some: Any) -> String {
        return (some is Any.Type) ?
        "\(some)" : "\(type(of: some))"
    }
    
    func addService<T>(service: T) {
        let key = typeName(some: T.self)
        print("add \(key)")
        services[key] = service
    }
 
    func getService<T>() -> T! {
        let key = typeName(some: T.self)
        print("get \(key)")
        return services[key] as? T
    }
    
    func getServicesInfo() {
        print(services)
    }
}

class ServiceLocatorInitialization {
    static func registerServicesToServiceLocator() {
        let serviceLocator = ServiceLocator.shared
        serviceLocator.addService(service: FeedDataProvider())
        serviceLocator.addService(service: AlgoProvider())
        serviceLocator.addService(service: StringGenerator())
        serviceLocator.addService(service: AccountsListService())
        serviceLocator.addService(service: ParsingService())
    }
}
