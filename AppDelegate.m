#import "AppDelegate.h"
#import "SearchWindowController.h"
#import "SearchItPrefsWindowController.h"
#import <Sparkle/Sparkle.h>
#import "Engines.h"

@implementation AppDelegate
@synthesize isWindowOpen, shouldShowWindow, searchWindowController, lastSearchTerm, prefsWindowController;

-(void)addAppToLoginItems
{
#ifdef DEBUG
	NSLog(@"Adding to Login Items!");
#endif
	NSMutableArray*        loginItems;
	
    loginItems = (NSMutableArray*) CFPreferencesCopyValue((CFStringRef)  @"AutoLaunchedApplicationDictionary", (CFStringRef) @"loginwindow",							  kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    loginItems = [[loginItems autorelease] mutableCopy];
	
	
	NSMutableDictionary * myDict=[[NSMutableDictionary alloc]init];
	[myDict setObject:[NSNumber numberWithBool:NO] forKey:@"Hide"];
	[myDict setObject:[[NSBundle mainBundle] bundlePath] forKey:@"Path"];
	
	//first kill us and then add us again - to prevent multiple adds
	[loginItems removeObject: myDict];
	[loginItems addObject: myDict];
	
    //Do you stuff on "loginItems" array here
	
    CFPreferencesSetValue((CFStringRef)  @"AutoLaunchedApplicationDictionary", loginItems, (CFStringRef) @"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFPreferencesSynchronize((CFStringRef) @"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	
    [loginItems release];
	[myDict release];
}

-(void)removeAppFromLoginItems
{

#ifdef DEBUG
	NSLog(@"removing from LoginItems");
#endif
	
	NSMutableArray*        loginItems;
	
    loginItems = (NSMutableArray*) CFPreferencesCopyValue((CFStringRef)  @"AutoLaunchedApplicationDictionary", (CFStringRef) @"loginwindow",							  kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    loginItems = [[loginItems autorelease] mutableCopy];
	
	
	NSMutableDictionary * myDict=[[NSMutableDictionary alloc]init];
	[myDict setObject:[NSNumber numberWithBool:NO] forKey:@"Hide"];
	[myDict setObject:[[NSBundle mainBundle] bundlePath] forKey:@"Path"];
	
	[loginItems removeObject: myDict];
	//[loginItems addObject: myDict];
	
    //Do you stuff on "loginItems" array here
	
    CFPreferencesSetValue((CFStringRef)  @"AutoLaunchedApplicationDictionary", loginItems, (CFStringRef) @"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFPreferencesSynchronize((CFStringRef) @"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	
    [loginItems release];
}


- (id) init
{
#ifdef DEBUG
	NSLog(@"init");
#endif
//	[self parseEnginesFile];
	
	//Engines *e = [Engines sharedInstance];
	
	//NSLog(@"LOLOL\n\n%@",[e searchURLForEngine:@"Google" andLocale:@"english"]);
	//[e engineNames];
	//[e performSearchForKeyword:@"bier" withEngine:@"Google" andLocale:@"bierirr"];
	
	
	[self setShouldShowWindow: YES];
	self = [super init];

	searchWindowController = nil;
	prefsWindowController = nil;
	[self setIsWindowOpen: NO];
	
	[self setLastSearchTerm: nil];
	

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL addToLoginItems = [userDefaults boolForKey:@"shouldAddToLoginItems"];
	showWelcomeAlert = [userDefaults boolForKey:@"showWelcomeBox"];
	
	if (showWelcomeAlert == YES)
		[userDefaults setBool: NO forKey:@"showWelcomeBox"];

#ifdef DEBUG
	NSLog(@"should add? %i",addToLoginItems);
#endif

	if (addToLoginItems == YES)
		[self addAppToLoginItems];
	else
		[self removeAppFromLoginItems];
	return self;
}

+ (void)initialize
{
#ifdef DEBUG
	NSLog(@"initialize");
#endif
	

	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"YES"	forKey:@"MsgAtStartup"];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys: 
								 @"1",@"showWelcomeBox",
								 @"1",@"SUEnableAutomaticChecks",
								 @"53", @"hotKeyCode", 
								 @"2048", @"hotKeyModifier", 
								 @"option esc", @"hotKeyTitle",

								 @"Google", @"enterSearchEngine",
								 @"Wikipedia", @"commandEnterSearchEngine",
								 @"Open As URL",@"shiftEnterSearchEngine",
								 
								 [[Engines sharedInstance] defaultLocalForEngine: @"Google"],@"enterLanguage",
 								 [[Engines sharedInstance] defaultLocalForEngine: @"Wikipedia"],@"commandEnterLanguage",
								 [[Engines sharedInstance] defaultLocalForEngine: @"Open As URL"],@"shiftEnterLanguage",
								 
								 @"1",@"shouldAddToLoginItems",
								 nil,@"licenceData",
								 
								 
								 nil]; //esc + space
	
	//achtung - das 1. nil koennte probleme machen bei nachfolgenden defaults!
	
	[userDefaults registerDefaults:appDefaults];

}

- (void) storeLicence: (NSData *)licenceData
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[userDefaults setObject:licenceData forKey:@"licenceData"];
}

- (NSData *) loadLicence
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSData *data = nil;
	data = [userDefaults objectForKey:@"licenceData"];
	
	return data;
}



