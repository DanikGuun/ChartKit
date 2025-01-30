
import UIKit

open class PieChart: UIView, Chart {
    
    public var elements: [ChartElement] = [] { didSet { updateLayers() } }
    public var spaceBetweenSlices: CGFloat = 0 { didSet { updateLayers() } }
    public var outerCornerRadius: CGFloat = 0 { didSet { updateLayers() } }
    public var innerCornerRadius: CGFloat = 0 { didSet { updateLayers() } }
    public var inset: CGFloat = 0 { didSet { updateLayers() } }
    
    private var currentStartAngle: CGFloat = 0
    
    //
    //MARK: - Lifecycle
    //
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateLayers()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //
    //MARK: - Layers
    //
    private func updateLayers(){
        self.layer.sublayers?.removeAll()
        currentStartAngle = 0
        for element in elements {
            createElementLayer(for: element)
            setCurrnetAngle(after: element.value)
        }
    }
    
    private func createElementLayer(for element: ChartElement){
        let path = createPath(value: element.value)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = element.color.cgColor
        self.layer.addSublayer(layer)
    }
    
    private func createPath(value: CGFloat) -> UIBezierPath{
        let builder = SlicePathBuilder()
        builder.center = getCenter()
        builder.startAngle = currentStartAngle
        builder.endAngle = getEndAngle(for: value)
        builder.innerCornerRadius = getInnerRadius()
        builder.outerCornerRadius = getOuterRadius()
        builder.inset = inset
        builder.radius = getRadius()
        return builder.createPath()
    }
    
    
    //
    //MARK: - Calculating
    //
    private func getCenter() -> CGPoint {
        let x = self.bounds.midX
        let y = self.bounds.midY
        return CGPoint(x: x, y: y)
    }
    
    private func getEndAngle(for value: CGFloat) -> CGFloat {
        let angleOffset: CGFloat = getAvailableAngle() * value / valuesSum()
        return currentStartAngle + angleOffset
    }
    
    private func getInnerRadius() -> CGFloat {
        return elements.count > 1 ? innerCornerRadius : 0
    }
    
    private func getOuterRadius() -> CGFloat {
        return elements.count > 1 ? outerCornerRadius : 0
    }
    
    private func setCurrnetAngle(after value: CGFloat){
        let endAngle = getEndAngle(for: value)
        currentStartAngle = endAngle + getSpaceBetweenSlices()
    }
    
    private func getRadius() -> CGFloat {
        return (min(self.frame.width, self.frame.height)) / 2
    }
    
    //MARK: Helpers
    private func getAvailableAngle() -> CGFloat {
        if elements.count > 1 {
            return 360 - getSpaceBetweenSlices() * CGFloat(elements.count)
        }
        return 360
    }
    
    private func getSpaceBetweenSlices() -> CGFloat {
        return spaceBetweenSlices.clamped(to: 0.0 ... CGFloat(360/elements.count))
    }
    
    
    private func valuesSum() -> CGFloat {
        return elements.reduce(0, { $0 + $1.value } ) 
    }
    
}
