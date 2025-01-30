import Foundation
import CoreGraphics


extension CGFloat {
    
    func toRadian() -> CGFloat {
        return self / 180 * CGFloat.pi
    }
    
    func toDegree() -> CGFloat {
        return self * 180 / CGFloat.pi
    }
    
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat.minimum(CGFloat.maximum(self, range.lowerBound), range.upperBound)
    }

    
}