// Hot Key Handler to activate app
OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,	 void *userData)
{
	if ([NSApp isActive])
		[NSApp hide: nil];
	else
	{	
		[NSApp activateIgnoringOtherApps: YES];
		AppDelegate *d = (AppDelegate *)userData;
		[d setShouldShowWindow: YES];
		
	}
	
#ifdef DEBUG
	NSLog(@"hotkey trigger!");
#endif
	
	return noErr;
}


- (void) enregisterHotkeyWithKeyCode : (NSInteger) keyCode andModifiers: (NSInteger) modifiers
{
	//Register the Hotkeys
#ifdef DEBUG
	NSLog([NSString stringWithFormat:@"enregistering: %i / %i",keyCode,modifiers]);
#endif
	
	EventHotKeyID gMyHotKeyID;
	EventTypeSpec eventType;
	eventType.eventClass=kEventClassKeyboard;
	eventType.eventKind=kEventHotKeyPressed;
	
	//register hotkey handler
	InstallApplicationEventHandler(&MyHotKeyHandler,1,&eventType,self,NULL);
	
	//register hotkey (option + tab)
	gMyHotKeyID.signature='htk1';
	gMyHotKeyID.id=1;
	//RegisterEventHotKey(49, cmdKey+optionKey, gMyHotKeyID, 	GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	RegisterEventHotKey(keyCode, modifiers, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	
	
}

- (void) unregisterHotkey
{
	UnregisterEventHotKey(gMyHotKeyRef);
}

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
#ifdef DEBUG
	NSLog(@"applicationDidFinishLaunching");
#endif
	//if we have to show welcome box
	//don't hide the window!
	if (showWelcomeAlert == YES)
		didJustStart = NO;
	else
		didJustStart = YES;
	
	//[self openNewWindow:self];
	//	[NSApp setServicesProvider:self];
	

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	
	int keycode = [[userDefaults stringForKey:@"hotKeyCode"] intValue];
	int modifiers = [[userDefaults stringForKey:@"hotKeyModifier"] intValue];

#ifdef DEBUG
	NSString *str = [userDefaults stringForKey:@"hotKeyTitle"];
	NSLog(@"%@: %i / %i",str,keycode, modifiers);
#endif
	
	if (keycode >= 0 && modifiers >= 0)
		[self enregisterHotkeyWithKeyCode:keycode andModifiers:modifiers];
	


	NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"menu title"] autorelease];

	NSMenuItem *menuItem = [[[NSMenuItem alloc] initWithTitle:@"Open Search" action:@selector(reopenWindowByMenu:) keyEquivalent:[NSString string]] autorelease];
	[menu addItem: menuItem];
	menuItem = [[[NSMenuItem alloc] initWithTitle:@"Preferences" action:@selector(openPreferences:) keyEquivalent:[NSString string]] autorelease];
	[menu addItem: menuItem];
	[menu addItem:[NSMenuItem separatorItem]];

	[menu addItemWithTitle:@"Quit" action:@selector(quitAppByMenu:) keyEquivalent:[NSString string]];
	
	
	NSStatusItem *statusItem;
	NSStatusBar *statusBar = [NSStatusBar systemStatusBar];

	statusItem = [statusBar statusItemWithLength: 24.0f];
	[statusItem setTitle:@"s!"];
	[statusItem setEnabled: YES];
	[statusItem setHighlightMode: YES];
	[statusItem setMenu: menu];
	
	[statusItem retain];
	
