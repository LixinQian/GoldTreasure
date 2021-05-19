//
//  GTConfDefine.h
//  GoldTreasure
//
//  Created by ZZN on 2017/7/22.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#ifndef GTConfDefine_h
#define GTConfDefine_h


//客服电话
#define SERVICETELE @"400-9019588"
#define GTALIPAYSCHEME @"GoldTreasureTest"
// appstore 更新地址
#define APPSTOREUPDATEURL  @"itms-apps://itunes.apple.com/app/id1119078343"

//人脸识别 回调地址
#define IDCARDNOTIURL   [NSString stringWithFormat:@"%@/hjb/notice/getnotice",[GTNet getNetDomain]]
//人脸识别 回调地址
//#define IDCARDNOTIURL   [NSString stringWithFormat:@"%@/huajinbao/notice/getnotice",[GTNet getNetDomain]]
//用户注册协议
#define USERAGREEMENT   [NSString stringWithFormat:@"%@/mobile/register-protocol",APPOPAPICOMPENTSTR]
//借款合同
#define LOANCONTRACT    [NSString stringWithFormat:@"%@/mobile/third-party-loan-protocol",APPOPAPICOMPENTSTR]
//费率手续费
#define RATE            [NSString stringWithFormat:@"%@/mobile/rate",APPOPAPICOMPENTSTR]
//常见问题
#define FAQ             [NSString stringWithFormat:@"%@/mobile/faq",APPOPAPICOMPENTSTR] 

//@"http://101.37.163.179:86/mobile/faq"
//@"https://api.huajinbao.zhaofangroup.com/huajinbao/notice/getnotice"

// 有盾APIKey
//#define idCardAuthKey @"25ae8dc6-e7ca-42cc-9e3c-d830078245fd"
// 七鱼相关信息
//#if __DEV

//#define QYAPPKEY @"c05c6038b22634ba85663093642cca52"
//#define QYAPPNAME @"iOS花乐宝测试"


//#else

//#define QYAPPKEY @"c05c6038b22634ba85663093642cca52"
//#define QYAPPNAME @"iOS花乐宝生产"

//#endif






// 自定义宏
#ifdef __DEBUG

// 调试模式
#define GTLog(FORMAT, ...) fprintf(stderr,"%s LineNum:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define NSLog(FORMAT, ...) fprintf(stderr,"%s LineNum:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);



#else

// release模式

#define GTLog(FORMAT, ...) {}
#define NSlog(FORMAT, ...) {}

#endif

#endif /* GTConfDefine_h */
