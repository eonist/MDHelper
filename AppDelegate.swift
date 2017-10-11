import Cocoa
import CoreGraphics
import Quartz
import Darwin //Put this line at the beginning of your file

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem : NSStatusItem = NSStatusItem()
    var menu: NSMenu = NSMenu()
    var menuItem : NSMenuItem = NSMenuItem()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        Swift.print("hello world")
        
        let app:NSApplication = aNotification.object as! NSApplication
        app.windows[0].close()//close the initial window
        
        
        //Add statusBarItem
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.menu = menu
        statusBarItem.title = "MDHelper"
        statusBarItem.highlightMode = true
        
        //Add menuItem to menu
        menuItem.title = "Sort tasks"
        menuItem.action = Selector("sortSelectedTasks:")
        menuItem.keyEquivalent = ""
        menu.addItem(menuItem)
        
        
        let indexSelectedFilesMenuItem = NSMenuItem(title: "Index files", action: Selector("indexSelectedFiles:"), keyEquivalent: "")
        menu.addItem(indexSelectedFilesMenuItem)
        
        let seperatorMenuItem = NSMenuItem.separatorItem()
        menu.addItem(seperatorMenuItem)
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: Selector("quitApp:"), keyEquivalent: "")
        menu.addItem(quitMenuItem)
    }
    /*
     *
     */
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    /*
     *
     */
    func sortSelectedTasks(sender: AnyObject){
        //Swift.print("Sort tasks!!!")
        
        copySelectedText()
        
        pauseForAMoment()//so that the copy selected text operation can finish
        
        let clipboardText:String = ClipboardUtils.getClipboardText()
        
        /*do the sorting*/
        //var result = MDUtils.items(clipboardText)//parse to Array/Dictionary tree structure
        //result = MDUtils.sort(result)//Ascending
        //MDUtils.traverseTree(result)//print as markdown syntax
        //print("\nDescending:")
        var result2 = MDUtils.items(clipboardText)//parse to Array/Dictionary tree structure
        result2 = MDUtils.sort(result2,true)//Descending
        var finalResult:String = MDUtils.traverseTree(result2)//print as markdown syntax
        
        finalResult = CharacterModifier.removeLast(finalResult)
        
        
        //let newClipboardText:String = "changed: " + clipboardText
        Swift.print(finalResult)
        ClipboardUtils.setClipboardText(finalResult)
        
        pasteSelectedText()
    }
    /**
     *
     */
    func indexSelectedFiles(sender: AnyObject){
        Swift.print("indexSelectedFiles!!!")
        let str = "- [ ] abc" + "\n" +
            "- [X] def" + "\n" +
            "  - [X] ghi" + "\n" +
            "  - [ ] tkl" + "\n" +
            "    - [ ] qvi" + "\n" +
            "    - [X] rty" + "\n" +
            "  - [ ] qwe" + "\n" +
        "- [X] xyz"
        
        print("\nAscending:")
        var result = MDUtils.items(str)//parse to Array/Dictionary tree structure
        result = MDUtils.sort(result)//Ascending
        MDUtils.traverseTree(result)//print as markdown syntax
        print("\nDescending:")
        var result2 = MDUtils.items(str)//parse to Array/Dictionary tree structure
        result2 = MDUtils.sort(result2,true)//Descending
        MDUtils.traverseTree(result2)//print as markdown syntax

    }
    /**
     * x = 0x07 (if you want to do cut instead of copy)
     */
    func copySelectedText(){
        let src:CGEventSource = CGEventSourceCreate(CGEventSourceStateID(rawValue: CGEventSourceStateID.HIDSystemState.rawValue/*kCGEventSourceStateHIDSystemState*/)!)!
        
        let cmdd = CGEventCreateKeyboardEvent(src, 0x38, true)//0x08 is the "cmd" char
        let cmdu = CGEventCreateKeyboardEvent(src, 0x38, false)
        let ccd = CGEventCreateKeyboardEvent(src, 0x08, true)//0x08 is the "c" char
        let ccu = CGEventCreateKeyboardEvent(src, 0x08, false)
        
        
        CGEventSetFlags(ccd, CGEventFlags(rawValue: CGEventFlags.MaskCommand.rawValue)!);/*kCGEventFlagMaskCommand*/
        CGEventSetFlags(ccu, CGEventFlags(rawValue: CGEventFlags.MaskCommand.rawValue)!);/*kCGEventFlagMaskCommand*/
        
        let loc:CGEventTapLocation = CGEventTapLocation(rawValue: CGEventTapLocation.CGHIDEventTap.rawValue/*kCGHIDEventTap*/)!
        
        CGEventPost(loc, cmdd)
        CGEventPost(loc, ccd)
        CGEventPost(loc, ccu)
        CGEventPost(loc, cmdu)
    }
    /**
     *
     */
    func pasteSelectedText(){
        let src:CGEventSource = CGEventSourceCreate(CGEventSourceStateID(rawValue: CGEventSourceStateID.HIDSystemState.rawValue/*kCGEventSourceStateHIDSystemState*/)!)!
        
        let cmdd = CGEventCreateKeyboardEvent(src, 0x38, true)//0x08 is the "cmd" char
        let cmdu = CGEventCreateKeyboardEvent(src, 0x38, false)
        let ccd = CGEventCreateKeyboardEvent(src, 0x09, true)//0x09 is the "v" char
        let ccu = CGEventCreateKeyboardEvent(src, 0x09, false)
        
        
        CGEventSetFlags(ccd, CGEventFlags(rawValue: CGEventFlags.MaskCommand.rawValue)!);/*kCGEventFlagMaskCommand*/
        CGEventSetFlags(ccu, CGEventFlags(rawValue: CGEventFlags.MaskCommand.rawValue)!);/*kCGEventFlagMaskCommand*/
        
        let loc:CGEventTapLocation = CGEventTapLocation(rawValue: CGEventTapLocation.CGHIDEventTap.rawValue/*kCGHIDEventTap*/)!
        
        CGEventPost(loc, cmdd)
        CGEventPost(loc, ccd)
        CGEventPost(loc, ccu)
        CGEventPost(loc, cmdu)
    }
    /*
     *
     */
    func pauseForAMoment() {
        sleep(1)
    }

   
    
    /**
     *
     */
    func quitApp(sender: AnyObject){
        NSApplication.sharedApplication().terminate(self)
    }

}

