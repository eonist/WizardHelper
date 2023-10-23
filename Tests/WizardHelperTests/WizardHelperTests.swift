import XCTest
@testable import WizardHelper

final class WizardHelperTests: XCTestCase {
   func testExample() throws {
      // quick assertion that methods can be summoned
      _ = WizardHelper.promptOpenFile
      _ = WizardHelper.promptSaveFile
   }
}
