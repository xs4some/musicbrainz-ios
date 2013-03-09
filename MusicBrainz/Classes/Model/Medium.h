//
//  Medium
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Medium : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *format;
@property (nonatomic, retain) NSNumber *trackCount;
@property (nonatomic, retain) NSArray *tracks;

@end