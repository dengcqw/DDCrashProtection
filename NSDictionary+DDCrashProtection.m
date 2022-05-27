//
//  NSDictionary+DDCrashProtection.m
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import "NSDictionary+DDCrashProtection.h"
#import "NSObject+DDCrashProtection.h"

@implementation NSDictionary (DDCrashProtection)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // designated init
        [self ddCrash_swizzleInstanceMethodWithClass:objc_getClass("__NSPlaceholderDictionary") originalSel:@selector(initWithObjects:forKeys:count:) swizzledSel:@selector(ddCrash_initWithObjects:forKeys:count:)];
    });
}

- (instancetype)ddCrash_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self ddCrash_initWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        
        [DDCrashProtection ddCrash_logCrashWithException:exception];
        
        NSUInteger index = 0;
        id   newObjects[cnt];
        id   newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self ddCrash_initWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}

@end
