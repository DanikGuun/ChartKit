
import UIKit

open class PieChart: UIView, Chart {
    
    public var elements: [ChartElement] = [] { didSet { updateLayers() } }
    public var spaceBetweenSlices: CGFloat = 0 { didSet { updateLayers() } }
    public var outerCornerRadius: CGFloat = 0 { didSet { updateLayers() } }
    public var innerCornerRadius: CGFloat = 0 { didSet { updateLayers() } }
    public var inset: CGFloat = 0 { didSet { updateLayers() } }
    
    
    private var currentStartAngle: CGFloat = 0
    private var radius: CGFloat {
        return (min(self.frame.width, self.frame.height) - spaceBetweenSlices) / 2
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
        
        let maskLayer = CAShapeLayer()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = min(self.frame.width, self.frame.height) / 2
        maskLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath
        
        //self.layer.mask = maskLayer
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
        let midAngle = (currentStartAngle + getEndAngle(for: value)) / 2
        
        let builder = SlicePathBuilder()
        builder.startAngle = currentStartAngle
        builder.endAngle = getEndAngle(for: value)
        builder.center = getCenterOfSlice(midAngle: midAngle)
        builder.innerCornerRadius = innerCornerRadius
        builder.outerCornerRadius = outerCornerRadius
        builder.inset = inset
        builder.radius = radius
        return builder.createPath()
    }
    
    private func getCenterOfSlice(midAngle: CGFloat) -> CGPoint {
        let centerX = self.bounds.midX + cos(midAngle.toRadian()) * (spaceBetweenSlices / 2)
        let centerY = self.bounds.midY + sin(midAngle.toRadian()) * (spaceBetweenSlices / 2)
        return CGPoint(x: centerX, y: centerY)
    }

    private func getEndAngle(for value: CGFloat) -> CGFloat {
        let angleOffset: CGFloat = 360 * value / valuesSum()
        return currentStartAngle + angleOffset
    }
    
    private func setCurrnetAngle(for value: CGFloat){
        let angleOffset: CGFloat = 360 * value / valuesSum()
        currentStartAngle += angleOffset
    }
    
    private func valuesSum() -> CGFloat {
        return elements.reduce(0, { $0 + $1.value } ) 
    }
    
    
}
