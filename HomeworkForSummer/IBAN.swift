//
//  IBAN.swift
//  HomeworkForSummer
//
//  Created by Samuli Tamminen on 17.2.2016.
//  Copyright © 2016 Samuli Tamminen. All rights reserved.
//

import Foundation



struct IBAN {
    
    static func isValid(myIban: String) -> Bool {
        
        if myIban.characters.count < 5 {
            log("IBAN is way too short!")
            return false
        }
        
        // Remove all but A-Z and 0-9
        let stripped = stripIllegal(myIban.uppercaseString)
        
        // Two first chars are the country code (eg. "FI")
        let countryCode = substring(stripped, start: 0, end: 2)
        
        if countryCode.rangeOfString("[^A-Z]", options: .RegularExpressionSearch) != nil {
            log("countryCode contains illegal chars! Only A-Z allowed")
            return false
        }
        
        // Following two are the check digits
        let checkDigits = substring(stripped, start: 2, end: 4)
        
        // And the rest is the actual account number. Format depends on country.
        let bban = substring(stripped, start: 4, end: stripped.characters.count)
        
        // Reorder the numbers
        var numberedIban = bban + countryCode + checkDigits
        
        // Convert A-Z to numbers 10-35
        numberedIban = charsToNumbers(numberedIban)
        
        // Calculate mod97 to check validity
        let modulo = modulo97(numberedIban)
        
        // mod97 returns 1 if IBAN is valid
        if modulo == 1 {
            return true
        } else {
            log("Checksum mismatch")
            return false
        }
    }
    
    
    
    // Remove all illegal characters
    static private func stripIllegal(str: String) -> String {
        
        // mutable copy
        var str = str
        
        if let match = str.rangeOfString("[^A-Z|0-9]", options: .RegularExpressionSearch) {
            str.replaceRange(match, with: "")
            str = stripIllegal(str)
        }
        
        return str
    }
    
    
    
    // Helper to get substring with Int range
    static private func substring(string: String, start: Int, end: Int) -> String {
        let range = string.startIndex.advancedBy(start) ..< string.startIndex.advancedBy(end)
        return string.substringWithRange(range)
    }
    
    
    
    // Convert a character A-Z to number 10-35
    static func charToNumber(char: String) -> String {
        let scalars = char.unicodeScalars
        // First character of the passed string
        return String(scalars[scalars.startIndex].value - 55)
    }
    
    
    
    // Convert all characters to corresponding numbers
    // Expects the string to contain only A-Z or 0-9
    static func charsToNumbers(str: String) -> String {
        
        // mutable copy
        var str = str
        
        // Check if string contains A-Z
        if let match = str.rangeOfString("[^0-9]", options: .RegularExpressionSearch) {
            let char = str.substringWithRange(match)
            let num = charToNumber(char)
            
            // Replace the first found char with number
            str.replaceRange(match, with: num)
            
            // Check again
            str = charsToNumbers(str)
        }
        
        // Only numbers found
        return str
    }
    
    
    
    // Calculate modulo 97 of a long number
    // If mod97 == 1, IBAN checksum is valid
    static func modulo97(longNumber: String) -> Int {
        
        var numbersLeft = longNumber.characters.count
        
        // Take 9 digits (or the rest) from the long number and calculate modulo 97 of it
        var endOfN: Int
        if numbersLeft >= 9 {
            endOfN = 9
        } else {
            endOfN = numbersLeft
        }
        
        let N = Int(substring(longNumber, start: 0, end: endOfN))!
        let mod = N % 97
        
        // Combine calculated modulo and remaining longNumber
        let longNumber = String(mod) + substring(longNumber, start: endOfN, end: numbersLeft)
        
        // Return if remainder < 97
        numbersLeft = longNumber.characters.count
        if numbersLeft < 3 {
            let remainder = Int(longNumber)!
            if remainder < 97 {
                return remainder
            }
        }
        
        // Else repeat
        return modulo97(longNumber)
        
    }
    
    
    static private func log(msg: String) {
        print("IBAN: " + msg)
    }
    
}




// Test cases
//IBAN.isValid("")     // too short
//IBAN.isValid("3423") // too short
//IBAN.isValid("234234234234234234") // illegal country code
//IBAN.isValid("fi42 3242 3242 2332 32") // not valid checksum
//IBAN.isValid("FI42 5000 1510 0000 23") // OK
//IBAN.isValid("FI42 5000 xxxx 0000 23") // illegal chars
//
//IBAN.isValid("GR16 0110 1250 0000 0001 2300 695") // Valid in Greece
//IBAN.isValid("GB29 NWBK 6016 1331 9268 19") // Valid in UK (non-numeric bban)










