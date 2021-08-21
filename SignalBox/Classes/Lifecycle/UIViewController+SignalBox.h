//
//  UIViewController+SignalBox.h
//  SignalBox
//
//  Created by jimmy on 2021/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SignalBoxBlock)(void);

#define SBB(method)  SignalBoxBlock signalBox_##method ;

@interface UIViewController (SignalBox)

@property(nullable, nonatomic, copy) SBB(willAppear)

@property(nullable, nonatomic, copy) SBB(didAppear)

@property(nullable, nonatomic, copy) SBB(willDisAppear)

@property(nullable, nonatomic, copy) SBB(didDisAppear)

/**
 true after UIViewController viewDidAppear
 false after UIViewController viewDidDisAppear
 */
@property(nonatomic, assign)BOOL signalBox_isVisible;

@end

NS_ASSUME_NONNULL_END
