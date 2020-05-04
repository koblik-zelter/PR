//
//  MailDetailsViewController.m
//  MailApp
//
//  Created by Alex Koblik-Zelter on 4/12/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

#import "MailDetailsViewController.h"
#include <MailCore/MailCore.h>
@interface MailDetailsViewController ()

@end

@implementation MailDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MCOMessageParser * msg = [[MCOMessageParser alloc] initWithData: [defaults objectForKey:@"message"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:[[msg header] date]];
    
    self.fromLabel.stringValue = [[[msg header] from] mailbox];
    self.messageLabel.editable = false;
    self.messageLabel.string = [msg plainTextBodyRenderingAndStripWhitespace:NO];
    self.dateLabel.stringValue = stringFromDate;
    
    
    // Do view setup here.
}

@end
