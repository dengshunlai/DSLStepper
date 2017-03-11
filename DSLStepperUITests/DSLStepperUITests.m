//
//  DSLStepperUITests.m
//  DSLStepperUITests
//
//  Created by 邓顺来 on 2017/2/25.
//  Copyright © 2017年 邓顺来. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DSLStepperUITests : XCTestCase

@end

@implementation DSLStepperUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testMaximum {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"\u8fdb\u5165Demo"] tap];
    
    XCUIElement *textField = [[[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"View"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeTextField].element;
    [textField tap];
    [textField typeText:@"99999999"];
    [app.toolbars.buttons[@"Done"] tap];
}

- (void)testMinimum {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"\u8fdb\u5165Demo"] tap];
    
    XCUIElement *textField = [[[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"View"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeTextField].element;
    [textField tap];
    
    XCUIElement *key = app.keys[@"\u522a\u9664"];
    [key tap];
    [key tap];
    [key tap];
    [textField typeText:@"3"];
    [app.toolbars.buttons[@"Done"] tap];
}

@end
