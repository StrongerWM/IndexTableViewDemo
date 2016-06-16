//
//  IndexTableView.m
//  CustomIndexTableView
//
//  Created by Stronger_WM on 16/5/19.
//  Copyright © 2016年 Stronger_WM. All rights reserved.
//

#import "IndexTableView.h"
#import "DemoModel.h"
#import "IndexTableViewCell.h"

@interface IndexTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) UITableView *indexTableView;
@property (nonatomic ,strong) UITableView *detailTableView;

@property (nonatomic ,strong) NSMutableArray *indexArr;
@property (nonatomic ,strong) NSMutableArray *detailArr;

@property (nonatomic ,assign) BOOL left_isScrolling;            //左边表格是否在滑动
@property (nonatomic ,strong) NSIndexPath *last_indexPath;      //保存判断是否reload
@end

@implementation IndexTableView

- (void)updateViewIndexArr:(NSArray *)aArray detailArr:(NSArray *)a2dArray
{
    _indexArr = [NSMutableArray arrayWithArray:aArray];
    _detailArr = [NSMutableArray arrayWithArray:a2dArray];
    [_indexTableView reloadData];
    [_detailTableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews
{
    _indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 60, self.frame.size.height)];
    _indexTableView.rowHeight = 60;
    _indexTableView.delegate = self;
    _indexTableView.dataSource = self;
    [self addSubview:_indexTableView];
    
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(60, 0, self.frame.size.width-60, self.frame.size.height)];
    _detailTableView.rowHeight = 80;
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    [self addSubview:_detailTableView];
    
    _indexTableView.tableFooterView = [UIView new];
    _detailTableView.tableFooterView = [UIView new];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView == _detailTableView) {
//        CGPoint p = CGPointMake(5, 5);
//        NSIndexPath *tempPath = [_detailTableView indexPathForRowAtPoint:p];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempPath.section inSection:0];
//        [_indexTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    }
    
    if (scrollView == _indexTableView) {
        _left_isScrolling = YES;
    }
    else
    {
        _left_isScrolling = NO;
    }
    
    if (scrollView == _detailTableView) {
        if (_left_isScrolling) {
            return;
        }
        //获取detail当前最上方显示的cell所在的indexPath
        NSArray *arr = [_detailTableView indexPathsForVisibleRows];
        if (arr.count > 0) {
            NSIndexPath *tempPath = [arr objectAtIndex:0];
            if (tempPath) {
                if (_last_indexPath.section != tempPath.section) {
                    [self reloadSelectedCellAtIndex:tempPath.section];
                    _last_indexPath = tempPath;
                }
            }
        }
    }
}

//刷新对应cell的选中效果
- (void)reloadSelectedCellAtIndex:(NSInteger)index
{
    //找到对应的索引model，修改is_selcted = yes , 其余model=no -- > reload
    for (int i=0; i<_indexArr.count; i++) {
        DemoModel *model = _indexArr[i];
        if (i == index) {
            model.is_selected = YES;
        }
        else
        {
            model.is_selected = NO;
        }
    }
    [_indexTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _indexTableView) {
        [self reloadSelectedCellAtIndex:indexPath.row];
        
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [_detailTableView scrollToRowAtIndexPath:toIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    if (tableView == _detailTableView) {
        
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _indexTableView) {
        
    }
    if (tableView == _detailTableView) {
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _detailTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _detailTableView.bounds.size.width, 10)];
        view.backgroundColor = [UIColor grayColor];
        return view;
    }
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _indexTableView) {
        return 1;
    }
    if (tableView == _detailTableView) {
        return _detailArr.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _indexTableView) {
        return _indexArr.count;
    }
    if (tableView == _detailTableView) {
        return [_detailArr[section] count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *index_id = @"indexCell";
    static NSString *detail_id = @"detailCell";
    if (tableView == _indexTableView) {
        IndexTableViewCell *indexCell = [tableView dequeueReusableCellWithIdentifier:index_id];
        if (indexCell == nil) {
            indexCell = [[IndexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:index_id];
        }
        indexCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [indexCell updateCellModel:_indexArr[indexPath.row]];
        return indexCell;
    }
    if (tableView == _detailTableView) {
        UITableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:detail_id];
        if (detailCell == nil) {
            detailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detail_id];
        }
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        DemoModel *model = _detailArr[indexPath.section][indexPath.row];
        detailCell.textLabel.text = model.city_name;
        return detailCell;
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
