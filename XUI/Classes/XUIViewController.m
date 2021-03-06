//
// Created by Zheng on 26/07/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIViewController.h"

#import "XUIPrivate.h"
#import "XUITheme.h"
#import "XUILogger.h"
#import "XUICellFactory.h"

#import "UIViewController+XUIPreviousViewController.h"

@interface XUIViewController () <XUICellFactoryDelegate>

@property (nonatomic, strong) UIColor *outsideForegroundColor;
@property (nonatomic, strong) UIColor *outsideBackgroundColor;
@property (nonatomic, assign) BOOL fromXUIViewController;

@end

@implementation XUIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.theme) {
        if ([self.theme isDarkMode]) {
            return UIStatusBarStyleLightContent;
        } else {
            return UIStatusBarStyleDefault;
        }
    } else {
        return [super preferredStatusBarStyle];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupXUI];
    }
    return self;
}

- (void)setupXUI {
    {
        _outsideForegroundColor = [UIColor blackColor];
        _outsideBackgroundColor = [UIColor whiteColor];
        
        XUICellFactory *cellFactory = [[XUICellFactory alloc] init];
        cellFactory.delegate = self;
        _cellFactory = cellFactory;
    }
}

- (UINavigationBar *)navigationBar {
    return self.navigationController.navigationBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    XUI_START_IGNORE_PARTIAL
    if ([self.navigationItem respondsToSelector:@selector(largeTitleDisplayMode)]) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    XUI_END_IGNORE_PARTIAL
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    if (NO == [[self xui_previousViewController] isKindOfClass:[XUIViewController class]]) {
        self.outsideBackgroundColor = [self navigationBar].barTintColor;
        self.outsideForegroundColor = [self navigationBar].tintColor;
    } else {
        self.fromXUIViewController = YES;
    }
    [self renderNavigationBarTheme:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        if (self.fromXUIViewController == NO) {
            [self renderNavigationBarTheme:YES];
        }
    }
    [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent != nil) {
        
    }
    [super didMoveToParentViewController:parent];
}

#pragma mark - Navigation Bar Color

- (void)renderNavigationBarTheme:(BOOL)restore {
    if (XUI_COLLAPSED) return;
    UIColor *backgroundColor = self.outsideBackgroundColor;
    UIColor *foregroundColor = self.outsideForegroundColor;
    if (restore) {
       
    } else {
        if (self.theme) {
            if (self.theme.navigationTitleColor)
                foregroundColor = self.theme.navigationTitleColor;
            if (self.theme.navigationBarColor)
                backgroundColor = self.theme.navigationBarColor;
        }
    }
    [[self navigationBar] setTitleTextAttributes:@{ NSForegroundColorAttributeName : foregroundColor }];
    [self navigationBar].tintColor = foregroundColor;
    [self navigationBar].barTintColor = backgroundColor;
    self.navigationItem.leftBarButtonItem.tintColor = foregroundColor;
    self.navigationItem.rightBarButtonItem.tintColor = foregroundColor;
    for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
        item.tintColor = foregroundColor;
    }
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.tintColor = foregroundColor;
    }
    self.navigationController.navigationItem.leftBarButtonItem.tintColor = foregroundColor;
    self.navigationController.navigationItem.rightBarButtonItem.tintColor = foregroundColor;
    for (UIBarButtonItem *item in self.navigationController.navigationItem.leftBarButtonItems) {
        item.tintColor = foregroundColor;
    }
    for (UIBarButtonItem *item in self.navigationController.navigationItem.rightBarButtonItems) {
        item.tintColor = foregroundColor;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Getters

- (XUITheme *)theme {
    return self.cellFactory.theme;
}

- (XUILogger *)logger {
    return self.cellFactory.logger;
}

- (id <XUIAdapter>)adapter {
    return self.cellFactory.adapter;
}

- (NSString *)path {
    return self.cellFactory.adapter.path;
}

- (NSBundle *)bundle {
    return self.cellFactory.adapter.bundle;
}

#pragma mark - XUICellFactoryDelegate

- (void)cellFactory:(XUICellFactory *)parser didFailWithError:(NSError *)error {
    
}

- (void)cellFactoryDidFinishParsing:(XUICellFactory *)parser {
    
}

#pragma mark - Memory

- (void)dealloc {
    
}

@end
