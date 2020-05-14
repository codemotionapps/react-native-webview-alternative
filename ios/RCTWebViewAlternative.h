#import <WebKit/WebKit.h>
#import <React/RCTViewManager.h>

@interface RCTWebViewAlternative : WKWebView {
    NSNumber * _Nullable _hideKeyboardAccessoryView;
    NSNumber * _Nullable _keyboardDisplayRequiresUserAction;
}

@property (nonatomic, copy) RCTDirectEventBlock _Nullable onLoad;

- (BOOL)scrollEnabled;
- (void)setScrollEnabled:(BOOL)enabled;

- (BOOL)hideKeyboardAccessoryView;
- (void)setHideKeyboardAccessoryView:(BOOL)hideKeyboardAccessoryView;

- (BOOL)keyboardDisplayRequiresUserAction;
- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction;

@end
