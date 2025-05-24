import Factory
import Foundation

extension Container {
    
    public var uuid: Factory<UUIDGenerator> {
        self { RandomUUIDProvider() }
            .singleton
    }
    
    
    var useEmulator: Factory<Bool> {
        Factory(self) {
            let value =  UserDefaults.standard.bool(forKey: "useEmulator")
            print("Using the emulator: \(value == true ? "YES" : "NO")")
            return value
        }.singleton
    }
    
    
    
}
