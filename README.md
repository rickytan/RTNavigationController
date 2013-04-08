RTNavigationController
======================

A Navigation Controller and A Side Controller


***Features***

**RTSiderViewController**
* Two side support
* Multi translation style to choose, and support custom style
* Scroll view sensitive, won't show sider view until the scroll view reach its ends
* ARC and non-ARC support

**RTNavigationController**
* Just like UINavigationController, easy to use
* Two translation style
* Pan to navigation back and forward


***Requirements***

iOS: 5.0 and up
framework: QuartzCore

***Installation***

add 
"RTSiderViewController.*"
"RTNavigationController.*"

to your project and import file 
"RTSiderViewController.h"
"RTNavigationController.h"

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    
        sider = [[RTSiderViewController alloc] init];
        sider.dataSource = self;
        sider.view.frame = self.view.bounds;
        sider.middleTranslationStyle = MiddleViewTranslationStyleStay;
    
        [sider setMiddleViewController:[[[RTNavigationController alloc] initWithRootViewController:[[[MainViewController alloc] init] autorelease]] autorelease]
                              animated:YES];
    
        MenuViewController *menu = [[[MenuViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        
        [sider setLeftViewController:menu];
    
        SettingViewController *setting = [[[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    
        [sider setRightViewController:setting];
    
        [self.view addSubview:sider.view];
        [self addChildViewController:sider];
        [sider release];
    }


![Screenshot0](http://dl.dropbox.com/u/46239535/RTNavigationController/2.png)
![Screenshot1](http://dl.dropbox.com/u/46239535/RTNavigationController/1.png)
![Screenshot2](http://dl.dropbox.com/u/46239535/RTNavigationController/3.png)
![Screenshot3](http://dl.dropbox.com/u/46239535/RTNavigationController/4.png)
![Screenshot4](http://dl.dropbox.com/u/46239535/RTNavigationController/5.png)
