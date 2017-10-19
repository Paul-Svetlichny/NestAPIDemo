//
//  NestAuthWebViewController.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestAuthViewController.h"

@import WebKit;

@interface NestAuthViewController () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *authenticationWebView;

@end

@implementation NestAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.authenticationWebView loadRequest:_request];
}

- (void)loadView {
    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    _authenticationWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfiguration];
    _authenticationWebView.navigationDelegate = self;
    
    self.view = _authenticationWebView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - WKWebView Navigation Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    switch (navigationAction.navigationType) {
        case WKNavigationTypeOther:
        {
            [_delegate nestAuthViewController:self didRecieveServerResponceURL:[navigationAction.request URL]];
        }
            break;
        default:
            break;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
