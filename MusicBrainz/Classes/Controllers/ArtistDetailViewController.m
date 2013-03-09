//
//  ArtistDetailViewController.m
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 05-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "ArtistDetailViewController.h"
#import "ArtistService.h"

@interface ArtistDetailViewController ()

@end

@implementation ArtistDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ArtistService *artistService = [[ArtistService alloc] initServiceWithArtistId:self.artist.artistId andParams:nil];

    [artistService getArtistOnCompletion:^(Artist *artist)
    {
        self.artist = artist;
        [self.tableView reloadData];
    } onError:^(NSError *error)
    {

    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ArtistDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.artist.name;
            break;

        default:
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
    }

    return cell;
}

@end
