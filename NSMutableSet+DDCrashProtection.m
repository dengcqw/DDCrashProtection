//
//  NSMutableSet+DDCrashProtection.m
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import "NSMutableSet+DDCrashProtection.h"
#import "NSObject+DDCrashProtection.h"

@implementation NSMutableSet (DDCrashProtection)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dClass = NSClassFromString(@"__NSSetM");
        if (dClass) {
            [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(addObject:) swizzledSel:@selector(ddCrash_addObject:)];
            [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(removeObject:) swizzledSel:@selector(ddCrash_removeObject:)];
        }
    });
}

- (void)ddCrash_addObject:(id)object {
    if (object) {
        [self ddCrash_addObject:object];
    }
    else {
        NSAssert(NO, @"NSMutableSet ddCrash_addObject: nil");
        NSException *exp = [NSException exceptionWithName:@"DDCrashProtectionException" reason:@"NSMutableSet ddCrash_addObject: nil" userInfo:nil];
        [DDCrashProtection ddCrash_logCrashWithException:exp];
    }
}

- (void)ddCrash_removeObject:(id)object {
    if (object) {
        [self ddCrash_removeObject:object];
    }
    else {
        NSAssert(NO, @"NSMutableSet ddCrash_removeObject: nil");
        NSException *exp = [NSException exceptionWithName:@"DDCrashProtectionException" reason:@"NSMutableSet ddCrash_removeObject: nil" userInfo:nil];
        [DDCrashProtection ddCrash_logCrashWithException:exp];
    }
}

@end
