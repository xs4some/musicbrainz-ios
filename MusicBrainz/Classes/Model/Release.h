//
//  Release
//  MusicBrainz
//
//  Created by bruinshe on 08-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface Release : NSObject

@property (nonatomic, retain) NSString *releaseId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *discCount;
@property (nonatomic, retain) NSString *format;
@property (nonatomic, retain) NSNumber *trackCount;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSNumber *score;

@end