#import <WebKit/WebKit.h>
#import <React/RCTViewManager.h>

@interface RCTWebViewAlternative : WKWebView <WKScriptMessageHandler> {
    NSNumber * _Nullable _hideKeyboardAccessoryView;
    NSNumber * _Nullable _keyboardDisplayRequiresUserAction;
}

@property (nonatomic, copy) RCTDirectEventBlock _Nullable onLoad;
@property (nonatomic, copy) RCTDirectEventBlock _Nullable onMessage;

- (BOOL)scrollEnabled;
- (void)setScrollEnabled:(BOOL)enabled;

- (BOOL)hideKeyboardAccessoryView;
- (void)setHideKeyboardAccessoryView:(BOOL)hideKeyboardAccessoryView;

- (BOOL)keyboardDisplayRequiresUserAction;
- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction;

@end
