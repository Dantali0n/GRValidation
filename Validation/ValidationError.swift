//
// GRValidation
// https://github.com/groue/GRValidation
// Copyright (c) 2015 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


/**
A Validation Error
*/
public struct ValidationError : ErrorType {
    
    public init(value: Any?, message: String) {
        self.init(.Value(value: value, message: message))
    }
    
    public var owner: Any? {
        switch type {
        case .Owned(let owner, _):
            return owner
        default:
            return nil
        }
    }
    
    
    // not public
    
    enum CompoundMode {
        case And
        case Or
    }
    
    indirect enum Type {
        /// Error on a value
        case Value(value: Any?, message: String)
        
        /// Error on a named value
        case Named(name: String, error: ValidationError)
        
        /// Compound errors
        case Compound(mode: CompoundMode, errors: [ValidationError])
        
        /// Error with custom description
        case Global(description: String, error: ValidationError)
        
        /// Owned error
        case Owned(owner: Any, error: ValidationError)
    }
    
    let type: Type
    
    init(_ type: Type) {
        self.type = type
    }
}

extension ValidationError : CustomStringConvertible {
    public var description: String {
        return description(nil)
    }
    
    private func description(valueDescription: String?) -> String {
        switch type {
        case .Value(let value, let message):
            if let valueDescription = valueDescription {
                return "\(valueDescription) \(message)"
            } else if let value = value {
                return "\(String(reflecting: value)) \(message)"
            } else {
                return "nil \(message)"
            }
        case .Named(let name, let error):
            return error.description(name)
        case .Compound(let mode, let errors):
            switch mode {
            case .Or:
                return errors.last!.description(valueDescription)
            case .And:
                // Avoid duplicated descriptions
                var found = Set<String>()
                var uniq = [String]()
                for error in errors {
                    let description = error.description(valueDescription)
                    if !found.contains(description) {
                        uniq.append(description)
                        found.insert(description)
                    }
                }
                return " ".join(uniq)
            }
        case .Global(let description, _):
            return description
        case .Owned(let owner, let error):
            return "\(owner.dynamicType) validation error: \(error.description(valueDescription))"
        }
    }
}
