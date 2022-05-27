//
//  NSSet+DDCrashProtection.m
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import "NSSet+DDCrashProtection.h"
#import "NSObject+DDCrashProtection.h"
@implementation NSSet (DDCrashProtection)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ddCrash_swizzleClassMethodWithClass:[NSSet class] origSelector:@selector(setWithObject:)  newSelector:@selector(ddCrash_setWithObject:)];
    });
}

+ (instancetype)ddCrash_setWithObject:(id)object {
    if (object) {
        return [self ddCrash_setWithObject:object];
    }
    else {
        NSException *exp = [NSException exceptionWithName:@"DDCrashProtectionException" reason:@"NSSet ddCrash_setWithObject: nil" userInfo:nil];
        [DDCrashProtection ddCrash_logCrashWithException:exp];
        return nil;
    }
}

@end
