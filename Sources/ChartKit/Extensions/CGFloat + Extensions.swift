import Foundation

extension CGFloat {
    
    func toRadian() -> CGFloat {
        return self / 180 * CGFloat.pi
    }
    
    func toDegree() -> CGFloat {
        return self * 180 / CGFloat.pi
    }
    
}
