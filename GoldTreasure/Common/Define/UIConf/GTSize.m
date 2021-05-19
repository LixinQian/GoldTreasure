//
//  GTSize.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/26.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTSize.h"


@implementation GTSize

+ (CGFloat) getScaleW:(CGFloat)w {
    
    return [GTSize getNetScale:GTUIDefine.SCREEN_WIDTH withScreen:375] * w;
}

+ (CGFloat) getScaleH:(CGFloat)h {
    
    return [GTSize getNetScale:GTUIDefine.SCREEN_HEIGHT withScreen:667] * h;
}

+ (CGFloat) getNetScale:(CGFloat)w1 withScreen:(CGFloat)w2{
    
    CGFloat scale = 0;
    scale = w1/w2;
    return scale;
}


///////// ******** 用作适配屏幕以及字体大小 ******* ///////
//- (CGFloat)autoScaleW:(CGFloat)w;
//
//- (CGFloat)autoScaleH:(CGFloat)h;
//#pragma mark - ScaleSize
//- (void)initAutoScaleSize{
//    
//    if (ScreenHeight==480) {
//        //4s
//        _autoSizeScaleW =ScreenWidth/375;
//        _autoSizeScaleH =ScreenHeight/667;
//    }else if(ScreenHeight==568) {
//        //5
//        _autoSizeScaleW =ScreenWidth/375;
//        _autoSizeScaleH =ScreenHeight/667;
//    }else if(ScreenHeight==667){
//        //6
//        _autoSizeScaleW =ScreenWidth/375;
//        _autoSizeScaleH =ScreenHeight/667;
//    }else if(ScreenHeight==736){
//        //6p
//        _autoSizeScaleW =ScreenWidth/375;
//        _autoSizeScaleH =ScreenHeight/667;
//    }else{
//        _autoSizeScaleW =1;
//        _autoSizeScaleH =1;
//    }
//    
//}
//
//- (CGFloat)autoScaleW:(CGFloat)w{
//    
//    return w * self.autoSizeScaleW;
//}
//
//- (CGFloat)autoScaleH:(CGFloat)h{
//    
//    return h * self.autoSizeScaleH;
//    
//}

@end
