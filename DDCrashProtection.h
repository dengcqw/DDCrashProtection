//
//  DDCrashProtection.h
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCrashProtection : NSObject

+ (void)ddCrash_logCrashWithException:(NSException *)exception;

@end

NS_ASSUME_NONNULL_END
