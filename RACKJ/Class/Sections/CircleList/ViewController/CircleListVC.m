//
//  CircleListVC.m
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "CircleListVC.h"
#import "CircleListView.h"
#import "CircleListViewModel.h"

@interface CircleListVC ()

@property (nonatomic, strong) CircleListView *mainView;
@property (nonatomic, strong) CircleListViewModel *viewModel;

@end

@implementation CircleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - system
- (void)updateViewConstraints {
    
    WS(weakSelf)
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - private
- (void)addSubviews {
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.mainView];
}

- (void)bindViewModel {
    @weakify(self);
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        BaseVC *circleMainVC = [[BaseVC alloc] init];
        [self.navigationController pushViewController:circleMainVC animated:YES];
    }];
}

- (void)layoutNavigation {
    
    self.title = @"圈子列表";
}

#pragma mark - layzLoad

- (CircleListView *)mainView {
    if (!_mainView) {
        _mainView = [[CircleListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (CircleListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CircleListViewModel alloc] init];
    }
    return _viewModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
