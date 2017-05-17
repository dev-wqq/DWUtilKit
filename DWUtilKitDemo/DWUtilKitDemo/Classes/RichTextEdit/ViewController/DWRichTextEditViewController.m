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
#import "NSAttributedString+DWKit.h"
#import "NSAttributedString+DWUtil.h"
#import "NSTextAttachment+DWUtil.h"

#define MAIN_TITLE_COLOR       @"#333333"  // 标题文字
#define TITLE_FONT             [UIFont systemFontOfSize:16.0f] // 正文，按钮文字

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

void dw_changFontOrColor(UITextView **textView, UIFont *font, UIColor *color) {
    NSRange r = (*textView).selectedRange;
    if (r.length > 0) {
        NSMutableAttributedString *attr = [(*textView).attributedText mutableCopy];
        [attr beginEditing];
        [attr enumerateAttributesInRange:r options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            
            if (font) {
                [attr addAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] range:range];
            }
            if (color) {
                [attr addAttributes:[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName] range:range];
            }
        }];
        [attr endEditing];
        (*textView).attributedText = attr;
        [(*textView) setSelectedRange:r];
    } else {
        NSMutableDictionary *typeAttrs = [(*textView).typingAttributes mutableCopy];
        if (font) {
            typeAttrs[NSFontAttributeName] = font;
        }
        if (color) {
            typeAttrs[NSForegroundColorAttributeName] = color;
        }
        (*textView).typingAttributes = typeAttrs;
    }
}

@interface DWRichTextEditViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) DWRichTextEditSelectColorView *selectColorView;
@property (nonatomic, copy)   NSString *originalHtml;

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
    [self dismissSelectColorView:YES];
    sender.selected = !sender.isSelected;
    UIFont *font;
    if (sender.selected) {
        font = [_textView.font dw_fontWithBold];
    } else {
        font = [_textView.font dw_fontWithNormal];
    }
    UITextView *textView = _textView;
    dw_changFontOrColor(&textView, font, nil);
}

- (void)doModifyFontColor:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        CGPoint point = [[UIApplication sharedApplication].delegate.window convertPoint:CGPointMake(sender.centerX-5, sender.y-5) fromView:_textView.inputAccessoryView];
        if (!_selectColorView) {
            kWeakSelf(weakSelf);
            _selectColorView = [[DWRichTextEditSelectColorView alloc] initWithColors:[DWRichTextEditSelectColorView dw_richTextColors] atPoint:point selectBlock:^(DWRichTextEditSelectColorView *selectColorView, UIColor *selectColor) {
                UITextView *textView = weakSelf.textView;
                dw_changFontOrColor(&textView, nil, selectColor);
            }];
            _selectColorView.startBlock = ^{
                sender.enabled = NO;
            };
            _selectColorView.completionBlock = ^{
                sender.enabled = YES;
            };
            [_selectColorView dw_setCurrentSelectedColor:_textView.textColor];
        }
        [_selectColorView dw_setCurrentSelectedColor:_textView.textColor];
        [_selectColorView dw_show:YES inView:[UIApplication sharedApplication].delegate.window];
    } else {
        [self dismissSelectColorView:YES];
    }}

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initData {
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:@""];
    [textAttr dw_setForegroundColor:[UIColor dw_opaqueColorWithHexString:MAIN_TITLE_COLOR]];
    
    if (!_htmlString || _htmlString.length == 0) {
        [textAttr dw_setFont:TITLE_FONT];
        [textAttr dw_setLineSpacing:5];
        _textView.attributedText = textAttr;
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSMutableArray *array = [NSMutableArray array];
        [regex enumerateMatchesInString:_htmlString
                                options:0
                                  range:NSMakeRange(0, [_htmlString length])
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 NSString *img = [_htmlString substringWithRange:[result rangeAtIndex:2]];
                                 NSLog(@"original img src:%@",img);
                                 [array addObject:img];
                             }];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAttributedString *attributedString = dw_convertHtmlToAttributedString(_htmlString);
            NSMutableArray *mTextAtt = [NSMutableArray array];
            [attributedString enumerateAttributesInRange:attributedString.dw_rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                NSTextAttachment *textAttachment = attrs[NSAttachmentAttributeName];
                if (textAttachment) {
                    [mTextAtt addObject:textAttachment];
                }
            }];
            
            [mTextAtt enumerateObjectsUsingBlock:^(NSTextAttachment *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < array.count) {
                    obj.dw_imageSrc = array[idx];
                    // 这里的NSTextAttachment的image需要从fileWrapper中获取，不能直接使用image,此时为nil
                    UIImage *image = [UIImage imageWithData:obj.fileWrapper.regularFileContents];
                    obj.bounds = dw_addImageboundsFromSize(image.size, _textView);
                }
            }];
            [textAttr appendAttributedString:attributedString];
            [textAttr dw_setFont:TITLE_FONT];
            // 这里设置为系统默认的段落风格，存在格式问题
            [textAttr dw_setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
            [textAttr dw_setLineSpacing:5];
            _originalHtml = [textAttr dw_htmlString];
            _textView.attributedText = textAttr;
        });
    });
}

- (BOOL)isModifyContext {
    NSString *str = [_textView.attributedText dw_htmlString];
    if ((!str && !_originalHtml) || [str isEqualToString:_originalHtml]) {
        return NO;
    }
    return YES;
}

- (void)dismissSelectColorView:(BOOL)animated {
    if (_selectColorView) {
        [_selectColorView dw_dismiss:animated];
    }
}

#pragma mark - NSNotificationCenter

- (void)didTextViewTextDidChangeNotification:(NSNotification *)notifiy {
    [self dismissSelectColorView:YES];
}

#pragma mark - KVO

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _textView.height = kScreenHeight-kNavigationBarHeight-keyboardSize.height;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _textView.height = kScreenHeight-kNavigationBarHeight;
}



@end
