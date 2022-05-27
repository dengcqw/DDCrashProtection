//
//  NSMutableDictionary+DDCrashProtection.m
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import "NSMutableDictionary+DDCrashProtection.h"
#import "NSObject+DDCrashProtection.h"

@implementation NSMutableDictionary (DDCrashProtection)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dClass = NSClassFromString(@"__NSDictionaryM");
        [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(setObject:forKey:) swizzledSel:@selector(ddCrash_setObject:forKey:)];
        [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(setObject:forKeyedSubscript:) swizzledSel:@selector(ddCrash_setObject:forKeyedSubscript:)];
        [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(removeObjectForKey:) swizzledSel:@selector(ddCrash_removeObjectForKey:)];
    });
}

- (void)ddCrash_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    @try {
        [self ddCrash_setObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
    }
}

- (void)ddCrash_setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey {
    
    @try {
        [self ddCrash_setObject:anObject forKeyedSubscript:aKey];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
    }
}

- (void)ddCrash_removeObjectForKey:(id)aKey {
    
    @try {
        [self ddCrash_removeObjectForKey:aKey];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
    }
}

@end
