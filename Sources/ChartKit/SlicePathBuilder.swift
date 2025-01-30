
import UIKit

class SlicePathBuilder {
    
    var startAngle: CGFloat = 0
    var endAngle: CGFloat = 0
    private var midAngle: CGFloat {
        return (startAngle + endAngle) / 2
    }
    
    var center: CGPoint = .zero
    var inset: CGFloat = 0
    var radius: CGFloat = 0
    
    var innerCornerRadius: CGFloat = 0
    var outerCornerRadius: CGFloat = 0
    
    private var outerLengthPerDegree: CGFloat {
        return 2 * radius * .pi / 360
    }
    private var innerLengthPerDegree: CGFloat {
        return 2 * inset * .pi / 360
    }
    
    func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: getLeftDownPointBeforeCorner())
        path.addQuadCurve(to: getLeftDownPointAfterCorner(), controlPoint: getLeftDownControlPoint())
        
        path.addLine(to: getLeftUpPointBeforeCorner())
        path.addQuadCurve(to: getLeftUpPointAfterCorner(), controlPoint: getLeftUpControlPoint())
        
        path.addArc(withCenter: center, radius: radius, startAngle: getOuterStartAngle(), endAngle: getOuterEndAngle(), clockwise: true)
        path.addQuadCurve(to: getRightUpPointAfterCorner(), controlPoint: getRightUpControlPoint())
        
        path.addLine(to: getRightDownPointBeforeCorner())
        path.addQuadCurve(to: getRightDownPointAfterCorner(), controlPoint: getRightDownControlPoint())
        
        path.addArc(withCenter: center, radius: getInset(), startAngle: getInnerStartAngle(), endAngle: getInnerEndAngle(), clockwise: false)
        
        return path
    }
    
    private func getLeftDownPointBeforeCorner() -> CGPoint {
        let angle = startAngle + getInnerCornerRadius() / outerLengthPerDegree
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
    
    private func getLeftUpPointBeforeCorner() -> CGPoint {
        let angle = startAngle
        let radius = radius - getOuterCornerRadius()
        return point(angle: angle, radius: radius)
    }
    
    private func getLeftUpPointAfterCorner() -> CGPoint {
        let angle = startAngle + getOuterCornerRadius() / outerLengthPerDegree
        let radius = radius
        return point(angle: angle, radius: radius)
    }
    
    private func getLeftUpControlPoint() -> CGPoint {
        let angle = startAngle
        let radius = radius
        return point(angle: angle, radius: radius)
    }
    
    private func getOuterStartAngle() -> CGFloat {
        return (startAngle + getOuterCornerRadius() / outerLengthPerDegree).toRadian()
    }
    
    private func getOuterEndAngle() -> CGFloat {
        return (endAngle - getOuterCornerRadius() / outerLengthPerDegree).toRadian()
    }
    
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
        let angle = endAngle - getInnerCornerRadius() / outerLengthPerDegree
        let radius = getInset()
        return point(angle: angle, radius: radius)
    }
    
    private func getInnerStartAngle() -> CGFloat {
        return (endAngle - getInnerCornerRadius() / outerLengthPerDegree).toRadian()
    }
    
    private func getInnerEndAngle() -> CGFloat {
        return (startAngle + getInnerCornerRadius() / outerLengthPerDegree).toRadian()
    }
    
    private func getOuterCornerRadius() -> CGFloat {
        var possibleValues = [outerCornerRadius]
        if outerCornerRadius * 2 > getOuterLength() {
            possibleValues.append(getOuterLength()/2)
        }
        if outerCornerRadius + innerCornerRadius > getSliceHeight() {
            let percent = outerCornerRadius / (outerCornerRadius + innerCornerRadius)
            possibleValues.append(getSliceHeight()*percent)
        }
        return possibleValues.min()!.rounded(.down)
    }
    
    private func getInnerCornerRadius() -> CGFloat {
        var possibleValues = [innerCornerRadius]
        if innerCornerRadius * 2 > getInnerLength() {
            possibleValues.append(getInnerLength()/2)
        }
        if outerCornerRadius + innerCornerRadius > getSliceHeight() {
            let percent = innerCornerRadius / (outerCornerRadius + innerCornerRadius)
            possibleValues.append(getSliceHeight()*percent)
        }
        return possibleValues.min()!.rounded(.down)
    }
    
    private func getInset() -> CGFloat {
        return min(inset, radius)
    }
    
    private func getSliceHeight() -> CGFloat {
        return radius - getInset()
    }
    
    private func getOuterLength() -> CGFloat {
        return ((endAngle - startAngle) * outerLengthPerDegree).rounded(.down)
    }
    
    private func getInnerLength() -> CGFloat {
        return ((endAngle - startAngle) * innerLengthPerDegree).rounded(.down)
    }
    
    private func point(angle: CGFloat, radius: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle.toRadian())
        let y = center.y + radius * sin(angle.toRadian())
        return CGPoint(x: x, y: y)
    }
    
}
