//
//  SendMessageController.m
//  MailApp
//
//  Created by Alex Koblik-Zelter on 4/12/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

#import "SendMessageController.h"
#import <MailCore/MailCore.h>
@interface SendMessageController () <NSAlertDelegate>
@property (weak) IBOutlet NSTextField *emailToLabel;
@property (unsafe_unretained) IBOutlet NSTextView *messageLabel;

@property (nonatomic, strong) MCOSMTPSession *smtpSession;
@end

@implementation SendMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSession];
}

- (void)setupSession {
    self.smtpSession = [[MCOSMTPSession alloc] init];
    self.smtpSession.hostname = @"smtp.gmail.com";
    self.smtpSession.port = 465;
    self.smtpSession.username = @"login@gmail.com";
    self.smtpSession.password = @"password";
    self.smtpSession.authType = MCOAuthTypeSASLPlain;
    self.smtpSession.connectionType = MCOConnectionTypeTLS;
}

- (IBAction)sendMessage:(NSButton *)sender {
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    MCOAddress *from = [MCOAddress addressWithDisplayName:@"My Name"
                                                  mailbox:@"ackzackz@gmail.com"];
    MCOAddress *to = [MCOAddress addressWithDisplayName:nil
                                                mailbox:self.emailToLabel.stringValue];
    [[builder header] setFrom:from];
    [[builder header] setTo:@[to]];
    [builder setHTMLBody:self.messageLabel.string];
    NSData * data = [builder data];

    MCOSMTPSendOperation *sendOperation =
       [self.smtpSession sendOperationWithData:data];
    [sendOperation start:^(NSError *error) {
        if(error) {
            [self showAlertWithMessageWithMessage:[error localizedDescription] andResult:NO];
        } else {
            [self showAlertWithMessageWithMessage:@"Send" andResult:YES];
        }
        
    }];
}

- (void) showAlertWithMessageWithMessage:(NSString *)message andResult: (BOOL) result {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:message];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
    if (result) {
        self.emailToLabel.stringValue = @"";
        self.messageLabel.string = @"";
    }
}
@end
