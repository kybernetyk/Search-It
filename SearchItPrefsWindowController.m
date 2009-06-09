//
//  CollectItPrefsWindowController.m
//  Collect It
//
//  Created by Jaroslaw Szpilewski on 18.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchItPrefsWindowController.h"
#import <Sparkle/Sparkle.h>
#import "AppDelegate.h"
#import "Engines.h"

@implementation SearchItPrefsWindowController

- (void)setupToolbar
{
	[self addView:generalPrefsView label:@"General"];
	[self addView:advancedPrefsView label:@"Advanced"];
	[self addView:updatesPrefsView label:@"Updates"];

}

- (IBAction) menuBarIconSettingsChanged: (id) sender
{
	AppDelegate *appDelegate = (AppDelegate*)[NSApp delegate];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL addToMenubar = [userDefaults boolForKey:@"shouldAddToMenubar"];

	if (addToMenubar)
		[appDelegate createMenuBarIcon];
	else
		[appDelegate removeMenuBarIcon];
	
}

- (IBAction)showWindow:(id)sender 
{
	// This forces the resources in the nib to load.
	(void)[self window];

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *str = [userDefaults stringForKey:@"hotKeyTitle"];

	[keyWellButton setTitle:str];
	[keyWellButton setState: NSOffState];
	
	[self setupKeyBindingsView];
	
	[super showWindow:sender];
}

- (IBAction) checkForUpdates: (id) sender
{
	SUUpdater *upd = [SUUpdater sharedUpdater];
	[upd checkForUpdates:sender];
}


NSInteger alphabeticSort(id string1, id string2, void *reverse)

{
	
    if ((NSInteger *)reverse == NO) {
		
        return [string2 localizedCaseInsensitiveCompare:string1];
		
    }
	
    return [string1 localizedCaseInsensitiveCompare:string2];
	
}


- (NSMenu *)createMenuWithArray: (NSArray *) anArray
{
	NSMenu *menu = [[[NSMenu alloc] init] autorelease];
	[menu retain];
	
	//NSArray *arr = [NSArray arrayWithObjects:@"com",@"co.uk",@"de",@"fr",@"es",@"pl",nil];
#ifdef DEBUG
	NSLog(@"crateMenuWithArray: %@",anArray);
#endif

	NSArray *sortedArray = [anArray sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
	
	for (NSString *title in sortedArray)
	{
#ifdef DEBUG
		NSLog(@"adding: %@",title);
#endif
		
		NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
		[item setTitle: title];
		[item retain];
		
		[menu addItem: item];
	}
	
	return menu;
	
}

- (NSMenu *)createMenuForDefault: (NSString *) theDefaultName
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *engineName = [userDefaults stringForKey: theDefaultName];
	NSLog(@"createMenuForDefault: %@ - engineName: %@",theDefaultName, engineName);	
	NSArray *theArray = [[Engines sharedInstance] localeNamesForEngine: engineName];
	
	
	NSMenu *theMenu = [self createMenuWithArray: theArray];
	return theMenu;
}


- (void) setupKeyBindingsView
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	

	//Search Engines
	[enterEngineButton setMenu: [self createMenuWithArray:[[Engines sharedInstance] engineNames]]];
	[commandEnterEngineButton setMenu: [self createMenuWithArray:[[Engines sharedInstance] engineNames]]];
	[shiftEnterEngineButton setMenu: [self createMenuWithArray:[[Engines sharedInstance] engineNames]]];
	
	[enterEngineButton selectItemWithTitle: [userDefaults stringForKey:@"enterSearchEngine"]];
	[commandEnterEngineButton selectItemWithTitle: [userDefaults stringForKey:@"commandEnterSearchEngine"]];
 	[shiftEnterEngineButton selectItemWithTitle: [userDefaults stringForKey:@"shiftEnterSearchEngine"]];
	
	
	//Locales
	[enterLanguageButton setMenu:[self createMenuForDefault:@"enterSearchEngine"]];
	[commandEnterLanguageButton setMenu:[self createMenuForDefault:@"commandEnterSearchEngine"]];
	[shiftEnterLanguageButton setMenu:[self createMenuForDefault:@"shiftEnterSearchEngine"]];
		
	[enterLanguageButton selectItemWithTitle: [userDefaults stringForKey:@"enterLanguage"]];
	[commandEnterLanguageButton selectItemWithTitle: [userDefaults stringForKey:@"commandEnterLanguage"]];
 	[shiftEnterLanguageButton selectItemWithTitle: [userDefaults stringForKey:@"shiftEnterLanguage"]];

}

- (IBAction) aLangButtonChanged : (id) sender
{
	NSPopUpButton *pb = (NSPopUpButton *)sender;
	NSMenuItem *selectedItem = [pb selectedItem];

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	switch ([pb tag])
	{
		case ENTER_TAG:
			//NSLog(@"%@",[selectedItem title]);
			[userDefaults setValue: [selectedItem title] forKey:@"enterLanguage"];
			break;
		case COMMAND_ENTER_TAG:
			//NSLog(@"%@",[selectedItem title]);
			[userDefaults setValue:[selectedItem title] forKey:@"commandEnterLanguage"];
			break;
		case SHIFT_ENTER_TAG:
			//NSLog(@"%@",[selectedItem title]);
			[userDefaults setValue:[selectedItem title] forKey:@"shiftEnterLanguage"];
			break;			
		default:
			break;
	}
#ifdef DEBUG
	NSLog(@"a Lang Button Changed! %i", [pb tag]);
#endif
	
}

- (IBAction) enterMenuChanged : (id) sender
{
	NSPopUpButton *pb = (NSPopUpButton *)sender;
	NSMenuItem *selectedItem = [pb selectedItem];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
			
	
	NSMenu *newLangMenu = nil;
	NSPopUpButton *newLangButton = nil;
	if ([pb tag] == ENTER_TAG)
	{
		[userDefaults setValue: [selectedItem title] forKey:@"enterSearchEngine"];
		
		newLangButton = enterLanguageButton;
		newLangMenu = [self createMenuForDefault:@"enterSearchEngine"];
	}
	if ([pb tag] == COMMAND_ENTER_TAG)
	{
		[userDefaults setValue: [selectedItem title] forKey:@"commandEnterSearchEngine"];
		
		newLangButton = commandEnterLanguageButton;
		newLangMenu = [self createMenuForDefault:@"commandEnterSearchEngine"];
	}
	if ([pb tag] == SHIFT_ENTER_TAG)
	{
	[userDefaults setValue: [selectedItem title] forKey:@"shiftEnterSearchEngine"];
		
		newLangButton = shiftEnterLanguageButton;
		newLangMenu = [self createMenuForDefault:@"shiftEnterSearchEngine"];	
	}
	
	
	if (newLangMenu != nil && newLangButton != nil)
	{
		[newLangButton setMenu: newLangMenu];
		[newLangButton selectItemWithTitle: [[Engines sharedInstance] defaultLocalForEngine: [selectedItem title]]];
		[self aLangButtonChanged: newLangButton];
	}
}

- (IBAction) shouldAddToLoginItemsBoxChanged : (id) sender
{
#ifdef DEBUG
	NSLog(@"shouldAddToLoginItemsBoxChanged:");
#endif
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL addToLoginItems = [userDefaults boolForKey:@"shouldAddToLoginItems"];

	AppDelegate *appDelegate = (AppDelegate *)[NSApp delegate];
	
	if (addToLoginItems == YES)
		[appDelegate addAppToLoginItems];
	else
		[appDelegate removeAppFromLoginItems];
	
}

@end
