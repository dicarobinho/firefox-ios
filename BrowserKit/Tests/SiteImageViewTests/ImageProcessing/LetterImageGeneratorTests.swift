// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0

import XCTest
@testable import SiteImageView

final class LetterImageGeneratorTests: XCTestCase {
    func testEmptyDomain_doesntReturnEmptyImage() {
        let subject = DefaultLetterImageGeneratorSpy()
        let result = subject.generateLetterImage(domain: "")

        XCTAssertEqual(subject.capturedLetter, "#")
        XCTAssertNotEqual(result, UIImage())
        testColor(subject: subject, red: 0.850, green: 0.133, blue: 0.082, alpha: 1.0)
    }

    func testDomain1_returnsExpectedLetterAndColor() {
        let subject = DefaultLetterImageGeneratorSpy()
        let result = subject.generateLetterImage(domain: "mozilla.com")

        XCTAssertEqual(subject.capturedLetter, "M")
        XCTAssertNotEqual(result, UIImage())
        testColor(subject: subject, red: 0.223, green: 0.576, blue: 0.125, alpha: 1.0)
    }

    func testDomain2_returnsExpectedLetterAndColor() {
        let subject = DefaultLetterImageGeneratorSpy()
        let result = subject.generateLetterImage(domain: "firefox.com")

        XCTAssertEqual(subject.capturedLetter, "F")
        XCTAssertNotEqual(result, UIImage())
        testColor(subject: subject, red: 0.584, green: 0.803, blue: 1.0, alpha: 1.0)
    }

    func testFakeDomain_returnsExpectedLetterAndColor() {
        let subject = DefaultLetterImageGeneratorSpy()
        let result = subject.generateLetterImage(domain: "?$%^")

        XCTAssertEqual(subject.capturedLetter, "?")
        XCTAssertNotEqual(result, UIImage())
        testColor(subject: subject, red: 0.003, green: 0.639, blue: 0.615, alpha: 1.0)
    }
}

// MARK: - Helper methods
private extension LetterImageGeneratorTests {
    func testColor(subject: DefaultLetterImageGeneratorSpy,
                   red: CGFloat,
                   green: CGFloat,
                   blue: CGFloat,
                   alpha: CGFloat,
                   file: StaticString = #file,
                   line: UInt = #line) {
        var resultRed: CGFloat = 0
        var resultGreen: CGFloat = 0
        var resultBlue: CGFloat = 0
        var resultAlpha: CGFloat = 0

        subject.capturedColor?.getRed(&resultRed,
                                      green: &resultGreen,
                                      blue: &resultBlue,
                                      alpha: &resultAlpha)
        XCTAssertEqual(resultRed, red, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(resultGreen, green, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(resultBlue, blue, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(resultAlpha, alpha, accuracy: 0.001, file: file, line: line)
    }
}

// MARK: - DefaultLetterImageGeneratorSpy
class DefaultLetterImageGeneratorSpy: DefaultLetterImageGenerator {
    var capturedLetter: String?
    var capturedColor: UIColor?

    override func generateImage(fromLetter letter: String, color: UIColor) -> UIImage {
        capturedLetter = letter
        capturedColor = color
        return super.generateImage(fromLetter: letter, color: color)
    }
}
