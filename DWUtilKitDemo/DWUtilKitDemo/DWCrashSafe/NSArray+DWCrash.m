//
//  NSArray+DWCrash.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/5/25.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSArray+DWCrash.h"
#import "NSObject+DWCrash.h"

@implementation NSArray (DWCrash)

#ifndef DWCrashSafeClose

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /**
         因为NSArray是一个类族，看似NSArray执行的方法其实是NSArray 类族中的私有类执行的
         我们能通过数组越界，看Xcode Crash log 
         CoreFoundation  0x000000010dc6927d -[__NSArray0 objectAtIndex:] + 93
         */
        // self.count == 0 调用的该私有类的API<空数组的情况>
        Class atIndexClass = NSClassFromString(@"__NSArray0");
        [atIndexClass dwcrash_swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(dwcrash_objectAtIndex:)];
        [atIndexClass release];
        
        // self.count >  0 调用的该私有类的API<一般数组的情况>
        Class atIndexClassI = NSClassFromString(@"__NSArrayI");
        [atIndexClassI dwcrash_swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(dwcrash_iObjectAtIndex:)];
        [atIndexClassI release];
       
        if ([[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."].firstObject integerValue] >= 10) {
            // 在iOS10 设备上数组中只有一个元素的时候使用的是该类
            Class atIndexClassSingle = NSClassFromString(@"__NSSingleObjectArrayI");
            [atIndexClassSingle dwcrash_swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(dwcrash_singleObjectAtIndex:)];
            [atIndexClassSingle release];
        }
        
        [self dwcrash_swizzleInstanceMethod:@selector(subarrayWithRange:) withMethod:@selector(dwcrash_subarrayWithRange:)];
    });
}

- (id)dwcrash_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self dwcrash_objectAtIndex:index];
}

- (id)dwcrash_iObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self dwcrash_iObjectAtIndex:index];
}

- (id)dwcrash_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self dwcrash_singleObjectAtIndex:index];
}

- (NSArray *)dwcrash_subarrayWithRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (length == 0) {
        return nil;
    }
    if (location >= self.count) {
        return nil;
    }
#ifdef DWCrashSubarrayReturnNil
    if (location + length > self.count) {
        return nil;
    }
#else
    if (location + length > self.count) {
        length = self.count - location;
    }
#endif
    return [self dwcrash_subarrayWithRange:NSMakeRange(location, length)];
}

#endif

@end

@implementation NSMutableArray (DWCrash)

#ifndef DWCrashSafeClose

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class atIndexClass = NSClassFromString(@"__NSArrayM");
        [atIndexClass dwcrash_swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(dwcrash_objectAtIndex:)];
        // addObject: implementation [__NSArrayM insertObject:atIndex:]
        [atIndexClass dwcrash_swizzleInstanceMethod:@selector(insertObject:atIndex:) withMethod:@selector(dwcrash_insertObject:atIndex:)];
        // removeObjectAtIndex: implementation [__NSArrayM removeObjectsInRange:]
        [atIndexClass dwcrash_swizzleInstanceMethod:@selector(removeObjectsInRange:) withMethod:@selector(dwcrash_removeObjectsInRange:)];
        [atIndexClass dwcrash_swizzleInstanceMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(dwcrash_replaceObjectAtIndex:withObject:)];
        [atIndexClass release];
    });
}

- (id)dwcrash_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self dwcrash_objectAtIndex:index];
}

- (void)dwcrash_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) {
        return;
    }
#ifdef DWCrashInsertBeyondBoundsLastValue
    if (index > self.count) {
        [self dwcrash_insertObject:anObject atIndex:self.count];
    }
#else
    if (index > self.count) {
        return;
    }
#endif
    [self dwcrash_insertObject:anObject atIndex:index];
}

- (void)dwcrash_removeObjectsInRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length   = range.length;
    if (length == 0) {
        return;
    }
    if (location >= self.count) {
        return;
    }
#ifdef DWCrashRemoveBeyondBoundsReturn
    if (location + length > self.count) {
        return;
    }
#else
    if (location + length > self.count) {
        length = self.count - location;
    }
#endif
    [self dwcrash_removeObjectsInRange:NSMakeRange(location, length)];
}

- (void)dwcrash_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count) {
        return;
    }
    if (!anObject) {
        return;
    }
    [self dwcrash_replaceObjectAtIndex:index withObject:anObject];
}
#endif

@end

