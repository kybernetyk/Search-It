#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>


@class SearchWindowController;
@class SearchItPrefsWindowController;

@interface AppDelegate : NSObject 
{
	SearchWindowController *searchWindowController;
	SearchItPrefsWindowController *prefsWindowController;

	BOOL isWindowOpen;
	BOOL shouldShowWindow;
	
	BOOL didJustStart;
	BOOL showWelcomeAlert;
	
	NSString *lastSearchTerm;
	

	EventHotKeyRef gMyHotKeyRef;
	
	NSStatusItem *statusIcon;
}

@property (readwrite, assign) BOOL isWindowOpen;
@property (readwrite, assign) BOOL shouldShowWindow;

@property (readwrite, retain) NSString *lastSearchTerm;
@property (readwrite, retain) SearchWindowController *searchWindowController;
@property (retain) SearchItPrefsWindowController *prefsWindowController;

- (void) enregisterHotkeyWithKeyCode : (NSInteger) keyCode andModifiers: (NSInteger) modifiers;
- (void) unregisterHotkey;


-(void)addAppToLoginItems;
-(void)removeAppFromLoginItems;


- (void) createMenuBarIcon;
- (void) removeMenuBarIcon;

- (IBAction) openNewWindow : (id) sender;

- (IBAction) openPreferences : (id) sender;
- (IBAction) reopenWindowByMenu : (id) sender;
- (IBAction) quitAppByMenu : (id) sender;
@end
