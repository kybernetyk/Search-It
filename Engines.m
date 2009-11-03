//
//  Engines.m
//  Search It
//
//  Created by Jaroslaw Szpilewski on 01.12.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Engines.h"
#import "AppDelegate.h"
#import "iTunes.h"

@implementation Engines
@synthesize engines;

static Engines *sharedEngines = nil;

+(Engines*)sharedInstance 
{
    @synchronized(self) 
	{
        if (sharedEngines == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedEngines;
}


+(id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) 
	{
        if (sharedEngines == nil) 
		{
            sharedEngines = [super allocWithZone:zone];
            return sharedEngines;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


-(void)dealloc 
{
    [engines release];
	
	[super dealloc];
}

-(id)copyWithZone:(NSZone *)zone 
{
    return self;
}


-(id)retain 
{
    return self;
}


-(unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be release
}


-(void)release 
{
    //do nothing    
}


-(id)autorelease 
{
    return self;    
}


-(id)init 
{
    self = [super init];
    sharedEngines = self;
	
    //initialize here
	[self loadEngines];
	
    return self;
}


- (void) loadEngines
{
	NSBundle *thisBundle = [NSBundle mainBundle];
	NSString *listPath = [thisBundle pathForResource:@"engines" ofType:@"plist"];
#ifdef DEBUG
	NSLog(@"loading Engines from: %@",listPath);
#endif
	
	//NSDictionary *root = [[NSDictionary alloc] initWithContentsOfFile:listPath];
	engines = [[NSDictionary alloc] initWithContentsOfFile:listPath];
	
	/*for (id key in dictionary)
	 {
	 
	 }*/
	
#ifdef DEBUG
	for (NSString *engine_key in engines)
	{
		//NSLog(@"key: %@, value: %@", engine, [root objectForKey:engine]);
		NSDictionary *engine = [engines objectForKey: engine_key];
		
		NSLog(@"------");
		NSLog(@"Engine: %@",engine_key);
		NSLog(@"-- name: %@",[engine objectForKey: @"name"]);
		NSLog(@"-- url: %@",[engine objectForKey: @"url"]);
		NSLog(@"-- locales:");
		
		int i = 1;
		for (NSString *locale_key in [engine objectForKey:@"locales"])
		{
			NSString *locale = [[engine objectForKey:@"locales"] objectForKey: locale_key];
			
			NSLog(@"---- locale #%i: %@ with URL: %@",i, locale_key, locale);
			i++;
		}
		NSLog(@"------");		
	}
#endif	
	
	
	
	/*	NSArray * levels = [root objectForKey:@"levels"];
	 NSString * title = [root objectForKey:@"title"];
	 int version - [[root objectForKey:@"version"] intValue];*/
	//	NSLog(@"%@",root);
	
	//[root release];
	
}

- (NSArray *) engineNames
{
	NSMutableArray *arr = [NSMutableArray array];
	
	for (NSString *engine_key in engines)
	{
		//NSLog(engine_key);
		[arr addObject: engine_key];
	}
	
	return arr;
}

- (NSDictionary *) engineByName: (NSString *) name
{
	NSDictionary *engine = [engines objectForKey: name];
	
	return engine;
	
}

- (NSString *) defaultLocalForEngine: (NSString *) name
{
	NSDictionary *engine = [self engineByName: name];
	NSString *ret = [engine objectForKey: @"defaultlocale"];
	return ret;
}

- (NSDictionary *) localesForEngine: (NSString *) name
{
	NSDictionary *engine = [self engineByName: name];
	
	NSDictionary *ret = [engine objectForKey: @"locales"];
	
	return ret;
}

- (NSArray *) localeNamesForEngine: (NSString *) name
{
	NSDictionary *locales = [self localesForEngine: name];
	NSMutableArray *ret = [NSMutableArray array];
	
	for (NSString *locale_name in locales)
	{
		[ret addObject: locale_name];
	}
	
	return ret;
}


- (NSString *) searchURLForEngine: (NSString *) engineName andLocale: (NSString *) localeName
{
	NSDictionary *locales = [self localesForEngine: engineName];
	NSString *ret = [locales objectForKey: localeName];
	
	return ret;
}

- (void) searchItunes: (NSString *) keyword
{
	keyword = [keyword stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	NSLog(@"searching iTunes for %@",keyword);
	
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	iTunesPlaylist *playList = [iTunes currentPlaylist];
	
	//NSLog(@"%@",[[playList tracks] get]);
	//[playList searchFor: keyword only: iTunesESrAAll];
	
	NSArray *tracks = [[iTunes currentPlaylist] searchFor: keyword only: iTunesESrAAll];
	if ([tracks count] > 0)
	{
		[[tracks objectAtIndex: 0] playOnce: NO];		
//		[[tracks objectAtIndex: 0] reveal];
		[NSApp hide: self];
	}
	else 
	{
		NSLog(@"the track %@ was not found in iTunes!",keyword);
		NSBeep();
	}


	
	NSLog(@"%@",tracks);

}

- (void) performSearchForKeyword: (NSString *) keyword withEngine: (NSString *) engine andLocale: (NSString *) locale
{
	if ([engine isEqualToString: @"iTunes"])
	{
		[self searchItunes: keyword];
		return;
	}
	

	
	NSString *searchTemplate = [self searchURLForEngine: engine andLocale: locale];
	if (searchTemplate == nil)
		return;
	
	NSMutableString *searchURLString = [NSMutableString stringWithString: searchTemplate];
	if (searchURLString == nil)
		return;
	//keyword = [keyword stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]; 
	NSMutableString *mutablekeyword = [NSMutableString stringWithString: keyword];
	[mutablekeyword replaceOccurrencesOfString:@"+" withString:@"+%2B+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutablekeyword length])];
	[mutablekeyword replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutablekeyword length])];
	keyword = [NSString stringWithString: mutablekeyword];
	
	[searchURLString replaceOccurrencesOfString:@"$keyword" withString: keyword options: NSCaseInsensitiveSearch range: NSMakeRange(0, [searchURLString length])];

	//word around double http://
	[searchURLString replaceOccurrencesOfString:@"http://http://" withString: @"http://" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [searchURLString length])];
	[searchURLString replaceOccurrencesOfString:@"http://http://" withString: @"http://" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [searchURLString length])];
	[searchURLString replaceOccurrencesOfString:@"http://http://" withString: @"http://" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [searchURLString length])];
	
	NSURL *searchURL = [NSURL URLWithString:searchURLString];
		
//	AppDelegate *appDelegate = (AppDelegate*)[NSApp delegate];
	//[appDelegate setLastSearchTerm: [searchField stringValue]];
		
	[[NSWorkspace sharedWorkspace] openURL: searchURL];
	
}

@end
