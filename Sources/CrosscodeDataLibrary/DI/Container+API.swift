import Factory

public extension Container {
    var layoutsAPI: Factory<LayoutsAPI> {
        Factory(self) {
            LayoutsAPIImpl()
        }.singleton
    }
}
