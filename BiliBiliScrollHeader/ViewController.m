//
//  ViewController.m
//  BiliBiliScrollHeader
//
//  Created by wossoneri on 16/1/9.
//  Copyright © 2016年 wossoneri. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

#import "MyScrollHeader.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    
    MyScrollHeader *header;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    header = [[MyScrollHeader alloc] init];
    header.headerScrollView = _tableView;
    
    [self.view addSubview:header];
    [self.view addSubview:_tableView];
    
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(HEADER_HEIGHT_BOTTOM);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    [self.view bringSubviewToFront:header];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    [cell.textLabel setText:[NSString stringWithFormat:@"test cell %ld", (long)indexPath.row]];
    return cell;
}




@end
