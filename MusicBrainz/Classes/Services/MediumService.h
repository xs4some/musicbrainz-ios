//
//  MediumService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import "BasicService.h"
#import "Medium.h"

@interface MediumService : BasicService

+(NSArray *)mediaWithArray:(NSArray *)array;
+(Medium *)mediumWithDictionary:(NSDictionary *)dictionary;

@end