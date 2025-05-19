import Factory
import Foundation

extension Container {
    
    var uuid: Factory<UUIDGenerator> {
        self { RandomUUIDProvider() }
            .singleton
    }
    

//    public var uuid: Factory<UUID> {
//        Factory(self) {
//          @Injected(\.uuidProvider) var uuidProvider
//            return uuidProvider.uuid()
//        }.singleton
//    }

    
    
    var useEmulator: Factory<Bool> {
        Factory(self) {
            let value =  UserDefaults.standard.bool(forKey: "useEmulator")
            print("Using the emulator: \(value == true ? "YES" : "NO")")
            return value
        }.singleton
    }
    
    
    
}
