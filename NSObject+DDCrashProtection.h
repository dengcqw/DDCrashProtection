//
//  NSObject+DDCrashProtection.h
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "DDCrashProtection.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DDCrashProtection)

+ (void)ddCrash_swizzleInstanceMethodWithClass:(Class)dclass originalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel;

+ (void)ddCrash_swizzleClassMethodWithClass:(Class)cls origSelector:(SEL)origSelector newSelector:(SEL)newSelector;

@end

NS_ASSUME_NONNULL_END
