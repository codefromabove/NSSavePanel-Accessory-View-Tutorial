//
//  SaveFromCFunction.cpp
//  TestDialog
//
//  Created by Philip Schneider on 1/16/15.
//  Copyright (c) 2015 Code From Above, LLC. All rights reserved.
//

#include "SaveFromCFunction.h"
#import <AppKit/NSSavePanel.h>
#import <AppKit/NSPopUpButton.h>
#import <AppKit/NSTextField.h>

@interface PopUpButtonHandler : NSObject

@property (nonatomic, weak) NSSavePanel *savePanel;

- (instancetype)initWithPanel:(NSSavePanel *)panel;
- (void)selectFormat:(id)sender;

@end

@implementation PopUpButtonHandler

- (instancetype)initWithPanel:(NSSavePanel *)panel
{
    self = [super init];
    if (self)
    {
        _savePanel = panel;
    }

    return self;
}

- (void)selectFormat:(id)sender
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
}

@end

static PopUpButtonHandler *popUpButtonHandler;
static NSSavePanel        *savePanel;

std::string saveFile()
{
    NSArray *fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"gif", @"png", nil];

    if (!savePanel)
        savePanel = [NSSavePanel savePanel];

    if (!popUpButtonHandler)
        popUpButtonHandler = [[PopUpButtonHandler alloc] initWithPanel:savePanel];

    [savePanel setAllowedFileTypes:fileTypesArray];
    [savePanel setTitle:@"Save Image"];

    NSArray *buttonItems   = [NSArray arrayWithObjects:@"JPEG (*.jpg)", @"GIF (*.gif)", @"PNG (*.png)", nil];
    NSView  *accessoryView = [[NSView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 200, 32.0)];

    NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 60, 22)];
    [label setEditable:NO];
    [label setStringValue:@"Format:"];
    [label setBordered:NO];
    [label setBezeled:NO];
    [label setDrawsBackground:NO];

    NSPopUpButton *popupButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(50.0, 2, 140, 22.0) pullsDown:NO];
    [popupButton addItemsWithTitles:buttonItems];
    [popupButton setTarget:popUpButtonHandler];
    [popupButton setAction:@selector(selectFormat:)];
    [popupButton setAutoenablesItems:YES];

    [accessoryView addSubview:label];
    [accessoryView addSubview:popupButton];

    [savePanel setAccessoryView:accessoryView];

    if ([savePanel runModal] == NSFileHandlingPanelOKButton)
    {
        NSURL *URL = [savePanel URL];
        if (URL)
        {
            NSString *path = [URL path];
            return std::string([path UTF8String]);
        }
    }

    return std::string();
}

