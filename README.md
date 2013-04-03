RTNavigationController
======================

A Navigation Controller and A Side Controller


**Features**
* Two side support
* Multi translation style to choose, and support custom style
* Scroll view sensitive, won't show sider view until the scroll view reach its ends


**Installation**

Notice: Only for iOS 5.0 and up!

add "RTSiderViewControll.*" to your project and import file "RTSiderViewControll.h".

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    
        sider = [[RTSiderViewController alloc] init];
        sider.dataSource = self;
        sider.view.frame = self.view.bounds;
        sider.middleTranslationStyle = MiddleViewTranslationStyleStay;
    
        [sider setMiddleViewController:[[[MainViewController alloc] init] autorelease]
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
