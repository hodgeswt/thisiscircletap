//
//  IntExtension.swift
//  this is circle tap
//
//  Created by Will Hodges on 11/29/21.
//

import Foundation

extension Int {
    var toAlpha: String {
        
        let sub20: [Int: String] = [
            0: "",
            1: "one",
            2: "two",
            3: "three",
            4: "four",
            5: "five",
            6: "six",
            7: "seven",
            8: "eight",
            9: "nine",
            10: "ten",
            11: "eleven",
            12: "twelve",
            13: "thirteen",
            14: "fourteen",
            15: "fifteen",
            16: "sixteen",
            17: "seventeen",
            18: "eighteen",
            19: "nineteen"
        ]
        
        
        let tens: [Int: String] = [
            0: "",
            2: "twenty",
            3: "thirty",
            4: "fourty",
            5: "fifty",
            6: "sixty",
            7: "seventy",
            8: "eighty",
            9: "ninety"
        ]
        
        let pows: [Int: String] = [
            100: "hundred",
            1000: "thousand",
            1000000: "million",
            1000000000: "billion",
            1000000000000: "trillion"
        ]
        
        if self < 20 {
            return sub20[self]!
        }
        
        var p = 10
        var sub = 0
        
        var digits = [Int]()
        
        while (p / 10) < self {
            let digit = ((self - sub) % p) / (p / 10)
            sub += digit * (p / 10)
            digits.append(digit)
            p *= 10
        }
        
        
        p = { () -> Int in
            var a = 1
            for _ in 1...(digits.count - 1) {
                a *= 10
            }
            return a
        }()
        
        var ret = ""
        digits = digits.reversed()
        
        if digits[digits.count - 2] < 2 {
            digits[digits.count - 1] += (digits[digits.count - 2] * 10)
            digits[digits.count - 2] = 0
        }
        
        for digit in digits {
            var modifier = ""
            if p >= 100 {
                modifier = sub20[digit]! + " " + pows[p]!
            } else if p >= 10 {
                modifier = tens[digit]!
            } else {
                modifier = sub20[digit]!
            }
            ret += modifier + " "
            p /= 10
        }
        
        return ret
    }
}
