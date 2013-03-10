//
//  ReleaseService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import "BasicService.h"
#import "Release.h"
#import "Const.h"

@interface ReleaseService : BasicService

-(id)initServiceWithReleaseId:(NSString *)releaseId andParams:(NSMutableDictionary *)params;
-(void)getReleaseOnCompletion:(void(^)(Release *release))completionBlock onError:(MKNKErrorBlock)errorBlock;

+(NSArray *)releasesWithArray:(NSArray *)array;
+(Release *)releaseWithDictionary:(NSDictionary *)dictionary;

@end