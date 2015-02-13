## demo
![Alt text](/topalertview.gif)

---------------------------------------
## import 
**FontAwesome.ttf to Info.plist -> Fonts provided by application**

---------------------------------------
## code
    #import "MozTopAlertView.h"
    
    [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Info" parentView:self.view];
    
    MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Success" parentView:self.view];
    alertView.dismissBlock = ^(){
        NSLog(@"dismissBlock");
    };
    
    [MozTopAlertView showWithType:MozAlertTypeWarning text:@"Warning" doText:@"undo" doBlock:^{
        
    } parentView:self.view];
    
    [MozTopAlertView showWithType:MozAlertTypeError text:@"Error" doText:@"undo" doBlock:^{
        
    } parentView:self.view];

---------------------------------------
### Thanks for [Chameleon], [ios-fontawesome]
[Chameleon]: https://github.com/VAlexander/Chameleon
[ios-fontawesome]: https://github.com/alexdrone/ios-fontawesome
