//
//  ViewController.h
//  MailApp
//
//  Created by Alex Koblik-Zelter on 4/12/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;

@end

