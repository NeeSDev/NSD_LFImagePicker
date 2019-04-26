//
//  ViewController.m
//  NSD_LFImagePicker
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019 NeeSDev. All rights reserved.
//

#import "ViewController.h"
#import "LFImagePickerController.h"

@interface LineObject :NSObject
@property(assign, nonatomic) CGPoint beginPoint;
@property(assign, nonatomic) CGPoint endPoint;
- (BOOL)lineHasCommonWithLine:(LineObject *)line;
@end

@implementation LineObject
- (BOOL)lineHasCommonWithLine:(LineObject *)line
{
    
    
    return YES;
}
@end

@interface ViewController ()<LFImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float width = 200.0f;
    float height = 400.f;
    float ratate = 5.0f * M_PI/180.0;
    UIView *view = [UIView new];
    view.frame = CGRectMake(100 , 100,  width, height);
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    
    UIView *view1 = [UIView new];
    view1.frame = CGRectMake(100 , 100,  width, height);
    view1.backgroundColor = [UIColor redColor];
    view1.alpha = 0.3;
    [self.view addSubview:view1];
    
    double length = sqrt(width * width + height * height);
    double scale = 0 ;
    if (width < height) {
        double angle = atan2 (width,height)+ratate ;
        double sinValue = sin(angle);
        scale =  (sinValue*length + 4)/width;
    }
    else
    {
        double angle = atan2 (height,width)+ratate;
        double sinValue = sin(angle);
        scale =  (sinValue*length + 4)/height;
    }

    view1.layer.transform = CATransform3DMakeRotation(ratate, 0, 0, 1);

    view1.transform = CGAffineTransformScale(view1.transform, scale, scale);


    NSLog(@"frame = %@",NSStringFromCGRect(view.frame));
    NSLog(@"frame = %@",NSStringFromCGRect(view1.frame));

    UIView *view2 = [UIView new];
    view2.frame = view1.frame;
    view2.backgroundColor = [UIColor blueColor];
    view2.alpha = 0.3;
    [self.view addSubview:view2];
    
    CGRect rect = view2.frame;

    float a = (rect.size.height - tan(ratate) * rect.size.width)/(1.0f/ tan(ratate) -  tan(ratate));
    float b = rect.size.width - a;
    float c = a / tan(ratate);
    float d = rect.size.height - c;

    
    UIView *point1 = [UIView new];
    point1.frame = CGRectMake(rect.origin.x - 2, rect.origin.y  + rect.size.height - d - 2, 4, 4);
    point1.backgroundColor = [UIColor redColor];
    [self.view addSubview:point1];
    
    UIView *point2 = [UIView new];
    point2.frame = CGRectMake(rect.origin.x + a - 2, rect.origin.y - 2, 4, 4);
    point2.backgroundColor = [UIColor redColor];
    [self.view addSubview:point2];
    
    UIView *point3 = [UIView new];
    point3.frame = CGRectMake(rect.origin.x + rect.size.width - 2, rect.origin.y + d - 2, 4, 4);
    point3.backgroundColor = [UIColor redColor];
    [self.view addSubview:point3];
    
    UIView *point4 = [UIView new];
    point4.frame = CGRectMake(rect.origin.x + b - 2, rect.origin.y +  + rect.size.height - 2, 4, 4);
    point4.backgroundColor = [UIColor redColor];
    [self.view addSubview:point4];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePicker.maxImagesCount = 1;
    imagePicker.allowPickingVideo = NO;
    //根据需求设置
    imagePicker.allowTakePicture = YES; //显示拍照按钮
    imagePicker.autoSavePhotoAlbum = NO;
    imagePicker.doneBtnTitleStr = @"确认"; //最终确定按钮名称
    imagePicker.imageCompressSize = 500*1024;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        imagePicker.syncAlbum = YES; /** 实时同步相册 */
    }
//    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - ========== 编辑图片回调 ====================
- (void)lf_imagePickerController:(LFImagePickerController *)picker didFinishPickingResult:(NSArray <LFResultObject /* <LFResultImage/LFResultVideo> */*> *)results
{
    if(results.count == 0)
        return;
    
    if(results.count > 1)
        return;
    
    if(results.count == 1 && [results[0] isKindOfClass:[LFResultImage class]])
    {
        LFResultImage * resultImage = (LFResultImage *)results[0];
    }
}


//- (BOOL)hasCommonPart:(CGPoint [])point check:(CGPoint [])checkPoint
//{
//
//}


@end
