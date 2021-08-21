//
//  UIViewController+SignalBox.m
//  SignalBox
//
//  Created by jimmy on 2021/8/23.
//

#import "UIViewController+SignalBox.h"
#import <objc/runtime.h>

@implementation UIViewController (SignalBox)
+ (void)exchangeMethod:(SEL _Nonnull) originName replace:(SEL _Nonnull) replaceName {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originName);
    Method swizzledMethod = class_getInstanceMethod(class, replaceName);
    
    BOOL success = class_addMethod(class, replaceName, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, replaceName, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController exchangeMethod:@selector(viewWillAppear:) replace:@selector(signalBox_viewWillAppear:)];
        [UIViewController exchangeMethod:@selector(viewDidAppear:) replace:@selector(signalBox_viewDidAppear:)];
        [UIViewController exchangeMethod:@selector(viewWillDisappear:) replace:@selector(signalBox_viewWillDisAppear:)];
        [UIViewController exchangeMethod:@selector(viewDidDisappear:) replace:@selector(signalBox_viewDidDisAppear:)];
    });
}

- (void)signalBox_viewWillAppear:(BOOL)animated {
    [self signalBox_viewWillAppear:animated];
    if (self.signalBox_willAppear) {
        self.signalBox_willAppear();
    }
}

- (void)signalBox_viewDidAppear:(BOOL)animated {
    [self signalBox_viewDidAppear:animated];
    self.signalBox_isVisible = YES;
    if (self.signalBox_didAppear) {
        self.signalBox_didAppear();
    }
}

- (void)signalBox_viewWillDisAppear:(BOOL)animated {
    [self signalBox_viewWillDisAppear:animated];
    if (self.signalBox_willDisAppear) {
        self.signalBox_willDisAppear();
    }
}

- (void)signalBox_viewDidDisAppear:(BOOL)animated {
    [self signalBox_viewDidDisAppear:animated];
    self.signalBox_isVisible = NO;
    if (self.signalBox_didDisAppear) {
        self.signalBox_didDisAppear();
    }
}

- (void)setSignalBox_willAppear:(SignalBoxBlock)signalBox_willAppear {
    objc_setAssociatedObject(self, @selector(signalBox_willAppear), signalBox_willAppear, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SignalBoxBlock)signalBox_willAppear {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSignalBox_didAppear:(SignalBoxBlock)signalBox_didAppear {
    objc_setAssociatedObject(self, @selector(signalBox_didAppear), signalBox_didAppear, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SignalBoxBlock)signalBox_didAppear {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSignalBox_willDisAppear:(SignalBoxBlock)signalBox_willDisAppear {
    objc_setAssociatedObject(self, @selector(signalBox_willDisAppear), signalBox_willDisAppear, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SignalBoxBlock)signalBox_willDisAppear {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSignalBox_didDisAppear:(SignalBoxBlock)signalBox_didDisAppear {
    objc_setAssociatedObject(self, @selector(signalBox_didDisAppear), signalBox_didDisAppear, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SignalBoxBlock)signalBox_didDisAppear {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSignalBox_isVisible:(BOOL)signalBox_isVisible {
    objc_setAssociatedObject(self, @selector(signalBox_isVisible), @(signalBox_isVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)signalBox_isVisible {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
