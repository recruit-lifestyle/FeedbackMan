import Foundation

enum Result<V, E> {
    
    case success(V)
    case failure(E)
    
    init(value: V) {
        self = .success(value)
    }
    
    init(error: E) {
        self = .failure(error)
    }
}
