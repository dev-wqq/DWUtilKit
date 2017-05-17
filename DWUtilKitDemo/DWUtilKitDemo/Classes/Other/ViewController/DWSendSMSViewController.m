//
//  DWSendSMSViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/16.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWSendSMSViewController.h"
#import "UIButton+DWKit.h"
#import <MessageUI/MessageUI.h>
#import <SDWebImage/UIImage+MultiFormat.h>

@interface DWSendSMSViewController () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UIButton *sendSMSButton;
@property (nonatomic, strong) MFMessageComposeViewController *messageVC;

@end

@implementation DWSendSMSViewController

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"取消发送");
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Construct UI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
    _sendSMSButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_sendSMSButton];
    [_sendSMSButton setTitle:@"发送短信" forState:UIControlStateNormal];
    [_sendSMSButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _sendSMSButton.center = CGPointMake(kScreenWidth/2, (kScreenHeight-kNavigationBarHeight)/2);
    _sendSMSButton.bounds = CGRectMake(0, 0, 80, 30);
    
    kWeakSelf(weakSelf);
    [_sendSMSButton dw_actionWithBlock:^(id sender) {
        [weakSelf displayMessageVC];
    } forControlEvents:UIControlEventTouchUpInside];

}

- (void)displayMessageVC {
    if (![MFMessageComposeViewController canSendText]) {
        NSLog(@"当前设备不支持发送短信");
        return ;
    }
    _messageVC = [[MFMessageComposeViewController alloc] init];
    _messageVC.messageComposeDelegate = self;
    // 短信内容
    _messageVC.body = @"message body";
    // 收件人
    _messageVC.recipients = @[@"test1",@"test2"];
    if ([MFMessageComposeViewController canSendSubject]) {
        // 短信主题
        _messageVC.subject = @"message subject";
    }
    if ([MFMessageComposeViewController canSendAttachments]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        [_messageVC addAttachmentURL:[NSURL fileURLWithPath:path] withAlternateFilename:@"Info.plist"];
        
        if ([MFMessageComposeViewController isSupportedAttachmentUTI:@"rich_text_edit_color.png"]) {
            UIImage *image = [UIImage imageNamed:@"rich_text_edit_color.png"];
            NSData *data = UIImagePNGRepresentation(image);
            [_messageVC addAttachmentData:data typeIdentifier:@"rich_text_edit_color" filename:@"rich_text_edit_color.png"];
        }
    }
    
//    [_messageVC disableUserAttachments];
    [self presentViewController:_messageVC animated:YES completion:nil];
}


@end
