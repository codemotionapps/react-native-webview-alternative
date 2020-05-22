#import <objc/runtime.h>
#import <WebKit/WebKit.h>
#import <React/RCTUIManager.h>
#import <React/RCTLog.h>
#import <React/RCTConvert.h>

#import "WebViewAlternative.h"

#import "RCTWebViewAlternative.h"

@implementation WebViewAlternativeManager

RCT_EXPORT_MODULE(WebViewAlternative)

- (RCTWebViewAlternative *)view {
    RCTWebViewAlternative *view = [RCTWebViewAlternative new];
    view.navigationDelegate = self;
    [view.configuration.userContentController addScriptMessageHandler:view name:@"jsMessageHandler"];
    return view;
}

RCT_EXPORT_METHOD(focus:(nonnull NSNumber *) reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:RCTWebViewAlternative.class]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }

        [(RCTWebViewAlternative *)view evaluateJavaScript:@";(function(){var e=document.activeElement;e.blur();e.focus()}());" completionHandler:nil];
    }];
}

RCT_EXPORT_METHOD(loadHTMLString:(nonnull NSNumber *) reactTag string:(nonnull NSString *)string baseURL:(nullable NSString *)baseURL) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:RCTWebViewAlternative.class]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }

        [(RCTWebViewAlternative *)view loadHTMLString:string baseURL:baseURL ? [NSURL URLWithString:baseURL] : nil];
    }];
}

RCT_EXPORT_METHOD(injectJavaScript:(nonnull NSNumber *) reactTag string:(nonnull NSString *)string) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:RCTWebViewAlternative.class]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }

        [(RCTWebViewAlternative *)view evaluateJavaScript:string completionHandler:nil];
    }];
}

RCT_EXPORT_METHOD(scrollTo:(nonnull NSNumber *) reactTag offsetX:(CGFloat)x offsetY:(CGFloat)y animated:(BOOL)animated) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:RCTWebViewAlternative.class]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }

        [((RCTWebViewAlternative *)view).scrollView setContentOffset:(CGPoint){x, y} animated:animated];
    }];
}

RCT_EXPORT_VIEW_PROPERTY(scrollEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(keyboardDisplayRequiresUserAction, BOOL)
RCT_EXPORT_VIEW_PROPERTY(hideKeyboardAccessoryView, BOOL)

RCT_EXPORT_VIEW_PROPERTY(onLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMessage, RCTDirectEventBlock)

#pragma mark - WKNavigationDelegate

- (void)webView:(RCTWebViewAlternative *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (!webView.onLoad) return;

    webView.onLoad(nil);
}

@end
