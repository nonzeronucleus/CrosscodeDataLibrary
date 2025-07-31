
public protocol Level: Identifiable, Sendable, Encodable, Equatable where ID == UUID {
    static func getApi() -> APIType
    var number: Int? { get }
    var gridText: String? { get }
    var letterMapStr: String? { get }
    var name: String { get }
}
