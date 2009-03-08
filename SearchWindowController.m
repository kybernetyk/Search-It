//
//  SearchWindowController.m
//  Search It
//
//  Created by Jaroslaw Szpilewski on 21.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchWindowController.h"
#import "AppDelegate.h"
#import "Engines.h"

@implementation SearchWindowController

@synthesize searchField;

- (void)windowWillClose:(NSNotification *)notification
{
#ifdef DEBUG
	NSLog(@"Window will close!");
#endif
	
	AppDelegate *appDelegate = (AppDelegate*)[NSApp delegate];
	[appDelegate setIsWindowOpen: NO];
	[[appDelegate prefsWindowController] close];
	[NSApp hide: self];
}


- (void) executeSearchWithEngine: (NSString *) name andLocale: (NSString *) locale
{
#ifdef DEBUG
	NSLog(@"Search %@ with locale: %@!", name, locale);
#endif
	
	NSString *searchTerm = [searchField stringValue];
	
#ifdef DEBUG
	NSLog(@"searchTerm: %@",searchTerm);
#endif
	
	searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

#ifdef DEBUG
	NSLog(@"searchTerm: %@",searchTerm);
#endif
	
	NSLog(@"search URL: %@",[[Engines sharedInstance] searchURLForEngine: name andLocale: locale]);
	
	[[Engines sharedInstance] performSearchForKeyword: searchTerm withEngine: name andLocale: locale];
		
	AppDelegate *appDelegate = (AppDelegate*)[NSApp delegate];
	[appDelegate setLastSearchTerm: [searchField stringValue]];
}


- (IBAction) executeEnterSearch : (id) sender
{
#ifdef DEBUG
	NSLog(@"executing enter search");
#endif
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *engineName = [userDefaults stringForKey:@"enterSearchEngine"];
	NSString *localeName = [userDefaults stringForKey:@"enterLanguage"];

//	NSLog(@"search URL: %@",[[Engines sharedInstance] searchURLForEngine: engineName andLocale: localeName]);
	

	if ([[Engines sharedInstance] searchURLForEngine: engineName andLocale: localeName])
	{
		[self executeSearchWithEngine: engineName andLocale: localeName];
		
	}
	else
	{
		NSAlert *al = [NSAlert alertWithMessageText:@"Search It!" defaultButton:@"Ok" alternateButton: nil otherButton: nil informativeTextWithFormat:@"Warning - it seems like your settings are out of date.\r\rEither through an update of the search engine list or through an unknown error.\r\rThe search engine %@ has been reset to standard values (%@).\r\rPlease check the preferences window for new engine options!",engineName, [[Engines sharedInstance] defaultLocalForEngine: engineName]];
		[al runModal];
		[[NSUserDefaults standardUserDefaults] setObject:[[Engines sharedInstance] defaultLocalForEngine: engineName] forKey: @"enterLanguage"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self executeEnterSearch: self];		
	}
	
	//
	
	
}

- (IBAction) executeCommandEnterSearch : (id) sender
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *engineName = [userDefaults stringForKey:@"commandEnterSearchEngine"];
	NSString *localeName = [userDefaults stringForKey:@"commandEnterLanguage"];
	
	if ([[Engines sharedInstance] searchURLForEngine: engineName andLocale: localeName])
	{
		[self executeSearchWithEngine: engineName andLocale: localeName];
		
	}
	else
	{
		NSAlert *al = [NSAlert alertWithMessageText:@"Search It!" defaultButton:@"Ok" alternateButton: nil otherButton: nil informativeTextWithFormat:@"Warning - it seems like your settings are out of date.\r\rEither through an update of the search engine list or through an unknown error.\r\rThe search engine %@ has been reset to standard values (%@).\r\rPlease check the preferences window for new engine options!",engineName, [[Engines sharedInstance] defaultLocalForEngine: engineName]];
		[al runModal];
		[[NSUserDefaults standardUserDefaults] setObject:[[Engines sharedInstance] defaultLocalForEngine: engineName] forKey: @"commandEnterLanguage"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self executeCommandEnterSearch: self];
	}
	
	
	#ifdef DEBUG
	NSLog(@"executing command enter search");
#endif
}

- (IBAction) executeShiftEnterSearch : (id) sender
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *engineName = [userDefaults stringForKey:@"shiftEnterSearchEngine"];
	NSString *localeName = [userDefaults stringForKey:@"shiftEnterLanguage"];
	
	
	if ([[Engines sharedInstance] searchURLForEngine: engineName andLocale: localeName])
	{
		[self executeSearchWithEngine: engineName andLocale: localeName];
		
	}
	else
	{
		NSAlert *al = [NSAlert alertWithMessageText:@"Search It!" defaultButton:@"Ok" alternateButton: nil otherButton: nil informativeTextWithFormat:@"Warning - it seems like your settings are out of date.\r\rEither through an update of the search engine list or through an unknown error.\r\rThe search engine %@ has been reset to standard values (%@).\r\rPlease check the preferences window for new engine options!",engineName, [[Engines sharedInstance] defaultLocalForEngine: engineName]];
		[al runModal];
		[[NSUserDefaults standardUserDefaults] setObject:[[Engines sharedInstance] defaultLocalForEngine: engineName] forKey: @"shiftEnterLanguage"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self executeShiftEnterSearch: self];
	}
	
#ifdef DEBUG
	NSLog(@"executing shift enter search");
#endif
}


@end
