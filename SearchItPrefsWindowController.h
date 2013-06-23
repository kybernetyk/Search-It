//
//  CollectItPrefsWindowController.h
//  Collect It
//
//  Created by Jaroslaw Szpilewski on 18.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBPrefsWindowController.h"
#import "KeyWellButton.h"

@interface SearchItPrefsWindowController : DBPrefsWindowController 
{
	IBOutlet NSView *generalPrefsView;
	IBOutlet NSView *advancedPrefsView;
	IBOutlet NSView *updatesPrefsView;	
	IBOutlet NSView *registrationPrefsView;
	IBOutlet NSView *registeredPrefsView;
	
	//registration prefs
	IBOutlet NSButton *finishRegistrationButton;
	IBOutlet NSTextField *licenceFilePathTextField;
	
	//advanced prefs
	IBOutlet KeyWellButton *keyWellButton;
	
	//genreal prefs
	IBOutlet NSMenu *googleLanguageMenu;
	IBOutlet NSMenu *wikipediaLanguageMenu;
	IBOutlet NSMenu *wowwokiLanguageMenu;
	IBOutlet NSMenu *openAsUrlLanguageMenu;

	IBOutlet NSPopUpButton *enterEngineButton;
	IBOutlet NSPopUpButton *commandEnterEngineButton;
	IBOutlet NSPopUpButton *shiftEnterEngineButton;
	
	
	
	IBOutlet NSPopUpButton *enterLanguageButton;
	IBOutlet NSPopUpButton *commandEnterLanguageButton;
	IBOutlet NSPopUpButton *shiftEnterLanguageButton;
	
}

- (IBAction) checkForUpdates: (id) sender;
- (IBAction) enterMenuChanged : (id) sender;
- (IBAction) aLangButtonChanged : (id) sender;

- (IBAction) menuBarIconSettingsChanged: (id) sender;

- (IBAction) shouldAddToLoginItemsBoxChanged : (id) sender;

- (void) setupKeyBindingsView;

- (NSMenu *)createMenuWithArray: (NSArray *) anArray;
- (NSMenu *)createMenuForDefault: (NSString *) theDefaultName;

@end
