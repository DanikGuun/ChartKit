
import UIKit

class SlicePathBuilder {
    
    var startAngle: CGFloat = 0
    var endAngle: CGFloat = 0
    
    var center: CGPoint = .zero
    var inset: CGFloat = 0
    var radius: CGFloat = 0
    
    var innerCornerRadius: CGFloat = 0
    var outerCornerRadius: CGFloat = 0
    
    func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: getLeftDownPointBeforeCorner())
        path.addQuadCurve(to: getLeftDownPointAfterCorner(), controlPoint: getLeftDownControlPoint())
        
        path.addLine(to: getLeftUpPointBeforeCorner())
        path.addQuadCurve(to: getLeftUpPointAfterCorner(), controlPoint: getLeftUpControlPoint())
        
        path.addArc(withCenter: center, radius: radius, startAngle: getOuterArcStartAngle(), endAngle: getOuterArcEndAngle(), clockwise: true)
        path.addQuadCurve(to: getRightUpPointAfterCorner(), controlPoint: getRightUpControlPoint())
        
        path.addLine(to: getRightDownPointBeforeCorner())
        path.addQuadCurve(to: getRightDownPointAfterCorner(), controlPoint: getRightDownControlPoint())
        
        path.addArc(withCenter: center, radius: getInset(), startAngle: getInnerArcStartAngle(), endAngle: getInnerArcEndAngle(), clockwise: false)
        
        return path
    }
    
    //MARK: Left Down Corner
    private func getLeftDownPointBeforeCorner() -> CGPoint {
        let angle = startAngle + getInnerCornerRadius() / getOuterLengthPerDegree()
        let radius = getInset()
        return point(angle: angle, radius: radius)
    }
    
    private func getLeftDownPointAfterCorner() -> CGPoint {
        let angle = startAngle
        let radius = getInset() + getInnerCornerRadius()
        return point(angle: angle, radius: radius)
    }
    
    private func getLeftDownControlPoint() -> CGPoint {
        let angle = startAngle
        let radius = getInset()
        return point(angle: angle, radius: radius)
    }
    
    //MARK: Left Up Corner
    private func getLeftUpPointBeforeCorner() -> CGPoint {
        let angle = startAngle
        let radius = radius - getOuterCornerRadius()
        return point(angle: angle, radius: radius)
    }
    
    private func getLeftUpPointAfterCorner() -> CGPoint {
        let angle = startAngle + getOuterCornerRadius() / getOuterLengthPerDegree()
        let radius = radius
        return point(angle: angle, radius: radius)
    }
    
    private func getLeftUpControlPoint() -> CGPoint {
        let angle = startAngle
        let radius = radius
        return point(angle: angle, radius: radius)
    }
    
    //MARK: Outer Arc
    private func getOuterArcStartAngle() -> CGFloat {
        return (startAngle + getOuterCornerRadius() / getOuterLengthPerDegree()).toRadian()
    }
    
    private func getOuterArcEndAngle() -> CGFloat {
        return (endAngle - getOuterCornerRadius() / getOuterLengthPerDegree()).toRadian()
    }
    
    //MARK: Right Up Corner
    private func getRightUpPointAfterCorner() -> CGPoint {
        let angle = endAngle
        let radius = radius - getOuterCornerRadius()
        return point(angle: angle, radius: radius)
    }
    
    private func getRightUpControlPoint() -> CGPoint {
        let angle = endAngle
        let radius = radius
        return point(angle: angle, radius: radius)
    }
    
    //MARK: Right Down Corner
    private func getRightDownPointBeforeCorner() -> CGPoint {
        let angle = endAngle
        let radius = getInset() + getInnerCornerRadius()
        return point(angle: angle, radius: radius)
    }
    
    private func getRightDownControlPoint() -> CGPoint {
        let angle = endAngle
        let radius = getInset()
        return point(angle: angle, radius: radius)
    }
    
    private func getRightDownPointAfterCorner() -> CGPoint {
        let angle = endAngle - getInnerCornerRadius() / getOuterLengthPerDegree()
        let radius = getInset()
        return point(angle: angle, radius: radius)
    }
    
    //MARK: Inner Arc
    private func getInnerArcStartAngle() -> CGFloat {
        return (endAngle - getInnerCornerRadius() / getOuterLengthPerDegree()).toRadian()
    }
    
    private func getInnerArcEndAngle() -> CGFloat {
        return (startAngle + getInnerCornerRadius() / getOuterLengthPerDegree()).toRadian()
    }
    
    //MARK: Outer Corner Radius
    private func getOuterCornerRadius() -> CGFloat {
        var possibleValues = [outerCornerRadius]
        possibleValues.append(getOuterCornerRadiusConsiderArcLength())
        possibleValues.append(getOuterCornerRadiusConsiderSliceHeight())
        return possibleValues.min()!.rounded(.down)
    }
    
    private func getOuterCornerRadiusConsiderArcLength() -> CGFloat {
        if outerCornerRadius * 2 > getOuterArcLength() {
            return getOuterArcLength()/2
        }
        return outerCornerRadius
    }
    
    private func getOuterCornerRadiusConsiderSliceHeight() -> CGFloat {
        if outerCornerRadius + innerCornerRadius > getSliceHeight() {
            let percent = outerCornerRadius / (outerCornerRadius + innerCornerRadius)
            return getSliceHeight() * percent
        }
        return outerCornerRadius
    }
    
    //MARK: Inner Corner Radius
    private func getInnerCornerRadius() -> CGFloat {
        var possibleValues = [innerCornerRadius]
        possibleValues.append(getInnerCornerRadiusConsiderArcLength())
        possibleValues.append(getInnerCornerRadiusConsiderSliceHeight())
        return possibleValues.min()!.rounded(.down)
    }
    
    private func getInnerCornerRadiusConsiderArcLength() -> CGFloat {
        if innerCornerRadius * 2 > getInnerArcLength() {
            return getInnerArcLength()/2
        }
        return innerCornerRadius
    }
    
    private func getInnerCornerRadiusConsiderSliceHeight() -> CGFloat {
        if outerCornerRadius + innerCornerRadius > getSliceHeight() {
            let percent = innerCornerRadius / (outerCornerRadius + innerCornerRadius)
            return getSliceHeight()*percent
        }
        return innerCornerRadius
    }
    
    
    //MARK: Dimensions
    private func getInset() -> CGFloat {
        return min(inset, radius)
    }
    
    private func getSliceHeight() -> CGFloat {
        return radius - getInset()
    }
    
    private func getOuterArcLength() -> CGFloat {
        return ((endAngle - startAngle) * getOuterLengthPerDegree()).rounded(.down)
    }
    
    private func getInnerArcLength() -> CGFloat {
        return ((endAngle - startAngle) * getInnerLengthPerDegree()).rounded(.down)
    }
    
    private func getOuterLengthPerDegree() -> CGFloat {
        return 2 * radius * .pi / 360
    }
    private func getInnerLengthPerDegree() -> CGFloat {
        return 2 * inset * .pi / 360
    }
    
    private func point(angle: CGFloat, radius: CGFloat) -> CGPoint {
        let angle = angle.isNaN ? 0 : angle
        let x = center.x + radius * cos(angle.toRadian())
        let y = center.y + radius * sin(angle.toRadian())
        return CGPoint(x: x, y: y)
    }
    
}
