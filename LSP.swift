import Foundation

public class NotSOLIDRectangle {
    
    internal var myHeight: Double = 0
    internal var myWidth: Double = 0
    
    public func setHeight(value: Double) {
        myHeight = value
    }
    
    public func setWidth(value: Double) {
        myWidth = value
    }
    
    public func height() -> Double {
        return myHeight
    }
    
    public func width() -> Double {
        return myWidth
    }
    
    public func area() -> Double {
        return self.height() * self.width()
    }
    
    public init() { }
    
}



public class NotSOLIDSquare: NotSOLIDRectangle {
    
    public override func setHeight(value: Double) {
        myHeight = value
        myWidth = value
    }
    
    public override func setWidth(value: Double) {
        myWidth = value
        myHeight = value
    }
    
    public override init() { }
}


// MARK: SOLID

public protocol SOLIDShape {
    func area() -> Double
}

public struct SOLIDRectangle: SOLIDShape {
    
    public let width: Double
    public let height: Double
    
    
    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    // MARK: - Protocol conformance
    
    // MARK: SOLIDShape
    
    public func area() -> Double {
        return width * height
    }
    
}


public struct SOLIDSquare: SOLIDShape {
    
    public let side: Double
    
    
    public init(side: Double) {
        self.side = side
    }
    // MARK: - Protocol conformance
    
    // MARK: SOLIDShape
 
    public func area() -> Double {
        return side * 2
    }
}

