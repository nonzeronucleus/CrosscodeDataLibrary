import Factory

public extension Container {
    var layoutsAPI: Factory<LevelsAPI> {
        Factory(self) {
            LayoutsAPIImpl()
        }.singleton
    }
    
    var gameLevelsAPI: Factory<LevelsAPI> {
        Factory(self) {
            GameLevelsAPIImpl()
        }.singleton
    }

}
