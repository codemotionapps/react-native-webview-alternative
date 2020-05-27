#import <WebKit/WebKit.h>
#import <React/RCTViewManager.h>

@interface RCTWebViewAlternative : WKWebView <WKScriptMessageHandler> {
    NSNumber * _Nullable _hideKeyboardAccessoryView;
    NSNumber * _Nullable _keyboardDisplayRequiresUserAction;
}

@property (nonatomic, copy) RCTDirectEventBlock _Nullable onLoad;
@property (nonatomic, copy) RCTDirectEventBlock _Nullable onMessage;

- (nonnull instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nonnull instancetype)initWithFrame:(CGRect)frame configuration:(nonnull WKWebViewConfiguration *)configuration NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder NS_UNAVAILABLE;

- (BOOL)scrollEnabled;
- (void)setScrollEnabled:(BOOL)enabled;

- (BOOL)hideKeyboardAccessoryView;
- (void)setHideKeyboardAccessoryView:(BOOL)hideKeyboardAccessoryView;

- (BOOL)keyboardDisplayRequiresUserAction;
- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction;

@end
