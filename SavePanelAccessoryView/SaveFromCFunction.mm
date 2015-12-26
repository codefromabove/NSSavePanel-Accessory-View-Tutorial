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
#import "AccessoryViewController.h"

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

    // If the Finder Preference "Show all filename extensions" is false or asdf, then
    // the nameFieldStringValue will not include the extension we just changed/added.
    // So, in order to ensure that the panel's URL has the extension we've just
    // specified, the workaround is to restrict the allowed file types to only
    // the specified one.
    [[self savePanel] setAllowedFileTypes:@[extension]];
}

@end

static NSSavePanel *savePanel;

std::string saveFileDefault()
{
    NSArray *fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"gif", @"png", nil];

    if (!savePanel)
        savePanel = [NSSavePanel savePanel];

    [savePanel setAllowedFileTypes:fileTypesArray];
    [savePanel setTitle:@"Save Image"];

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

static PopUpButtonHandler *popUpButtonHandler;

std::string saveFileProgrammaticVersion()
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

static AccessoryViewController *accessoryVC;

std::string saveFileNibVersion()
{
    NSArray *fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"gif", @"png", nil];

    if (!savePanel)
        savePanel = [NSSavePanel savePanel];

    if (!accessoryVC)
    {
        accessoryVC = [[AccessoryViewController alloc] initWithNibName:@"AccessoryViewController"
                                                                bundle:[NSBundle mainBundle]];
        [accessoryVC setSavePanel:savePanel];
    }

    [savePanel setAllowedFileTypes:fileTypesArray];
    [savePanel setTitle:@"Save Image"];


    [savePanel setAccessoryView:[accessoryVC view]];

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


