//
//  HomeworkForSummerTests.swift
//  HomeworkForSummerTests
//
//  Created by Samuli Tamminen on 8.2.2016.
//  Copyright © 2016 Samuli Tamminen. All rights reserved.
//

import XCTest
@testable import HomeworkForSummer

class HomeworkForSummerTests: XCTestCase {
    
    func testIBAN() {
        
        // All ok
        XCTAssertEqual(IBAN.status("FI42 5000 1510 0000 23"), IBANstatus.Valid)
        XCTAssertEqual(IBAN.status("GR16 0110 1250 0000 0001 2300 695"), IBANstatus.Valid) // Valid in Greece
        XCTAssertEqual(IBAN.status("GB29 NWBK 6016 1331 9268 19"), IBANstatus.Valid) // Valid in UK (non-numeric BBAN)

        // Case shouldn't matter
        XCTAssertEqual(IBAN.status("fi42 5000 1510 0000 23"), IBANstatus.Valid)
        
        // All other characters than A-Z and 0-9 should be stripped away
        XCTAssertEqual(IBAN.status(" F I 4 2 .,-< 5000 1510 00_____00 23"), IBANstatus.Valid)
        
        // Checksum not matching
        XCTAssertEqual(IBAN.status("FI42 5000 1510 0000 20"), IBANstatus.ChecksumError)
        XCTAssertEqual(IBAN.status("FI42 5000 1510 xxxx 23"), IBANstatus.ChecksumError)

        // Too short
        XCTAssertEqual(IBAN.status(""), IBANstatus.LengthError)
        XCTAssertEqual(IBAN.status("FI42"), IBANstatus.LengthError)
        
        // Invalid Country Code
        XCTAssertEqual(IBAN.status("12 34 5678901234567890"), IBANstatus.CountryCodeError)
        XCTAssertEqual(IBAN.status("A0 34 5678901234567890"), IBANstatus.CountryCodeError)

    }
    
}
