//
//  NSObject+DDCrashProtection.m
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import "NSObject+DDCrashProtection.h"

@interface DDCrashProtectionProxy : NSObject
@end

@implementation DDCrashProtectionProxy
- (void)ddCrashProtection {
}
@end

@implementation NSObject (DDCrashProtection)

+ (void)ddCrash_swizzleClassMethodWithClass:(Class)cls origSelector:(SEL)origSelector newSelector:(SEL)newSelector
{
    if (!cls) return;
    Method originalMethod = class_getClassMethod(cls, origSelector);
    Method swizzledMethod = class_getClassMethod(cls, newSelector);
    
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    if (class_addMethod(metacls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(metacls,
                            newSelector,
                            class_replaceMethod(metacls,
                                                origSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}


+ (void)ddCrash_swizzleInstanceMethodWithClass:(Class)dclass originalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel; {
    
    Method originalMethod = class_getInstanceMethod(dclass, originalSel);
    Method swizzledMethod = class_getInstanceMethod(dclass, swizzledSel);
    
    if (!originalMethod || !swizzledMethod) {
        return;
    }
    
    BOOL didAddMethod =
    class_addMethod(dclass,
                    originalSel,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(dclass,
                            swizzledSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        [self ddCrash_swizzleInstanceMethodWithClass:[self class] originalSel:@selector(methodSignatureForSelector:) swizzledSel:@selector(ddCrash_methodSignatureForSelector:)];

        [self ddCrash_swizzleInstanceMethodWithClass:[self class] originalSel:@selector(forwardInvocation:) swizzledSel:@selector(ddCrash_forwardInvocation:)];
    });
}

// 允许我们将消息的接受者转发给其他对象
- (NSMethodSignature *)ddCrash_methodSignatureForSelector:(SEL)aSelector {
    
    NSMethodSignature *ms = [self ddCrash_methodSignatureForSelector:aSelector];
    
    IMP originIMP = class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:));
    IMP currentClassIMP = class_getMethodImplementation([self class], @selector(methodSignatureForSelector:));
    
    // 如果子类没有重载
    if (!ms && [self isWhiteList] && originIMP == currentClassIMP) {
        return [DDCrashProtectionProxy instanceMethodSignatureForSelector:@selector(ddCrashProtection)];
    } else {
        return ms;
    }
}

// 通过 forwardInvocation: 消息通知当前对象，给予此次消息发送最后一次寻找 IMP 的机会
- (void)ddCrash_forwardInvocation:(NSInvocation *)anInvocation {
    if ([self isWhiteList]) {
        @try {
            [self ddCrash_forwardInvocation:anInvocation];
        } @catch (NSException *exception) {
            [DDCrashProtection ddCrash_logCrashWithException:exception];
        } @finally {
        }
    } else {
        [self ddCrash_forwardInvocation:anInvocation];
    }
}

- (BOOL)isWhiteList {
    BOOL isWhiteList = NO;
    NSString *className = NSStringFromClass([self class]);
    if ([className isEqualToString:@"NSNull"] ||
        [className hasPrefix:@"DD"]) {
        isWhiteList = YES;
    }
    return isWhiteList;
}

@end
