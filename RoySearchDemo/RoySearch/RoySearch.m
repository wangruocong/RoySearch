//
//  RoySearch.m
//  SearchDisPlayControllerDemo
//
//  Created by Roy on 15/7/26.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "RoySearch.h"
#define SccreenH [UIScreen mainScreen].bounds.size.width

@interface RoySearch () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic,strong) UISearchDisplayController * sdc;
@property (nonatomic,strong) UISearchBar * searchBar;

@property (nonatomic,strong) UIView *tempSearchDisplayBackgroungView;
@property (nonatomic,strong) UIImageView *tempNoResultView;
@property (nonatomic,strong) NSMutableArray * searchArray;
@property (nonatomic,copy) NSString *searchString;
@end

@implementation RoySearch
- (instancetype)initWithViewController:(UIViewController *)viewController
{
    if (self = [super init]) {
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
        self.searchBar.delegate=self;
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        self.searchBar.placeholder = @"搜索";
        self.searchBar.barStyle = UIBarStyleDefault;
        self.searchBar.barTintColor = [UIColor grayColor];
        [self.searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"gen_search_bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(13.0, 15.0, 13.0, 15.0)] forState:UIControlStateNormal];
        self.sdc = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:viewController];
        self.sdc.searchResultsDataSource = self;
        self.sdc.searchResultsDelegate = self;
        self.sdc.delegate = self;
    }
    
    
    return self;
}


//push选中的联系人
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark- UITableViewDataSource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}
#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //定制无结果时候的界面
    for (UIView *subView in self.sdc.searchResultsTableView.subviews) {
        
        if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
            //            subView.hidden = YES;
            UILabel *label =(UILabel *)subView;
            label.textColor = [UIColor clearColor];
            //            label.text = @"无结果，请检查输入内容是否正确";
            
            _tempNoResultView = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 240)/2, 0, 240, 100)];
            [_tempNoResultView setImage:[UIImage imageNamed:@"search_noResultsView"]];
            //            view.backgroundColor = [UIColor yellowColor];
            [subView addSubview:_tempNoResultView];
        }
        if ([subView isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
            subView.hidden = YES;
        }
    }
    
    
    self.searchArray=[NSMutableArray arrayWithCapacity:10];
    self.searchString = self.searchBar.text;
    [self.tempSearchDisplayBackgroungView removeFromSuperview];
//    [self.searchBar resignFirstResponder];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //每次搜索前清空searchArray
    self.searchArray = nil;
    /**
     这一句是关键，从而可以在下面：
     -(void)allview:(UIView *)rootview indent:(NSInteger)indent
     中拿到 取消按钮，
     */
    [searchBar setShowsCancelButton:YES animated:YES];
    [self allview:searchBar index:0];
    return YES;
}
//修改“cancel”以及cancel颜色
-(void)allview:(UIView *)rootview index:(NSInteger)index
{
    index++;
    for (UIView *aview in rootview.subviews)
    {
        if([aview isKindOfClass:NSClassFromString(@"UINavigationButton")]){
            /** 1.
             简单的方法就是信息本地化：在Project -> Localizations 添加 Chinese (Simplified) 即可.
             
             运行就可以发现 Cancel 变成 取消 了。
             */
            /** 2.
             可以深度定制取消按钮，即在此按钮上加上自己的视图
             */
            UIButton *btn = (UIButton *)aview;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTintColor:[UIColor grayColor]];
            [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor clearColor]];
            break;
        }
        [self allview:aview index:index];
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //iOS8下毛玻璃效果
        self.tempSearchDisplayBackgroungView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.tempSearchDisplayBackgroungView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.tempSearchDisplayBackgroungView.alpha = 0.95;
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 198)/2, 70, 198, 168)];
        [view setImage:[UIImage imageNamed:@"search_tempSearchDisplayBackgroungView"]];
        [self.tempSearchDisplayBackgroungView addSubview:view];
        [_searchBar insertSubview:self.tempSearchDisplayBackgroungView atIndex:0];
    }
    else {
        //iOS7下半透明
    self.tempSearchDisplayBackgroungView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 198)/2, 70, 198, 168)];
    [view setImage:[UIImage imageNamed:@"search_tempSearchDisplayBackgroungView"]];
    [self.tempSearchDisplayBackgroungView addSubview:view];
    
        self.tempSearchDisplayBackgroungView.alpha = 0.95;
        self.tempSearchDisplayBackgroungView.backgroundColor = [UIColor whiteColor];
    [_searchBar insertSubview:self.tempSearchDisplayBackgroungView atIndex:0];
    }

}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.tempSearchDisplayBackgroungView removeFromSuperview];

}
#pragma mark - UISearchDisplayControllerdelegate methods
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{

}
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{

}


@end
