//
//  TTCSign.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/14.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit
import SwiftyRSA
import TTCPay

let TTCPrivateKey_dev = "MIICXgIBAAKBgQCze4k/GOz+AjN053HzLQ9K9bMestBUoBF4Z7uVLxMhj+bo+keCI7X+LI9cPjI0IWmOQM+gY5/qgBnb5Eq4q9NARPh/YtyNQGiuLVtkdl+3lBTHGYY7enaBXG/psC5tFu+/R9GcnTQL8qF1PzKp7Mum19LXZK/hNTQA0ehA+h8JkQIDAQABAoGBAKsvOWD3+hnuqXtnwBQqtvpMy7GM5QzBusf3UD9ircGGCbvN8mQagVtSzs0w+RslfxLRl/Ym7wBve7pxzB7Eq295BJm6kM9iuZ6hY1uVAI1kVxugpHO5i+106NRnVGnXAE2ydfVpw/gsSM/cJl+L8RnlE3fyqagioPMorbFE0zMNAkEA3OyhnGzUTiudfvNI75pK8m0uZriAQ72/OiLhflDMSatBIgpC8Bgl0ikojCh5iPnjnVQCCVf+QeRabOVdxAtZLwJBAM/6hdGQ3iwqdSlH+VoONnjzfbfSAnfOLZGjE/spjwvD0f4R213jKeUMOt8jvxbuXuIGsuV5qczSJacbEV2pmT8CQQDGhVDYKqdAs0qsiFtzC3frjpbSsVp5BOnwiOWOR3a7gEtgFk5+R4S87EVGZRyJLNwPRS0rTkno1hU3o4h1oSj7AkAq7wOa/HXw1h7zk6kU/yQdmd5VCSR7SPO9QdYJHk4qVpVOBq+rVQ67+udYUw/KkxDBRjK+DnyQDL27HmpaVH2PAkEAxIYQAh4zalwTbttZA9wkvGkD9nrWpGNotgysquNCK4taYGxjG6CaybKjFz9U3drquJOtub553BO10jhD0+ZTxA=="

let TTCPrivateKey = "MIICWwIBAAKBgQC+xSGWeOUNgNmpns7XzHV6/AYqePDXG3YX2HrppnnwzOlGT4NxHJhLt06I8YjadHUGitdDNdiGZywOmU9d2uaHJRLqUoelrha0XFJLoSpjrxI8J2RhSZ0H6Z5lkBnZIDdbImHcw6H9U6VZKR0fv6o3fKSGb4etqQ06qorxmCZLVQIDAQABAoGARA/lGeBsKFMuVTwZpBiIWaaNNJ4Nn1Fm4r8Tq0UAAI+7MqCvzq1bELiHxogWQYqHLhxfDNWrONiaeWLtVBkDYdpdP6PUOxK9mK/BFQ0Vo3PWPHNyLtOORwtplUKSkIwBULRLiOyyiLMxgH0+kldkIqCC1dmTrar3t0r/iq9g1wkCQQDmjJW7hg2SlnvomegtseAAdihe1nyiyMm+hBc7CPnCu9wgeMMXjxuRT7N8RMibFM2rotZNh9fL27vR5bBbOwNDAkEA09RfOFiajJ1Iy2CSay+ieapqsmMrNQ+kscN57Ym1+SaonctDUWziypDRHGvo+oORIv7b/QUqKT+/acr3Gx1xhwJAZ/zRLJvyU0P875U73CB24L5qxxwHa4UVOhFqSP5raSJCz4KovF+YF5rTYiHEOe7QNbJk5uN2ukSKGsp3GS8s8QJAQa6LK+yFV255oN476FJn3bPSy6dmQVitZ5VGHDpkG3I6PFtHb1sE42yN+nMXVX4wJZrC2aydSxcCIiqV/mldxwJAehcSwqTn4pCy2Qy+xA0JMXQqThKglDioUZJ7pqoZ2cSoje6GTh/vowKNIDXFhL6yff7qFKwikuRwJeGmXy5BnQ=="

class TTCSign: NSObject {

    static func signOrder(order: TTCCreateOrder) -> String {
        
        var orderArray: [String] = []
        orderArray.append("outTradeNo=\(order.outTradeNo)")
        orderArray.append("description=\(order.description_p)")
        orderArray.append("totalFee=\(order.totalFee)")
        orderArray.append("partnerAddress=\(order.partnerAddress)")
        orderArray.append("createTime=\(order.createTime)")
        orderArray.append("expireTime=\(order.expireTime)")
        orderArray.append("payType=\(order.payType)")
        orderArray.append("sellerDefinedPage=\(order.sellerDefinedPage)")
        orderArray.append("appId=\(order.appId)")
        
        let orderSortArray = orderArray.sorted()
        let resultString = orderSortArray.joined(separator: "&")
        
        let signString = TTCSign.sign(text: resultString)
        
        return signString
    }
    
    static func sign(text: String) -> String {
        do {
            if let data = Data(base64Encoded: TTCPrivateKey) {
                
                let preSignText = try ClearMessage(string: text, using: .utf8)
                let sign = try preSignText.signed(with: PrivateKey(data: data), digestType: .sha1)
                return sign.base64String
            } else {
                return ""
            }
        } catch let error {
            print(error.localizedDescription)
            return ""
        }
    }
}
