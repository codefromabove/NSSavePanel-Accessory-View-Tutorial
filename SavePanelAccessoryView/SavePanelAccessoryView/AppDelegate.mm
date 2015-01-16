//
//  AppDelegate.m
//  SavePanelAccessoryView
//
//  Created by Philip Schneider on 1/16/15.
//  Copyright (c) 2015 Pixologic, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "AccessoryViewController.h"
#import "SaveFromCFunction.h"

@interface AppDelegate ()

@property (weak) IBOutlet     NSWindow                *window;
@property (nonatomic, strong) NSSavePanel             *savePanel;
@property (nonatomic, strong) AccessoryViewController *accessoryVC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
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


- (IBAction)launchDefaultSavePanel:(id)sender
{
    NSArray *fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"gif", @"png", nil];
    if (![self savePanel])
        [self setSavePanel:[NSSavePanel savePanel]];

    [[self savePanel] setAllowedFileTypes:fileTypesArray];
    [[self savePanel] setTitle:@"Save Image"];

    if ([[self savePanel] runModal] == NSFileHandlingPanelOKButton)
    {
        NSURL *file = [[self savePanel] URL];
        NSLog(@"Selected file: %@", file);
    }
}

- (IBAction)launchProgrammaticVersion:(id)sender
{
    NSArray *fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"gif", @"png", nil];
    if (![self savePanel])
        [self setSavePanel:[NSSavePanel savePanel]];

    [[self savePanel] setAllowedFileTypes:fileTypesArray];
    [[self savePanel] setTitle:@"Save Image"];

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
    [popupButton setAction:@selector(selectFormat:)];

    [accessoryView addSubview:label];
    [accessoryView addSubview:popupButton];

    [[self savePanel] setAccessoryView:accessoryView];

    if ([[self savePanel] runModal] == NSFileHandlingPanelOKButton)
    {
        NSURL *file = [[self savePanel] URL];
        NSLog(@"Selected file: %@", file);
    }
}
- (IBAction)launchNibVersion:(id)sender
{
    NSArray *fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"gif", @"png", nil];
    if (![self savePanel])
        [self setSavePanel:[NSSavePanel savePanel]];

    [[self savePanel] setAllowedFileTypes:fileTypesArray];
    [[self savePanel] setTitle:@"Save Image"];

    if (![self accessoryVC])
    {
        AccessoryViewController *aVC = [[AccessoryViewController alloc] initWithNibName:@"AccessoryViewController"
                                                                                 bundle:[NSBundle mainBundle]];
        [self setAccessoryVC:aVC];
        [[self accessoryVC] setSavePanel:[self savePanel]];
    }

    [[self savePanel] setAccessoryView:[[self accessoryVC] view]];

    if ([[self savePanel] runModal] == NSFileHandlingPanelOKButton)
    {
        NSURL *file = [[self savePanel] URL];
        NSLog(@"Selected file: %@", file);
    }
}

- (IBAction)launchFromCFunction:(id)sender
{
    std::string file = saveFile();
    NSLog(@"Selected file: %s", file.c_str());
}
@end