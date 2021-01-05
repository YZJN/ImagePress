//
//  ImageShowVC.m
//  RepresentaitionDemo
//
//  Created by QITMAC000904 on 2021/1/5.
//

#import "ImageShowVC.h"
#import "ImageCompressTool.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kViewMaxY(v)  (v.frame.origin.y + v.frame.size.height)
@interface ImageShowVC ()

@end

@implementation ImageShowVC{
    UIButton *selectedBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}


#pragma mark --------LazyLoad
- (UIImageView *)newImgView {
    if (!_newImgView) {
        _newImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight/2, kScreenWidth, (kScreenHeight-30)/2)];
        _newImgView.layer.masksToBounds = YES;
        _newImgView.contentMode = UIViewContentModeScaleAspectFit;
        _newImgView.backgroundColor = [UIColor colorWithRed:1.000 green:0.318 blue:0.333 alpha:1.000];
    }
    return _newImgView;
}

-(CGSize)NewIMGSize{
    return CGSizeMake(self.newImgView.frame.size.width*2,
                      self.newImgView.frame.size.height*2);
}
-(UIImage *)oldIMG{
    _oldIMG = (_oldIMG)?_oldIMG:[UIImage imageNamed:@"VIIRS_3Feb2012_lrg.jpg"];
    return _oldIMG;
}

#pragma mark -- 私有方法
//初始化
-(void)setup{
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:self.newImgView];
    [self addButton:self.view];
}

- (void)addButton:(UIView *)view{
    NSArray *arr = @[@"1",@"2",@"3",@"4",@"5"];
    CGFloat w =0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 100;//用来控制button距离父视图的高
    for (int i =0; i < arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.layer.cornerRadius=5;
        button.layer.masksToBounds =YES;
        button.tag =  i+1;
        //默认选中第一个
        if (button.tag==1) {
            button.backgroundColor = [UIColor redColor];
            selectedBtn=button;
        }else{
            button.backgroundColor = [UIColor whiteColor];
        }
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000]forState:UIControlStateNormal];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
         CGFloat length = [arr[i] boundingRectWithSize:CGSizeMake(320, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        [button setTitle:[NSString stringWithFormat:@"第%@种",arr[i]]forState:UIControlStateNormal];
        length=45;//此行固定宽度取消调此行恢复自动计算Tittle长度
        button.frame =CGRectMake(10 + w, h, length +15 , 50);
        //当button的位置超出屏幕边缘时换行 320只是button所在父视图的宽度
        if(10 + w + length +15 > view.frame.size.width){
            w = 0;//换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame =CGRectMake(15 + w, h, length +15, 50);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [view addSubview:button];
    }
}
 
//点击事件
- (void)handleClick:(UIButton *)btn{
  
//选中变红色 其他按钮变为白色
    if (selectedBtn) {
        selectedBtn.backgroundColor = [UIColor whiteColor];
    }
    selectedBtn = btn;
    selectedBtn.backgroundColor = [UIColor redColor];
    NSData *oldIMGData = UIImageJPEGRepresentation(self.oldIMG,1);
    switch (btn.tag) {
        case 1:
        {
        
            UIImage *newIMG = [ImageCompressTool ResizeImageWithImage:self.oldIMG
                                                              andSize:CGSizeMake(self.newImgView.frame.size.width*2, self.newImgView.frame.size.height*2)
                                                                  Scale:NO];
            
            NSData *newIMGData = UIImageJPEGRepresentation(newIMG,1);
            self.newImgView.image = newIMG;
            NSLog(@"只缩不压得到的UIImage的大小： %lu kb  -------原始图片为: %lu kb",[newIMGData length]/1024,[oldIMGData length]/1024);
        }
          
            break;
        case 2:
        {
        
            UIImage *newIMG = [ImageCompressTool ResizedImageWithImage:self.oldIMG size:CGSizeMake(self.newImgView.frame.size.width*2, self.newImgView.frame.size.height*2)];
            
            NSData *newIMGData = UIImageJPEGRepresentation(newIMG,1);
            self.newImgView.image = newIMG;
            
            NSLog(@"Core Graphics的大小： %lu kb  -------原始图片为: %lu kb",[newIMGData length]/1024,[oldIMGData length]/1024);
        }
          
            break;
        case 3:
        {
            NSData *imageData = UIImageJPEGRepresentation(self.oldIMG,1.0f);
            UIImage *newIMG = [ImageCompressTool SeacalImageWithData:imageData withSize:CGSizeMake(self.newImgView.frame.size.width*2,self.newImgView.frame.size.height*2) scale:1 orientation:UIImageOrientationUp];
            
            NSData *newIMGData = UIImageJPEGRepresentation(newIMG,1);
            self.newImgView.image = newIMG;
            
            NSLog(@"Image I/O的大小： %lu kb  -------原始图片为: %lu kb",[newIMGData length]/1024,[oldIMGData length]/1024);
        }
          
            break;
        case 4:
        {
        
            UIImage *newIMG = [ImageCompressTool CoreImageChangeImageWithImage:self.oldIMG size:CGSizeMake(self.newImgView.frame.size.width*2,self.newImgView.frame.size.height*2) scale:1];
            
            NSData *newIMGData = UIImageJPEGRepresentation(newIMG,1);
            self.newImgView.image = newIMG;
            
            NSLog(@"滤镜的大小： %lu kb  -------原始图片为: %lu kb",[newIMGData length]/1024,[oldIMGData length]/1024);
        }
          
            break;
        case 5:
        {
        
            UIImage *newIMG = [ImageCompressTool AccelerateChangeImage:self.oldIMG size:CGSizeMake(self.newImgView.frame.size.width*2,self.newImgView.frame.size.height*2)];
            
            NSData *newIMGData = UIImageJPEGRepresentation(newIMG,1);
            self.newImgView.image = newIMG;
            
            NSLog(@"VImage的大小： %lu kb  -------原始图片为: %lu kb",[newIMGData length]/1024,[oldIMGData length]/1024);
        }
          
            break;
        default:
            break;
    }
}
 
@end
