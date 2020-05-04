//
//  MailDetailsViewController.h
//  MailApp
//
//  Created by Alex Koblik-Zelter on 4/12/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MailDetailsViewController : NSViewController
@property (weak) IBOutlet NSTextField *fromLabel;
@property (weak) IBOutlet NSTextField *dateLabel;
@property (unsafe_unretained) IBOutlet NSTextView *messageLabel;

@end

NS_ASSUME_NONNULL_END
