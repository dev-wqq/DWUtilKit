//
//  DWRichTextEditViewController.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/4/4.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DWRichTextEditViewController.h"
#import "DWRichTextEditToolBar.h"
#import "DWPermissionUtil.h"

@interface DWRichTextEditViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation DWRichTextEditViewController

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Event Respond

- (void)doModifyFontBold:(UIButton *)sender {

}

- (void)doModifyFontColor:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)doAddImage:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        if (![DWPermissionUtil dw_isPhotoLibraryAccess]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权使用相册" message:@"请在IOS“设置”－”隐私”－“相册”中打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }

        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        vc.delegate = self;
        vc.allowsEditing = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - Construct UI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
    self.title = @"富文本编辑器";
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    [self.view addSubview:_textView];
    
    DWRichTextEditToolBarConfig *fontBoldConfig = [[DWRichTextEditToolBarConfig alloc] initWithNormalImage:[UIImage imageNamed:@"font_bold_normal"] selectedImage:[UIImage imageNamed:@"font_bold_selected"]];
    DWRichTextEditToolBarConfig *fontColorConfig = [[DWRichTextEditToolBarConfig alloc] initWithNormalImage:[UIImage imageNamed:@"font_color_normal"] selectedImage:[UIImage imageNamed:@"font_color_normal"]];
    DWRichTextEditToolBarConfig *addImageConfig = [[DWRichTextEditToolBarConfig alloc] initWithNormalImage:[UIImage imageNamed:@"add_image_normal"] selectedImage:[UIImage imageNamed:@"add_image_normal"]];
    NSArray *items = @[fontBoldConfig,fontColorConfig,addImageConfig];
    
    _textView.inputAccessoryView = [[DWRichTextEditToolBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) items:items clickBlock:^(DWRichTextEditToolBar *toolBar, UIButton *sender) {
        if (sender.tag == toolBar.hideKeybordTag) {
            [_textView resignFirstResponder];
        } else if (sender.tag == [DWRichTextEditToolBar dw_baseTag] + 0) {
            [self doModifyFontBold:sender];
        } else if (sender.tag == [DWRichTextEditToolBar dw_baseTag] + 1) {
            [self doModifyFontColor:sender];
        } else if (sender.tag == [DWRichTextEditToolBar dw_baseTag] + 2) {
            [self doAddImage:sender];
        }
    }];
    [_textView becomeFirstResponder];
}


@end
