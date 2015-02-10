//
//  NSString+Emojize.h
//  NSStringEmojize
//
//  Modified by Anton Shebukov on 30/01/15
//  to support Facebook emoticons.
//  Copyright (c) 2015 Feedback Italia S.p.A. All rights reserved.
//
//  Created by Jonathan Beilin on 11/05/12.
//  Copyright (c) 2012-2014 DIY. All rights reserved.
//
//  Inspired by https://github.com/larsschwegmann/Emoticonizer

#import <Foundation/Foundation.h>

@interface NSString (Emojize)

- (NSString *)emojizedString;
+ (NSString *)emojizedStringWithString:(NSString *)text;
+ (NSDictionary *)emojiAliases;
+ (NSDictionary *)emojiEmoticons;

@end
