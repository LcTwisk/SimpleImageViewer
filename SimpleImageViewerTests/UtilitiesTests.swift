import XCTest

class UtilitiesTests: XCTestCase {
    fileprivate let screenRect = CGRect(x: 0, y: 0, width: 640, height: 960)
    
    func testRectForSize() {
        let square = CGSize(width: 600, height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedRectForSquare = CGRect(origin: .zero, size: square)
        let expectedRectForLandscape = CGRect(origin: .zero, size: landscape)
        let expectedRectForPortrait = CGRect(origin: .zero, size: portrait)
        
        XCTAssertEqual(expectedRectForSquare, Utilities.rect(forSize: square))
        XCTAssertEqual(expectedRectForLandscape, Utilities.rect(forSize: landscape))
        XCTAssertEqual(expectedRectForPortrait, Utilities.rect(forSize: portrait))
    }
    
    func testAspectFitRectForSizeIntoRect() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedAspectFitForSquare = CGRect(x: 0, y: 160, width: 640, height: 640)
        let expectedAspectFitForLandscape = CGRect(x: 0, y: 300, width: 640, height: 360)
        let expectedAspectFitForPortrait = CGRect(x: 50, y: 0, width: 540, height: 960)
        
        XCTAssertEqual(expectedAspectFitForSquare, Utilities.aspectFitRect(forSize: square, insideRect: screenRect))
        XCTAssertEqual(expectedAspectFitForLandscape, Utilities.aspectFitRect(forSize: landscape, insideRect: screenRect))
        XCTAssertEqual(expectedAspectFitForPortrait, Utilities.aspectFitRect(forSize: portrait, insideRect: screenRect))
    }
    
    func testAspectFillRectForSizeIntoRect() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedAspectFillForSquare = CGRect(x: 0, y: 0, width: 960, height: 960)
        let expectedAspectFillForLandscape = CGRect(x: 0, y: 0, width: 1706, height: 960)
        let expectedAspectFillForPortrait = CGRect(x: 0, y: 0, width: 640, height: 1137)
        
