//
//  ViewController.m
//  RepresentaitionDemo
//
//  Created by QITMAC000904 on 2021/1/5.
//

#import "ViewController.h"
#import "ImageShowVC.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tabV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

#pragma mark --------Functions
//初始化
-(void)setup{
    
    self.navigationItem.title = @"图片缩略";
    self.tabV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tabV.delegate = self;
    self.tabV.dataSource = self;
    self.tabV.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    [self.view addSubview:self.tabV];
    
    //注册重用单元格
    [self.tabV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
}


#pragma mark --------UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return 5;
            break;
            
        default:
            return 2;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *TitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 kScreenWidth,
                                                                 20)];
    TitleLab.font = [UIFont systemFontOfSize:15];
    TitleLab.textAlignment = NSTextAlignmentCenter;
    TitleLab.numberOfLines = 0;
    
    switch (section) {
        case 0:
        {
            TitleLab.text = @"后台压缩（异步进行，不会卡住前台进程）";
        }
            break;
    
        case 1:
        {
            TitleLab.text = @"5种方法";
        }
            break;
            
        default:
            break;
    }
    
    return TitleLab;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动从重用队列中取得名称是MyCell的注册对象,如果没有，就会生成一个
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"后台压缩得到 目标大小的 图片Data";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"后台压缩得到 目标大小的 UIImage";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    // UIGraphicsBeginImageContextWithOptions
                    cell.textLabel.text = @"绘制到UIGraphicsImageRenderer";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"绘制到核心图形上下文";
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"使用图像I / O创建缩略图";
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"Lanczos使用核心映像进行重采样";
                }
                    break;
                case 4:
                {
                    cell.textLabel.text = @"使用vImage缩放图像";
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            cell.textLabel.text = @"Hello World";
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tabV deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [self.tabV cellForRowAtIndexPath:indexPath];

    switch (indexPath.section) {
        case 0:
        {
//            switch (indexPath.row) {
//                case 0:
//                {
//                    BackDataDemo *vc = [BackDataDemo new];
//                    vc.titleStr = cell.textLabel.text;
//
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                    break;
//                case 1:
//                {
//                    BackImageDemo *vc = [BackImageDemo new];
//                    vc.titleStr = cell.textLabel.text;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                    break;
//                default:
//                    break;
//            }
        }
            break;

        case 1:
        {
            ImageShowVC *showVC = [[ImageShowVC alloc] init];
            [self.navigationController pushViewController:showVC animated:YES];
        }
            break;

        default:
            break;
    }
}

@end
