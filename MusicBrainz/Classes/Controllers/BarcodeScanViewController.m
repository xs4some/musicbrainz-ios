//
// Created by bruinshe on 07-03-13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BarcodeScanViewController.h"

@interface BarcodeScanViewController()

-(IBAction)dismisModalScreen:(id)sender;

@end

@implementation BarcodeScanViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"BARCODE_TITLE", @"Scan barcode");
        self.tabBarItem.image = [UIImage imageNamed:@"magnifier"];
    }

    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(dismisModalScreen:)];

    self.navigationItem.leftBarButtonItem = cancelButton;


}

-(IBAction)dismisModalScreen:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end