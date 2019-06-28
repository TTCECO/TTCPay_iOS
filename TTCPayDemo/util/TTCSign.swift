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

let TTCPrivateKey_dev = "MIICXAIBAAKBgQDm+UWKrZ1+gO3+8UMz4ELR+vsKxRxfH61hBlhIdsTqpCeyxrgyKOfadEITa2qNK5uCXR6Z/8TxMKnqhojE0FgnG9n36J2yz3aAJlG9cQ6kY+1D8dQJoAcTBHIjIOj+6EYcCsfd7P8ChkKjRTF5737azFopmeiyy28BfEs4/byHEwIDAQABAoGAWg+EUCiWKod3RVspiwa8x0eHr5FgGK8vWY+xyL+W1K8hU5IsrFJK5WFDinLt3xHL1y8cCYwzbKA/ANVoauWaGRgeBvQygrp8XIjL1/dm8O6dgNI2kr5QxZ0uFs6M8J+K7gnsw7TItpb0BnzxTDtCsOXoo8LtZr/R3jt/9Or4brECQQD1AfDjojg/jvNc6Qd/dbOAx5C6fsmpbqhIwbqX2AGhm6v44d7P4Q19tnmbmK0Ojg/X9tsejNHqQPO0UadxTCSXAkEA8VYksMbBOBiHGt8iyW+p2BVBkyTflMjTGea/AR/niDphb2DcanjJYNcK+ki0Y5stZ9Hommculkd1fmu6wNwU5QJAC6+6A8GbGT0CUq4y01uT4lKijqK5j8FdeYr0EYYWHdVFEKwFarj7YcGwb0GLD6SrEMwPi5d/88KBXVp/uCG/pQJAPZPvVLPCBWAsyOx6Yc9+FMaHrtXPvpTnWEqKHe1YFGhhCBw84WXkbDMyd94pOOkVUtI6eXsuZeXh0toGEsOVCQJBAOJEjU1JwVa0Pil0+/yiQM3us2N7YR0yk/LPUOK8l91RJK9SxU01N8G36DKWBQMyK5dW0WshEwezziFnlCBOuJ8="

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
