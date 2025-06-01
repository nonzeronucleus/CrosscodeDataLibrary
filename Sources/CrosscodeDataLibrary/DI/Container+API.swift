import Factory

public extension Container {
    var layoutsAPI: Factory<LayoutsAPI> {
        Factory(self) {
            LayoutsAPIImpl()
        }.singleton
    }
    
    var playableLevelsAPI: Factory<LevelsAPI> {
        Factory(self) {
            PlayableLevelsAPIImpl()
        }.singleton
    }

}
