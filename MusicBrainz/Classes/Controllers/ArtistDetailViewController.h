//
//  ArtistDetailViewController.h
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 05-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@interface ArtistDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Artist *artist;



@end
