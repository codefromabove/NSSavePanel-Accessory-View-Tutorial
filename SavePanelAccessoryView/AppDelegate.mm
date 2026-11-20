//
//  AppDelegate.mm
//  SavePanelAccessoryView
//
//  Created by Philip Schneider on 1/16/15.
//  Copyright (c) 2015-2019 Code From Above, LLC All rights reserved.
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

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

// Creates the shared panel on first use and resets the settings common to
// every variant. The panel is reused, so any accessory view left over from a
// previous variant is removed here.
- (NSSavePanel *)preparedSavePanel
{
    if (![self savePanel])
        [self setSavePanel:[NSSavePanel savePanel]];

    [[self savePanel] setAllowedContentTypes:[AccessoryViewController allContentTypes]];
    [[self savePanel] setTitle:@"Save Image"];
    [[self savePanel] setAccessoryView:nil];
    [[self savePanel] setAllowsOtherFileTypes:NO];

    return [self savePanel];
}

- (void)runSavePanel
{
    if ([[self savePanel] runModal] == NSModalResponseOK)
    {
        NSURL *file = [[self savePanel] URL];
        NSLog(@"Selected file: %@", file);
    }
}

- (IBAction)selectFormat:(id)sender
{
    [AccessoryViewController applyFormatAtIndex:[(NSPopUpButton *)sender indexOfSelectedItem]
                                    toSavePanel:[self savePanel]];
}

- (IBAction)launchDefaultSavePanel:(id)sender
{
    [self preparedSavePanel];
    [self runSavePanel];
}

- (IBAction)launchProgrammaticVersion:(id)sender
{
    NSSavePanel *panel = [self preparedSavePanel];

    NSTextField *label = [NSTextField labelWithString:@"Format:"];

    NSPopUpButton *popupButton = [[NSPopUpButton alloc] initWithFrame:NSZeroRect pullsDown:NO];
    [popupButton addItemsWithTitles:[AccessoryViewController formatTitles]];
    [popupButton setTarget:self];
    [popupButton setAction:@selector(selectFormat:)];

    NSStackView *accessoryView = [NSStackView stackViewWithViews:@[label, popupButton]];
    [accessoryView setEdgeInsets:NSEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)];
    [accessoryView setFrameSize:[accessoryView fittingSize]];

    [panel setAccessoryView:accessoryView];

    // Make the panel match the popup's initial selection.
    [self selectFormat:popupButton];

    [self runSavePanel];
}

- (IBAction)launchNibVersion:(id)sender
{
    NSSavePanel *panel = [self preparedSavePanel];

    if (![self accessoryVC])
    {
        AccessoryViewController *aVC = [[AccessoryViewController alloc] initWithNibName:@"AccessoryViewController"
                                                                                 bundle:[NSBundle mainBundle]];
        [aVC setSavePanel:panel];
        [self setAccessoryVC:aVC];
    }

    [panel setAccessoryView:[[self accessoryVC] view]];

    // The view controller is reused, so its popup may still show the format
    // chosen last time. Make the panel match it.
    [[self accessoryVC] applySelectedFormat];

    [self runSavePanel];
}

- (IBAction)launchFromCFunctionDefault:(id)sender
{
    std::string file = saveFileDefault();
    NSLog(@"Selected file: %s", file.c_str());
}

- (IBAction)launchFromCFunctionProgrammaticVersion:(id)sender
{
    std::string file = saveFileProgrammaticVersion();
    NSLog(@"Selected file: %s", file.c_str());
}

- (IBAction)launchFromCFunctionNibVersion:(id)sender
{
    std::string file = saveFileNibVersion();
    NSLog(@"Selected file: %s", file.c_str());
}

@end
