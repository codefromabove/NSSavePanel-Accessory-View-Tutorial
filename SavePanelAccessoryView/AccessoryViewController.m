//
//  AccessoryViewController.m
//  TestDialog
//
//  Created by Philip Schneider on 1/16/15.
//  Copyright (c) 2015-2019 Code From Above, LLC. All rights reserved.
//

#import "AccessoryViewController.h"

@interface AccessoryViewController ()

@end

@implementation AccessoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)selectFormat:(id)sender
{
    NSPopUpButton *button                 = (NSPopUpButton *)sender;
    NSInteger      selectedItemIndex      = [button indexOfSelectedItem];
    NSString      *nameFieldString        = [[self savePanel] nameFieldStringValue];
    NSString      *trimmedNameFieldString = [nameFieldString stringByDeletingPathExtension];
    NSString      *extension;

    if (selectedItemIndex == 0)
        extension = @"jpg";
    else if (selectedItemIndex == 1)
        extension = @"gif";
    else
        extension = @"png";

    NSString *nameFieldStringWithExt = [NSString stringWithFormat:@"%@.%@", trimmedNameFieldString, extension];
    [[self savePanel] setNameFieldStringValue:nameFieldStringWithExt];

    // If the Finder Preference "Show all filename extensions" is false or the
    // panel's extensionHidden property is YES (the default), then the
    // nameFieldStringValue will not include the extension we just changed/added.
    // So, in order to ensure that the panel's URL has the extension we've just
    // specified, the workaround is to restrict the allowed file types to only
    // the specified one.
    [[self savePanel] setAllowedFileTypes:@[extension]];
}
@end
