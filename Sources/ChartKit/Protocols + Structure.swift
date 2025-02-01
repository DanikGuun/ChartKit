
import UIKit

@MainActor
public protocol Chart {
    var delegate: ChartDelegate? { get set }
    
    func addElement(_ element: ChartElement)
    func getElement(with id: UUID) -> ChartElement?
    func getAllElements() -> [ChartElement]
    func replaceElement(with id: UUID, newElement: ChartElement)
    func removeElement(with id: UUID)
    func removeAllElements()
    func reloadData()
}

@MainActor
public protocol ChartDelegate {
    func chartDidPressed(_ chart: Chart)
}

public extension ChartDelegate {
    func chartDidPressed(_ chart: Chart){}
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

