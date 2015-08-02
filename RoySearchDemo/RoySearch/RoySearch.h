//
//  RoySearch.h
//  SearchDisPlayControllerDemo
//
//  Created by Roy on 15/7/26.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RoySearch;

@interface RoySearch : NSObject

@property (nonatomic,strong, readonly) UISearchBar * searchBar;

- (instancetype)initWithViewController:(UIViewController *)viewController;



@end
