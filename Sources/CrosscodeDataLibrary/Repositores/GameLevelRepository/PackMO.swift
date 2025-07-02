extension PackMO {
    
    public func toPack() -> Pack {
        return Pack(id: self.id!, number: Int(self.number))
    }
}
