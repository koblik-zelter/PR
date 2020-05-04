//
//  ViewController.m
//  MailApp
//
//  Created by Alex Koblik-Zelter on 4/12/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

#import "ViewController.h"
#import <MailCore/MailCore.h>
#import "MailDetailsViewController.h"
#import "SendMessageController.h"
@interface ViewController ()
@property (nonatomic, strong) NSArray *messageArray;
@property (nonatomic, strong) MCOIMAPSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageArray = [[NSArray alloc] init];
    [self setupSession];
    [self setupTableView];
    [self fetchData];
    // Do any additional setup after loading the view.
}

- (void) setupSession {
    self.session = [[MCOIMAPSession alloc] init];
    [self.session setHostname:@"imap.gmail.com"];
    [self.session setPort:993];
    [self.session setUsername:@"ackzackz@gmail.com"];
    [self.session setPassword:@"1999alex"];
    [self.session setConnectionType:MCOConnectionTypeTLS];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void) fetchData {
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders;
    NSString *folder = @"INBOX";
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];
    
    MCOIMAPFetchMessagesOperation *fetchOperation = [self.session fetchMessagesOperationWithFolder:folder requestKind:requestKind uids:uids];
    
    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
            return;
        }
        self.messageArray = [[NSArray alloc] initWithArray:fetchedMessages];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.messageArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell = nil;
    NSString *test = [[NSString alloc] init];
    MCOIMAPMessage * msg = [self.messageArray objectAtIndex:row];

    if ([tableView.tableColumns[0] isEqualTo: tableColumn]) {
        cell = [tableView makeViewWithIdentifier:@"EmailCellID" owner:nil];
        test = [[[msg header] from] mailbox];
    }
    else if ([tableView.tableColumns[1] isEqualTo: tableColumn]) {
        cell = [tableView makeViewWithIdentifier:@"MessageId" owner:nil];
        test = [[msg header] subject];
        if (!test) {
            test = @"No subject";
        }
    }
    else {
        cell = [tableView makeViewWithIdentifier:@"DateId" owner:nil];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        test = [formatter stringFromDate:[[msg header] date]];
    }

    cell.textField.stringValue = test;
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    MCOIMAPMessage * msg = [self.messageArray objectAtIndex:self.tableView.selectedRow];
    MCOIMAPFetchContentOperation * op = [self.session fetchMessageOperationWithFolder:@"INBOX" uid:[msg uid]];
    [op start:^(NSError * error, NSData * data) {
        if ([error code] != MCOErrorNone) {
            return;
        }
        NSAssert(data != nil, @"data != nil");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:data forKey:@"message"];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
            NSWindowController *vc = [storyBoard instantiateControllerWithIdentifier:@"secondWindowController"];
            [vc showWindow:self];

        });
    }];
}


- (IBAction)newMessage:(NSButton *)sender {
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
    NSWindowController *vc = [storyBoard instantiateControllerWithIdentifier:@"thirdWindowController"];

    [vc showWindow:self];
}


@end
