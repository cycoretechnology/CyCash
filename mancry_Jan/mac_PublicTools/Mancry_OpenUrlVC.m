

#import "Mancry_OpenUrlVC.h"
#import <WebKit/WebKit.h>
#import "mancry_Jan-Swift.h"

@interface Mancry_OpenUrlVC ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>


@property (nonatomic, strong) WKWebView *figures_webView;

// 防止同一页面重复注入 userData / rejectData
@property (nonatomic, assign) BOOL fig_hasInjectedUserData;
@property (nonatomic, assign) BOOL fig_hasInjectedRejectData;

@end

@implementation Mancry_OpenUrlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Disable swipe back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self mancry_creatNavibarView];
    [self figure_creatWebView];
    [self figure_loadH5Page];
}

- (void)mancry_creatNavibarView {
    self.navigationController.navigationBarHidden = YES;

    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat screenWidth = MIN(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    CGFloat navBarHeight = statusHeight + 44.0;

    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, navBarHeight)];
    [self.view addSubview:navBar];

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:navBar.bounds];
    bgImageView.image = [UIImage imageNamed:@"bzkyc_bg"];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    [navBar addSubview:bgImageView];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, statusHeight, 80, 44);
    [backBtn setImage:[UIImage imageNamed:@"flbeql_fh"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(figures_backAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / 2.0 - 100.0, statusHeight, 200.0, 44.0)];
    titleLabel.text = @"Accurate Recommendation";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navBar addSubview:titleLabel];
}

- (void)figure_creatWebView {
    // Create WKWebView configuration
    WKWebViewConfiguration *figuresconfig = [[WKWebViewConfiguration alloc] init];
    
    [figuresconfig.userContentController addScriptMessageHandler:self name:@"iosHandler"];
    figuresconfig.preferences.javaScriptEnabled = YES;

    figuresconfig.allowsInlineMediaPlayback = YES;
    figuresconfig.allowsPictureInPictureMediaPlayback = YES;
    figuresconfig.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    
   
    
    // Create WKWebView
    self.figures_webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:figuresconfig];
    self.figures_webView.navigationDelegate = self;
    self.figures_webView.UIDelegate = self;
    self.figures_webView.backgroundColor = [UIColor whiteColor];
    self.figures_webView.opaque = NO;
    self.figures_webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.figures_webView];
    
    // Setup constraints — leave room for custom nav bar
    CGFloat navBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + 44.0;
    [NSLayoutConstraint activateConstraints:@[
        [self.figures_webView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:navBarHeight],
        [self.figures_webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.figures_webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.figures_webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    // Add KVO for loading progress
    [self.figures_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)figure_loadH5Page {
    
    NSString *urlStr = [self.mancry_h5URL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
        
    NSURL *url = [NSURL URLWithString:urlStr];
  
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 30;
    
    // Set custom User-Agent
    NSString *customUA = [Mancry_PublicMethodS figures_userAgment];
    [request setValue:customUA forHTTPHeaderField:@"User-Agent"];
    
    [self.figures_webView loadRequest:request];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
   
}



- (void)figures_backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    // Hide loading HUD
//    [MBProgressHUD wj_hideHUDForView:self.view];
    
    
    self.fig_hasInjectedUserData = NO;
    self.fig_hasInjectedRejectData = NO;
    
    // Send common parameters to H5
    
    [self figures_injectRejectDataIfNeeded];
}

- (void)figures_injectRejectDataIfNeeded {
    if (self.fig_hasInjectedRejectData) {
        return;
    }
    
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"mancry_urlStr"] ?: @"";
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"] ?: @"";
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"] ?: @"";
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:@"phoneNum"] ?: @"";
    
    NSDictionary *payload = @{
        @"appId": @"cycash",
        @"salt": @"ZDEqguGMcHgbd3Ai",
        @"mobile": phoneNum ?: @"",
        @"baseUrl": baseUrl ?: @"",
        @"userId": userId ?: @"",
        @"token": token ?: @""
    };
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:&error];
    if (error || !jsonData) {
        return;
    }
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!json) {
        return;
    }
    
    NSString *escaped = [self figures_sanitizeJSONString:json];
    
    // 只有当 rejectData 在页面中存在时才调用，并且根据返回值标记注入完成，避免函数不存在时产生日志/错误
    NSString *jsCode = [NSString stringWithFormat:
                         @"(function(){ if (typeof rejectData === 'function') { rejectData('%@'); return true; } return false; })();",
                         escaped];
    
    [self.figures_webView evaluateJavaScript:jsCode completionHandler:^(id result, NSError *evalError) {
        if (evalError) { return; }
        if (result && result != [NSNull null]) {
            if ([result respondsToSelector:@selector(boolValue)] && [result boolValue]) {
                self.fig_hasInjectedRejectData = YES;
            }
        }
    }];
}

- (NSString *)figures_sanitizeJSONString:(NSString *)json {
    if (!json) { return @""; }
    return [[[json stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] // \
             stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]      // '
             stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]      // \n
            stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];      // \r
}


- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isKindOfClass:[NSString class]]) {
        
        NSString *fig_action = nil;
        NSDictionary *messageDict = nil;
        
        fig_action = (NSString *)message.body;
        messageDict = @{}; // Empty dictionary
        
        if ([fig_action hasPrefix:@"thirdUrl"]) {
               NSString *newString = [fig_action stringByReplacingOccurrencesOfString:@"thirdUrl=" withString:@""];
               NSString *newString2 = [newString stringByReplacingOccurrencesOfString:@"type=" withString:@""];
               NSArray *fruits = [newString2 componentsSeparatedByString:@"&"];
               NSLog(@"%@", fruits);

            [Mancry_uploadData mancry_insertPointDataWithInsertId:@"501"];
            [Mancry_uploadData mancry_insertPointDataWithInsertId:@"502"];
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fruits[0]] options:@{} completionHandler:^(BOOL success) {

               }];
           }
        
    }
}



@end
