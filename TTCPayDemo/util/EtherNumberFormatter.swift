// Copyright SIX DAY LLC. All rights reserved.

import BigInt
import Foundation

final class EtherNumberFormatter {
    /// Formatter that preserves full precision.
    
    static let shared = EtherNumberFormatter()
    
    func full() -> EtherNumberFormatter {
        return self
    }
    
    // Formatter that caps the number of decimal digits to 4.
    func short() -> EtherNumberFormatter {
        self.maximumFractionDigits = 6
        return self
    }
    
    func shortFour() -> EtherNumberFormatter {
        self.maximumFractionDigits = 4
        return self
    }
    
    func normal() -> EtherNumberFormatter {
        self.maximumFractionDigits = 2
        return self
    }
    
    func onlyInt() -> EtherNumberFormatter {
        self.maximumFractionDigits = 0
        return self
    }

    /// Minimum number of digits after the decimal point.
    var minimumFractionDigits = 0

    /// Maximum number of digits after the decimal point.
    var maximumFractionDigits = Int.max

    /// 当前系统的符号
    var currentDecimalSeparator = "."
    
    /// Decimal point.
    var decimalSeparator = "."

    /// Thousands separator.
    var groupingSeparator = ","

    var local: Locale {
        get {
            return Locale(identifier: "en_US")
        }
    }
    
    /// Initializes a `EtherNumberFormatter` with a `Locale`.
    init(locale: Locale = .current) {
        let local = self.local
        decimalSeparator = local.decimalSeparator ?? "."
        groupingSeparator = local.groupingSeparator ?? ","
        currentDecimalSeparator = Locale.current.decimalSeparator ?? "."
        
    }

    /// Converts a string to a `BigInt`.
    ///
    /// - Parameters:
    ///   - string: string to convert
    ///   - units: units to use
    /// - Returns: `BigInt` represenation.
    func number(from string: String, units: EthereumUnit = .ether) -> BigInt? {
        let decimals = Int(log10(Double(units.rawValue)))
        return number(from: string, decimals: decimals)
    }

    /// Converts a string to a `BigInt`.
    ///
    /// - Parameters:
    ///   - string: string to convert
    ///   - decimals: decimal places used for scaling values.
    /// - Returns: `BigInt` represenation.
    func number(from string: String, decimals: Int) -> BigInt? {
        guard let index = string.index(where: { String($0) == currentDecimalSeparator }) else {
            // No fractional part
            return BigInt(string).flatMap({ $0 * BigInt(10).power(decimals) })
        }

        let fractionalDigits = string.distance(from: string.index(after: index), to: string.endIndex)
        if fractionalDigits > decimals {
            // Can't represent number accurately
            return nil
        }

        var fullString = string
        fullString.remove(at: index)

        guard let number = BigInt(fullString) else {
            return nil
        }

        if fractionalDigits < decimals {
            return number * BigInt(10).power(decimals - fractionalDigits)
        } else {
            return number
        }
    }

    /// Formats a `BigInt` for displaying to the user.
    ///
    /// - Parameters:
    ///   - number: number to format
    ///   - units: units to use
    /// - Returns: string representation
    func string(from number: BigInt, units: EthereumUnit = .ether) -> String {
        let decimals = Int(log10(Double(units.rawValue)))
        return string(from: number, decimals: decimals)
    }

    /// Formats a `BigInt` for displaying to the user.
    ///
    /// - Parameters:
    ///   - number: number to format
    ///   - decimals: decimal places used for scaling values.
    /// - Returns: string representation
    func string(from number: BigInt, decimals: Int) -> String {
        precondition(minimumFractionDigits >= 0)
        precondition(maximumFractionDigits >= 0)

        let dividend = BigInt(10).power(decimals)
        let (integerPart, remainder) = number.quotientAndRemainder(dividingBy: dividend)
        let integerString = self.integerString(from: integerPart)
        let fractionalString = self.fractionalString(from: BigInt(sign: .plus, magnitude: remainder.magnitude), decimals: decimals)
        if fractionalString.isEmpty || fractionalString == "0" {
            return integerString
        }
        return "\(integerString)\(decimalSeparator)\(fractionalString)"
    }
    