#ifdef DEBUG
	SUUpdater *upd = [SUUpdater sharedUpdater];
	BOOL b = [upd automaticallyChecksForUpdates];
	NSLog(@"checks? %i",b);
#endif
	

	[NSApp activateIgnoringOtherApps: YES];
	
	
	if (showWelcomeAlert == YES)
	{
		NSAlert *al = [NSAlert alertWithMessageText:@"Search It!" defaultButton:@"Ok" alternateButton: nil otherButton: nil informativeTextWithFormat:@"You're running Search It for the first time.\n\nThe key combination to activate Search It is:\n[Option] [Esc]\n\nPress [Option] [Esc] everytime you want to access Search It."];
		[al runModal];
	}
}

- (IBAction) reopenWindowByMenu: (id) sender
{
	if ([self isWindowOpen] == NO)
	{	
		[self setShouldShowWindow: YES];
		[NSApp activateIgnoringOtherApps: YES];
	}
	
}

- (IBAction) quitAppByMenu : (id) sender
{
	[NSApp terminate: self];
}

- (IBAction) openPreferences : (id) sender
{
#ifdef DEBUG
	NSLog(@"Open Preferences!");
#endif
	
	[self reopenWindowByMenu: self];
	
	if (prefsWindowController != nil)
	{	

#ifdef DEBUG
		NSLog(@"prefsWindowController retaincount: %i",[prefsWindowController retainCount]);
#endif
		
		[prefsWindowController release];
		prefsWindowController = nil;
	}
	
	prefsWindowController = [[SearchItPrefsWindowController alloc] initWithWindowNibName:@"Preferences"];
	
	[prefsWindowController showWindow: nil];
}



- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	//[self saveList: self];
}

- (IBAction) openNewWindow : (id) sender
{	
#ifdef DEBUG
	NSLog(@"open!");
#endif
	
	
	if ([self isWindowOpen])
	{	
#ifdef DEBUG
		NSLog(@"Window open :-(");
#endif
		return;
		
	}
	if ([self shouldShowWindow] == NO)
	{	
#ifdef DEBUG
		NSLog(@"Shouldn't open :-(");
#endif
		
		return;
		
	}
	
	
	[self setIsWindowOpen: YES];
	
	
#ifdef DEBUG	
	NSLog(@"open New Window!");
#endif
	
	if (searchWindowController != nil)
	{	
#ifdef DEBUG
		NSLog(@"releaseing controller");
#endif
		[searchWindowController release];		
	}
	
	searchWindowController = [[SearchWindowController alloc] initWithWindowNibName:@"SearchWindow"];
	
	
	
	[[searchWindowController window] center];
	NSRect frame = [[searchWindowController window] frame];
	frame.origin.y -= (frame.size.height*2);
	
	[[searchWindowController window] setFrame:frame display:YES animate:NO];
	
	if ([self lastSearchTerm] != nil)
		[[searchWindowController searchField] setStringValue: [self lastSearchTerm]];
	

	//don't show the window when
	//the app just started
	if (didJustStart == YES)
	{
		[self setShouldShowWindow: NO];
		[searchWindowController close];

		didJustStart = NO;
		return;
		
	}
	else
		[searchWindowController showWindow:self];	
	
}


- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
#ifdef DEBUG
	NSLog(@"reopen");
#endif
	
	[self setShouldShowWindow: YES];
	[self openNewWindow:self];
	return YES;
}

- (void)applicationWillBecomeActive:(NSNotification *)aNotification
{
#ifdef DEBUG
	NSLog(@"WILL BECOME ACTIVE!");
#endif
	
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification
{
#ifdef DEBUG
	NSLog(@"applicationDidBecomeActive");
#endif
	
	[self openNewWindow:self];
}



- (void)applicationWillResignActive:(NSNotification *)aNotification
{
#ifdef DEBUG
	NSLog(@"WILL BECOME INACTIVE!");
#endif
	
	[self setShouldShowWindow: NO];
	[searchWindowController close];
}




@end
