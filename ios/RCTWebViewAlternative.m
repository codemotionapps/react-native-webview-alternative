#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#import "RCTWebViewAlternative.h"

@interface RCTWebViewAlternativeContentViewHelper : UIView {
    WKWebView * _Nullable _webView;
}

@end

@implementation RCTWebViewAlternativeContentViewHelper

- (BOOL)keyboardDisplayRequiresUserAction {
    if (_webView == nil) return YES;

    if ([_webView respondsToSelector:sel_getUid("keyboardDisplayRequiresUserAction")]) {
        return [(RCTWebViewAlternative *)_webView keyboardDisplayRequiresUserAction];
    }

    return YES;
}

- (BOOL)hideKeyboardAccessoryView {
    if (_webView == nil) return YES;

    if ([_webView respondsToSelector:sel_getUid("hideKeyboardAccessoryView")]) {
        return [(RCTWebViewAlternative *)_webView hideKeyboardAccessoryView];
    }

    return YES;
}

- (id)inputAccessoryView {
    return nil;
}

@end

@implementation RCTWebViewAlternative

- (UIView *)contentView {
    UIView *contentView;
    [[self valueForKey:@"_contentView"] getValue:&contentView];
    return contentView;
}

- (BOOL)scrollEnabled {
    return self.scrollView.scrollEnabled;
}

- (void)setScrollEnabled:(BOOL)enabled {
    self.scrollView.scrollEnabled = enabled;
}

- (BOOL)keyboardDisplayRequiresUserAction {
    return _keyboardDisplayRequiresUserAction == nil ? YES : _keyboardDisplayRequiresUserAction.boolValue;
}

- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction {
    _keyboardDisplayRequiresUserAction = [NSNumber numberWithBool:keyboardDisplayRequiresUserAction];
    if (keyboardDisplayRequiresUserAction) return;

    static Method method;
    
    if (method != nil) return; // Already swizzled

    Class contentViewClass = objc_lookUpClass("WKContentView");
    IMP override;

    SEL keyboardDisplayRequiresUserActionSelector = sel_getUid("keyboardDisplayRequiresUserAction");
    BOOL (* getKeyboardDisplayRequiresUserAction)(id, SEL) = (BOOL (*)(id, SEL))method_getImplementation(class_getInstanceMethod(RCTWebViewAlternativeContentViewHelper.class, keyboardDisplayRequiresUserActionSelector));
    if (@available(iOS 13.0.0, *)) {
        SEL selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:activityStateChanges:userObject:");
        method = class_getInstanceMethod(contentViewClass, selector);
        IMP original = method_getImplementation(method);
        override = imp_implementationWithBlock(^void(UIView *this, void *information, BOOL userIsInteracting, BOOL blurPreviousNode, uint activityStateChanges, id userObject) {
            if (!getKeyboardDisplayRequiresUserAction(this, keyboardDisplayRequiresUserActionSelector)) userIsInteracting = YES;
            ((void (*)(id, SEL, void*, BOOL, BOOL, uint, id))original)(this, selector, information, TRUE, blurPreviousNode, activityStateChanges, userObject);
        });
    } else if (@available(iOS 12.2.0, *)) {
        SEL selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:changingActivityState:userObject:");
        method = class_getInstanceMethod(contentViewClass, selector);
        IMP original = method_getImplementation(method);
        override = imp_implementationWithBlock(^void(UIView *this, void* arg0, BOOL userIsInteracting, BOOL arg2, BOOL arg3, id arg4) {
            if (!getKeyboardDisplayRequiresUserAction(this, keyboardDisplayRequiresUserActionSelector)) userIsInteracting = YES;
            ((void (*)(id, SEL, void*, BOOL, BOOL, BOOL, id))original)(this, selector, arg0, TRUE, arg2, arg3, arg4);
        });
    } else if (@available(iOS 11.3.0, *)) {
        SEL selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:changingActivityState:userObject:");
        method = class_getInstanceMethod(contentViewClass, selector);
        IMP original = method_getImplementation(method);
        override = imp_implementationWithBlock(^void(UIView *this, void *arg0, BOOL userIsInteracting, BOOL arg2, BOOL arg3, id arg4) {
            if (!getKeyboardDisplayRequiresUserAction(this, keyboardDisplayRequiresUserActionSelector)) userIsInteracting = YES;
            ((void (*)(id, SEL, void *, BOOL, BOOL, BOOL, id))original)(this, selector, arg0, TRUE, arg2, arg3, arg4);
        });
    } else {
        SEL selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:");
        method = class_getInstanceMethod(contentViewClass, selector);
        IMP original = method_getImplementation(method);
        override = imp_implementationWithBlock(^void(UIView *this, void *arg0, BOOL userIsInteracting, BOOL arg2, id arg3) {
            if (!getKeyboardDisplayRequiresUserAction(this, keyboardDisplayRequiresUserActionSelector)) userIsInteracting = YES;
            ((void (*)(id, SEL, void *, BOOL, BOOL, id))original)(this, selector, arg0, userIsInteracting, arg2, arg3);
        });
    }

    method_setImplementation(method, override);
}

- (BOOL)hideKeyboardAccessoryView {
    return _hideKeyboardAccessoryView == nil ? NO : _hideKeyboardAccessoryView.boolValue;
}

- (void)setHideKeyboardAccessoryView:(BOOL)hideKeyboardAccessoryView {
    _hideKeyboardAccessoryView = [NSNumber numberWithBool:hideKeyboardAccessoryView];
    if (!hideKeyboardAccessoryView) return;

    static Method method;

    if (method != nil) return; // Already swizzled

    Class contentViewClass = objc_lookUpClass("WKContentView");
    SEL inputAccessoryViewSelector = sel_getUid("inputAccessoryView");
    SEL hideKeyboardAccessoryViewSelector = sel_getUid("hideKeyboardAccessoryView");
    BOOL (* getHideKeyboardAccessoryViewSelector)(id, SEL) = (BOOL (*)(id, SEL))method_getImplementation(class_getInstanceMethod(RCTWebViewAlternativeContentViewHelper.class, hideKeyboardAccessoryViewSelector));
    method = class_getInstanceMethod(contentViewClass, inputAccessoryViewSelector);
    IMP original = method_getImplementation(method);
    IMP override = imp_implementationWithBlock(^id (UIView *this) {
        if (getHideKeyboardAccessoryViewSelector(this, hideKeyboardAccessoryViewSelector)) return nil;
        return ((id (*)(id, SEL))original)(this, inputAccessoryViewSelector);
    });
    method_setImplementation(method, override);
}

@end
