//
//  WorkService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "BasicService.h"
#import "Work.h"

@interface WorkService : BasicService

+(NSArray *)worksWithArray:(NSArray *)array;
+(Work *)workWithDictionary:(NSDictionary *)dictionary;

@end