    //10^18 单位转到10进制 正常单位的字符串 不带，号
    func bigIntToNumberString(from number: BigInt, units: EthereumUnit = .ether) -> String {
        let decimals = Int(log10(Double(units.rawValue)))
        let number = stringToNumber(from: number, decimals: decimals)
        let numbers = number.components(separatedBy: ".")
        if numbers.count == 1 {
            return number
        }
        return "\(numbers[0])\(decimalSeparator)\(numbers[1])"
    }
    
    //10^18 单位转到10进制 正常单位的float
    func bigIntToNormal(from number: BigInt) -> Float {
        let decimals = Int(log10(Double(EthereumUnit.ether.rawValue)))
        let string: String = self.stringToNumber(from: number, decimals: decimals)
        return Float(string)!
    }
    
    //10^18 单位转到10 正常单位的字符串 不带，号
    fileprivate func stringToNumber(from number: BigInt, decimals: Int) -> String {
        precondition(minimumFractionDigits >= 0)
        precondition(maximumFractionDigits >= 0)
        
        let dividend = BigInt(10).power(decimals)
        let (integerPart, remainder) = number.quotientAndRemainder(dividingBy: dividend)
        let fractionalString = self.fractionalString(from: BigInt(sign: .plus, magnitude: remainder.magnitude), decimals: decimals)
        if fractionalString.isEmpty || fractionalString == "0" {
            return "\(integerPart)"
        }
        return "\(integerPart).\(fractionalString)"
    }
    
    /// Formats a `BigInt` to a Decimal.
    ///
    /// - Parameters:
    ///   - number: number to format
    ///   - decimals: decimal places used for scaling values.
    /// - Returns: Decimal representation
    func decimal(from number: BigInt, decimals: Int) -> Decimal? {
        precondition(minimumFractionDigits >= 0)
        precondition(maximumFractionDigits >= 0)
        let dividend = BigInt(10).power(decimals)
        let (integerPart, remainder) = number.quotientAndRemainder(dividingBy: dividend)
        let integerString = integerPart.description
        let fractionalString = self.fractionalString(from: BigInt(sign: .plus, magnitude: remainder.magnitude), decimals: decimals)
        if fractionalString.isEmpty {
            return Decimal(string: integerString)
        }
        return Decimal(string: "\(integerString)\(decimalSeparator)\(fractionalString)")
    }
    
    private func integerString(from: BigInt) -> String {
        var string = from.description
        let end = from.sign == .minus ? 1 : 0
        for offset in stride(from: string.count - 3, to: end, by: -3) {
            let index = string.index(string.startIndex, offsetBy: offset)
            string.insert(contentsOf: groupingSeparator, at: index)
        }
        return string
    }

    private func fractionalString(from number: BigInt, decimals: Int) -> String {
        var number = number
        let digits = number.description.count

        if number == 0 || decimals - digits > maximumFractionDigits {
            // Value is smaller than can be represented with `maximumFractionDigits`
            return String(repeating: "0", count: minimumFractionDigits)
        }

        if decimals < minimumFractionDigits {
            number *= BigInt(10).power(minimumFractionDigits - decimals)
        }
        if decimals > maximumFractionDigits {
            number /= BigInt(10).power(decimals - maximumFractionDigits)
        }

        var string = number.description
        if digits < decimals {
            // Pad with zeros at the left if necessary
            if string == "0" {
                string = String(repeating: "0", count: decimals - digits)
            } else {
                string = String(repeating: "0", count: decimals - digits) + string
            }
            
        }

        // Remove extra zeros after the decimal point.
        if let lastNonZeroIndex = string.reversed().index(where: { $0 != "0" })?.base {
            let numberOfZeros = string.distance(from: string.startIndex, to: lastNonZeroIndex)
            if numberOfZeros > minimumFractionDigits {
                let newEndIndex = string.index(string.startIndex, offsetBy: numberOfZeros - minimumFractionDigits)
                string = String(string[string.startIndex..<newEndIndex])
            }
        }

        return string
    }
}
