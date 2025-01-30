
import UIKit

open class PieChart: UIView, Chart {
    
    public var elements: [ChartElement] = [] { didSet { updateLayers() } }
    public var spaceBetweenSlices: CGFloat = 0 { didSet { updateLayers() } }
    public var outerCornerRadius: CGFloat = 0 { didSet { updateLayers() } }
    public var innerCornerRadius: CGFloat = 0 { didSet { updateLayers() } }
    public var inset: CGFloat = 0 { didSet { updateLayers() } }
    
    private var currentStartAngle: CGFloat = 0
    private var radius: CGFloat {
        return (min(self.frame.width, self.frame.height)) / 2
    }
    
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
        }
    }
    
    private func createElementLayer(for element: ChartElement){
        let path = createPath(value: element.value)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = element.color.cgColor
        self.layer.addSublayer(layer)
        setCurrnetAngle(for: element.value)
    }
    
    private func createPath(value: CGFloat) -> UIBezierPath{
        
        let builder = SlicePathBuilder()
        builder.startAngle = currentStartAngle
        builder.endAngle = getEndAngle(for: value)
        builder.center = getCenterOfSlice()
        builder.innerCornerRadius = getInnerRadius()
        builder.outerCornerRadius = getOuterRadius()
        builder.inset = inset
        builder.radius = radius
        return builder.createPath()
    }
    
    private func getCenterOfSlice() -> CGPoint {
        let centerX = self.bounds.midX
        let centerY = self.bounds.midY
        return CGPoint(x: centerX, y: centerY)
    }
    
    private func getSpaceBetweenSlices() -> CGFloat {
        return spaceBetweenSlices.clamped(to: 0.0 ... CGFloat(360/elements.count))
    }

    private func getEndAngle(for value: CGFloat) -> CGFloat {
        let angleOffset: CGFloat = getAvailableAngle() * value / valuesSum()
        return currentStartAngle + angleOffset
    }
    
    private func setCurrnetAngle(for value: CGFloat){
        let endAngle = getEndAngle(for: value)
        currentStartAngle = endAngle + getSpaceBetweenSlices()
    }
    
    private func getAvailableAngle() -> CGFloat {
        if elements.count > 1 {
            return 360 - getSpaceBetweenSlices() * CGFloat(elements.count)
        }
        return 360
    }
    
    private func getInnerRadius() -> CGFloat {
        return elements.count > 1 ? innerCornerRadius : 0
    }
    
    private func getOuterRadius() -> CGFloat {
        return elements.count > 1 ? outerCornerRadius : 0
    }
    
    private func valuesSum() -> CGFloat {
        return elements.reduce(0, { $0 + $1.value } ) 
    }
    
    
    
}
