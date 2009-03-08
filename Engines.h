//
//  Engines.h
//  Search It
//
//  Created by Jaroslaw Szpilewski on 01.12.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>


// singleton that stores the aviable search engines
@interface Engines : NSObject 
{
	NSDictionary *engines;
	
}

@property (readonly, assign) NSDictionary *engines;

- (void) loadEngines;


- (NSArray *) engineNames;
- (NSArray *) localeNamesForEngine: (NSString *) name;
- (NSString *) defaultLocalForEngine: (NSString *) name;

- (NSDictionary *) engineByName: (NSString *) name;
- (NSDictionary *) localesForEngine: (NSString *) name;
- (NSString *) searchURLForEngine: (NSString *) engineName andLocale: (NSString *) localeName;

- (void) performSearchForKeyword: (NSString *) keyword withEngine: (NSString *) engine andLocale: (NSString *) locale;

+(Engines *) sharedInstance;

@end
