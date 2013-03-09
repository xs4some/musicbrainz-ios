//
//  ReleaseGroupService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import "BasicService.h"
#import "ReleaseGroup.h"

@interface ReleaseGroupService : BasicService

+(NSArray *)releaseGroupsWithArray:(NSArray *)array;
+(ReleaseGroup *)releaseGroupWithDictionary:(NSDictionary *)dictionary;

@end