//
//  CircleListTableCell.m
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "CircleListTableCell.h"



@interface CircleListTableCell ()

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *articleImageView;

@property (nonatomic, strong) UILabel *articleLabel;

@property (nonatomic, strong) UIImageView *peopleImageView;

@property (nonatomic, strong) UILabel *peopleNumLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *lineImageView;

@end

@implementation CircleListTableCell

- (void)setupViews {
    
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.articleImageView];
    [self.contentView addSubview:self.articleLabel];
    [self.contentView addSubview:self.peopleImageView];
    [self.contentView addSubview:self.peopleNumLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.lineImageView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    
    CGFloat paddingEdge = 10;
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(paddingEdge);
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.headerImageView.mas_right).offset(paddingEdge);
        make.top.mas_equalTo(weakSelf.headerImageView);
        make.right.mas_equalTo(-paddingEdge);
        make.height.mas_equalTo(15);
    }];
    
    [self.articleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.nameLabel);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(paddingEdge);
    }];
    
    [self.articleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.articleImageView.mas_right).offset(3);
        make.size.mas_equalTo(CGSizeMake(50, 15));
        make.centerY.equalTo(weakSelf.articleImageView);
    }];
    
    [self.peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.articleLabel.mas_right).offset(paddingEdge);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(weakSelf.articleImageView);
    }];
    
    [self.peopleNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.peopleImageView.mas_right).offset(3);
        make.centerY.equalTo(weakSelf.peopleImageView);
        make.size.mas_equalTo(CGSizeMake(50, 15));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.articleImageView.mas_bottom).offset(paddingEdge);
        make.left.equalTo(weakSelf.articleImageView);
        make.right.mas_equalTo(-paddingEdge);
        make.height.mas_equalTo(15);
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1.0);
    }];
    [super updateConstraints];
}

- (void)setModel:(StaffModel *)model {
    
    if (!model) {
        return;
    }
    
    _model = model;
    
    NSString *imageStr=[NSString stringWithFormat:@"%@%@",@"http://114.119.8.68:7777/test/",model.photourl];
    
    [self.headerImageView sd_setImageWithURL:URL(imageStr) placeholderImage:ImageNamed(@"default.png")];
    
    self.headerImageView.backgroundColor=[UIColor redColor];
    
    self.nameLabel.text = model.nick;
    self.articleLabel.text =model.nameId.stringValue;
    self.peopleNumLabel.text = model.city;
    self.contentLabel.text = model.note;
}

#pragma mark - lazyLoad
- (UIImageView *)headerImageView {
    
    if (!_headerImageView) {
        
        _headerImageView = [[UIImageView alloc] init];
    }
    
    return _headerImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _nameLabel.font = SYSTEMFONT(14);
    }
    
    return _nameLabel;
}

- (UIImageView *)articleImageView {
    
    if (!_articleImageView) {
        
        _articleImageView = [[UIImageView alloc] init];
        _articleImageView.backgroundColor = red_color;
    }
    
    return _articleImageView;
}

- (UILabel *)articleLabel {
    
    if (!_articleLabel) {
        
        _articleLabel = [[UILabel alloc] init];
        _articleLabel.textColor = MAIN_LINE_COLOR;
        _articleLabel.font = SYSTEMFONT(12);
    }
    
    return _articleLabel;
}

- (UIImageView *)peopleImageView {
    
    if (!_peopleImageView) {
        
        _peopleImageView = [[UIImageView alloc] init];
        _peopleImageView.backgroundColor = red_color;
    }
    
    return _peopleImageView;
}

- (UILabel *)peopleNumLabel {
    
    if (!_peopleNumLabel) {
        
        _peopleNumLabel = [[UILabel alloc] init];
        _peopleNumLabel.textColor = MAIN_LINE_COLOR;
        _peopleNumLabel.font = SYSTEMFONT(12);
    }
    
    return _peopleNumLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _contentLabel.font = SYSTEMFONT(14);
    }
    
    return _contentLabel;
}

- (UIImageView *)lineImageView {
    
    if (!_lineImageView) {
        
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = MAIN_LINE_COLOR;
    }
    
    return _lineImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
