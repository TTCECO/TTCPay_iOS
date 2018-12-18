// Copyright SIX DAY LLC. All rights reserved.

import Foundation

enum EthereumUnit: Int64 {
    case wei = 1
    case kwei = 1_000
    case bawei = 100_000_000
    case gwei = 1_000_000_000
    case ether = 1_000_000_000_000_000_000
}

extension EthereumUnit {
    var name: String {
        switch self {
        case .wei: return "Wei"
        case .kwei: return "Kwei"
        case .bawei: return "Bawei"
        case .gwei: return "Gwei"
        case .ether: return "Ether"
        }
    }
}

//https://github.com/ethereumjs/ethereumjs-units/blob/master/units.json
