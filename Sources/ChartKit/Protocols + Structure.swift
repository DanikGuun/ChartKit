
import UIKit

protocol Chart {
    
}

public struct ChartElement: Identifiable {
    public let id = UUID()
    public var value: Double
    public var color: UIColor
    
    public init(value: Double, color: UIColor) {
        self.value = value
        self.color = color
    }
    public init() {
        self.value = 0
        self.color = .systemBlue
    }
}