        XCTAssertEqual(expectedAspectFillForSquare, Utilities.aspectFillRect(forSize: square, insideRect: screenRect))
        XCTAssertEqual(expectedAspectFillForLandscape, Utilities.aspectFillRect(forSize: landscape, insideRect: screenRect))
        XCTAssertEqual(expectedAspectFillForPortrait, Utilities.aspectFillRect(forSize: portrait, insideRect: screenRect))
    }
    
    func testCenterForSize() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedCenterForSquare = CGPoint(x: 300, y: 300)
        let expectedCenterForLandscape = CGPoint(x: 800, y: 450)
        let expectedCenterForPortrait = CGPoint(x: 450, y: 800)
        
        XCTAssertEqual(expectedCenterForSquare, Utilities.center(forSize: square))
        XCTAssertEqual(expectedCenterForLandscape, Utilities.center(forSize: landscape))
        XCTAssertEqual(expectedCenterForPortrait, Utilities.center(forSize: portrait))
        
    }
    
    func testCenterTopForSize() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedCenterTopForSquare = CGPoint(x: 320, y: 300)
        let expectedCenterTopForLandscape = CGPoint(x: 320, y: 450)
        let expectedCenterTopForPortrait = CGPoint(x: 320, y: 800)
        
        XCTAssertEqual(expectedCenterTopForSquare, Utilities.centerTop(forSize: square, insideSize: screenRect.size))
        XCTAssertEqual(expectedCenterTopForLandscape, Utilities.centerTop(forSize: landscape, insideSize: screenRect.size))
        XCTAssertEqual(expectedCenterTopForPortrait, Utilities.centerTop(forSize: portrait, insideSize: screenRect.size))
    }
    
    func testCenterBottomForSize() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedCenterBottomForSquare = CGPoint(x: 320, y: 660)
        let expectedCenterBottomForLandscape = CGPoint(x: 320, y: 510)
        let expectedCenterBottomForPortrait = CGPoint(x: 320, y: 160)
        
        XCTAssertEqual(expectedCenterBottomForSquare, Utilities.centerBottom(forSize: square, insideSize: screenRect.size))
        XCTAssertEqual(expectedCenterBottomForLandscape, Utilities.centerBottom(forSize: landscape, insideSize: screenRect.size))
        XCTAssertEqual(expectedCenterBottomForPortrait, Utilities.centerBottom(forSize: portrait, insideSize: screenRect.size))
    }
    
    func testCenterLeftForSize() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedCenterLeftForSquare = CGPoint(x: 300, y: 480)
        let expectedCenterLeftForLandscape = CGPoint(x: 800, y: 480)
        let expectedCenterLeftForPortrait = CGPoint(x: 450, y: 480)
        
        XCTAssertEqual(expectedCenterLeftForSquare, Utilities.centerLeft(forSize: square, insideSize: screenRect.size))
        XCTAssertEqual(expectedCenterLeftForLandscape, Utilities.centerLeft(forSize: landscape, insideSize: screenRect.size))
        XCTAssertEqual(expectedCenterLeftForPortrait, Utilities.centerLeft(forSize: portrait, insideSize: screenRect.size))
    }
    
    func testCenterRightForSize() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedCenterRightForSquare = CGPoint(x: 340, y: 480)
        let expectedCenterRightForLandscape = CGPoint(x: -160, y: 480)
        let expectedCenterRightForPortrait = CGPoint(x: 190, y: 480)
        
        XCTAssertEqual(expectedCenterRightForSquare, Utilities.centerRight(forSize: square, insideSize: screenRect.size))
        XCTAssertEqual(expectedCenterRightForLandscape, Utilities.centerRight(forSize: landscape, insideSize: screenRect.size))
        XCTAssertEqual(expectedCenterRightForPortrait, Utilities.centerRight(forSize: portrait, insideSize: screenRect.size))
    }
    
    func testTopLeftForSize() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedTopLeftForSquare = CGPoint(x: 300, y: 300)
        let expectedTopLeftForLandscape = CGPoint(x: 800, y: 450)
        let expectedTopLeftForPortrait = CGPoint(x: 450, y: 800)
        
        XCTAssertEqual(expectedTopLeftForSquare, Utilities.topLeft(forSize: square, insideSize: screenRect.size))
        XCTAssertEqual(expectedTopLeftForLandscape, Utilities.topLeft(forSize: landscape, insideSize: screenRect.size))
        XCTAssertEqual(expectedTopLeftForPortrait, Utilities.topLeft(forSize: portrait, insideSize: screenRect.size))
    }
    
    func testTopRightForSize() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedTopRightForSquare = CGPoint(x: 340, y: 300)
        let expectedTopRightForLandscape = CGPoint(x: -160, y: 450)
        let expectedTopRightForPortrait = CGPoint(x: 190, y: 800)
        
        XCTAssertEqual(expectedTopRightForSquare, Utilities.topRight(forSize: square, insideSize: screenRect.size))
        XCTAssertEqual(expectedTopRightForLandscape, Utilities.topRight(forSize: landscape, insideSize: screenRect.size))
        XCTAssertEqual(expectedTopRightForPortrait, Utilities.topRight(forSize: portrait, insideSize: screenRect.size))
    }
    
    func testBottomLeftForSize() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedBottomLeftForSquare = CGPoint(x: 300, y: 660)
        let expectedBottomLeftForLandscape = CGPoint(x: 800, y: 510)
        let expectedBottomLeftForPortrait = CGPoint(x: 450, y: 160)
        
        XCTAssertEqual(expectedBottomLeftForSquare, Utilities.bottomLeft(forSize: square, insideSize: screenRect.size))
        XCTAssertEqual(expectedBottomLeftForLandscape, Utilities.bottomLeft(forSize: landscape, insideSize: screenRect.size))
        XCTAssertEqual(expectedBottomLeftForPortrait, Utilities.bottomLeft(forSize: portrait, insideSize: screenRect.size))
    }
    
    func testBottomRightForSize() {
        let square = CGSize(width: 600 , height: 600)
        let landscape = CGSize(width: 1600, height: 900)
        let portrait = CGSize(width: 900, height: 1600)
        
        let expectedBottomRightForSquare = CGPoint(x: 340, y: 660)
        let expectedBottomRightForLandscape = CGPoint(x: -160, y: 510)
        let expectedBottomRightForPortrait = CGPoint(x: 190, y: 160)
        
        XCTAssertEqual(expectedBottomRightForSquare, Utilities.bottomRight(forSize: square, insideSize: screenRect.size))
        XCTAssertEqual(expectedBottomRightForLandscape, Utilities.bottomRight(forSize: landscape, insideSize: screenRect.size))
        XCTAssertEqual(expectedBottomRightForPortrait, Utilities.bottomRight(forSize: portrait, insideSize: screenRect.size))
    }
}
