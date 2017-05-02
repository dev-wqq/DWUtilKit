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
#import "UITextView+DWKit.h"
#import "DWUtilities.h"
#import "UITextView+DWKit.h"
#import <Masonry/Masonry.h>
#import "UIColor+DWKit.h"
#import "DWRichTextEditSelectColorView.h"

NSString *dw_convertAttributedStringToHtml(NSAttributedString *attStr){
    // http://stackoverflow.com/questions/5298188/how-do-i-convert-nsattributedstring-into-html-string
    NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSError *error;
    NSData *htmlData = [attStr dataFromRange:NSMakeRange(0, attStr.length) documentAttributes:documentAttributes error:&error];
    if (error) {
        NSLog(@"AttributedString to HTML Error:%@",error);
    }
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    return htmlString;
}

NSAttributedString *dw_convertHtmlToAttributedString(NSString *htmlString) {
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                         NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)};
    NSError *error;
    NSAttributedString *htmlAttributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:nil error:&error];
    if (error) {
        NSLog(@"HTML to AttributedString Error:%@",error);
    }
    return htmlAttributedString;
}

CGRect dw_addImageboundsFromSize(CGSize size, UITextView *textView) {
    CGFloat lineFragmentPadding = textView.textContainer.lineFragmentPadding;
    UIEdgeInsets textContainerInset = textView.textContainerInset;
    CGFloat margin = lineFragmentPadding + textContainerInset.left;
    CGFloat width = kScreenWidth - 2*margin;
    if (size.width > width) {
        return CGRectMake(0, 0, width, size.height*width / size.width);
    } else {
        return CGRectMake(0, 0, size.width, size.height);
    }
}


@interface DWRichTextEditViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) DWRichTextEditSelectColorView *selectColorView;

@end

@implementation DWRichTextEditViewController

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
     NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = dw_addImageboundsFromSize(image.size, _textView);
    
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    [mAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    [mAttrStr appendAttributedString:imageAttr];
    [mAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    _textView.attributedText = mAttrStr;
}

#pragma mark - Event Respond

- (void)doModifyFontBold:(UIButton *)sender {
    NSString *str = dw_convertAttributedStringToHtml(_textView.attributedText);
    NSLog(@"%@",str);
}

- (void)doModifyFontColor:(UIButton *)sender {
    CGPoint point = [[UIApplication sharedApplication].delegate.window convertPoint:CGPointMake(sender.centerX-5, sender.y-15) fromView:_textView.inputAccessoryView];
    if (!_selectColorView) {
        _selectColorView = [[DWRichTextEditSelectColorView alloc] initWithColors:[DWRichTextEditSelectColorView dw_richTextColors] atPoint:point selectBlock:^(DWRichTextEditSelectColorView *selectColorView, UIColor *selectColor) {
            
        }];
    }
    [_selectColorView dw_show:YES inView:[UIApplication sharedApplication].delegate.window];
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

    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.textColor = [UIColor dw_opaqueColorWithHexString:@"#b2b2b2"];
    _textView.textContainerInset = UIEdgeInsetsMake(20, 15, 20, 15);
    _textView.placeholder = @"请输入商品详情内容";
    [self.view addSubview:_textView];
   
    _textView.text = @"我是小屁孩";
    
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
