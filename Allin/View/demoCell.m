//
//  demoCell.m
//  Allin
//
//  Created by 郑子炯 on 2023/1/30.
//

#import "demoCell.h"

@interface demoCell()

@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIImageView *imv;

@end

@implementation demoCell

-(instancetype)init{
    if(self = [super init]){
        [self setUpUI];
    }
    return  self;
}

-(void)setUpUI{
    CGFloat w = [UIScreen mainScreen].bounds.size.width-20;
    //self.imageView.backgroundColor = [UIColor blackColor];
    //self.imageView.frame = CGRectMake(0, 0, 400, 80);
    //[self.contentView addSubview:self.imageView];
//    self.imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 400, 80)];
//    self.imv.backgroundColor = [UIColor yellowColor];
//    [self.contentView addSubview:self.imv];
    //self.contentView.backgroundColor = [UIColor greenColor];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.contentView.backgroundColor = [UIColor blackColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
