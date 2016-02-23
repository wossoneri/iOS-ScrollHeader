//
//  MyScrollHeader.m
//  BiliBiliScrollHeader
//
//  Created by wossoneri on 16/1/9.
//  Copyright © 2016年 wossoneri. All rights reserved.
//


#import "MyScrollHeader.h"
#import "Masonry.h"

@interface MyScrollHeader ()
{
    CGFloat _topHeight;
    CGFloat _bottomHeight;
    
    CGFloat _currentOffset;
    CGFloat _destinaOffset;

    
    UIView *topView;
    UIView *bottomView;

}

@end

@implementation MyScrollHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}


- (void)initData {
    _topHeight = HEADER_HEIGHT_TOP;
    _bottomHeight = HEADER_HEIGHT_BOTTOM;
    
    _destinaOffset = -_topHeight;
    _currentOffset = -_bottomHeight;
}

- (void)initView {
    
    // 压缩后的布局
    topView = [[UIView alloc] init];
    topView.alpha = 0;
    topView.backgroundColor = [UIColor colorWithRed:0xC4 / 255.f green:0xAD / 255.f blue:0xAC / 255.f alpha:1];
    
    UIImageView *topIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button"]];
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"显示标题";
    topLabel.textColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] init];
    [view addSubview:topIv];
    [view addSubview:topLabel];
    [topIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(view);
        make.right.equalTo(topLabel.mas_left);
    }];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topIv.mas_right);
        make.top.right.bottom.equalTo(view);
    }];
    
    [topView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
    }];
    
    
    // 拉伸后的布局
    bottomView = [[UIView alloc] init];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow"]];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    [bottomView addSubview:iv];
    [bottomView addSubview:blurView];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottomView);
    }];
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottomView);
    }];
//    [bottomView bringSubviewToFront:blurView];
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = @"显示标题";
    bottomLabel.textColor = [UIColor whiteColor];
    
    [bottomView addSubview:bottomBtn];
    [bottomView addSubview:bottomLabel];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-30);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-30);
    }];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(STATUS_BAR_HEIGHT);
        make.centerX.equalTo(bottomView);
    }];
    
    
    
    [self addSubview:topView];
    [self addSubview:bottomView];
 
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(HEADER_HEIGHT_TOP);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(HEADER_HEIGHT_BOTTOM);
    }];
    
    
    self.clipsToBounds = YES;
    [self.layer setMasksToBounds:YES];
    
}

#pragma mark - scroll state
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self.headerScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:Nil];
    self.headerScrollView.contentInset = UIEdgeInsetsMake(_bottomHeight, 0, 0, 0);
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGPoint newOffset = [change[@"new"] CGPointValue];
    
    
    [self updateSubViewsWithScrollOffset:newOffset];
}

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset {
    
    //    NSLog(@"scrollview inset top:%f", self.headerScrollView.contentInset.top);
    //    NSLog(@"new offset before:%f", newOffset.y);
    //    NSLog(@"newOffset : %f", newOffset.y);
    
    float startChangeOffset = - self.headerScrollView.contentInset.top;
    
    newOffset = CGPointMake(newOffset.x, newOffset.y < startChangeOffset ? startChangeOffset : (newOffset.y > _destinaOffset ? _destinaOffset : newOffset.y));
    //    NSLog(@"new offset after:%f", newOffset.y);
    
    
    float newY = - newOffset.y - _bottomHeight;//self.headerScrollView.contentInset.top;
    float d = _destinaOffset - startChangeOffset;
    float alpha = 1 - (newOffset.y - startChangeOffset) / d;
    
    
    
    //    self.headerScrollView.contentInset = UIEdgeInsetsMake(_bottomHeight, 0, 0, 0);
    self.frame = CGRectMake(0, newY, self.frame.size.width, self.frame.size.height);
    topView.frame = CGRectMake(0, -newY, self.frame.size.width, self.frame.size.height);
    //    contentView.frame = CGRectMake(0, destinaOffset + self.frame.size.height * (1 - alpha), contentView.frame.size.width, contentView.frame.size.height);
    //    bottomView.frame = CGRectMake(0, self.frame.size.height * (1 - alpha), bottomView.frame.size.width, bottomView.frame.size.height);
    
    topView.alpha = 1 - alpha;
    bottomView.alpha = alpha;
    
    
    _currentOffset = newOffset.y;
    NSLog(@"current offset: %f", _currentOffset);
    
}

@end
