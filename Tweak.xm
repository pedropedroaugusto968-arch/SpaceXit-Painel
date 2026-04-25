#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <dlfcn.h>

@interface SpaceMenu : UIView
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) UIScrollView *scrollView;
+ (instancetype)sharedInstance;
- (void)setupMenu;
@end

@implementation SpaceMenu

+ (instancetype)sharedInstance {
    static SpaceMenu *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SpaceMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedInstance;
}

// --- FUNÇÕES DE BYPASS (PROTEÇÃO) ---

void disable_debugger() {
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    void (*ptrace)(int, pid_t, caddr_t, int) = dlsym(handle, "ptrace");
    if (ptrace) ptrace(31, 0, 0, 0); // PT_DENY_ATTACH
}

BOOL is_bypassed() {
    NSArray *paths = @[@"/Applications/Cydia.app", @"/Library/MobileSubstrate/MobileSubstrate.dylib", @"/bin/bash", @"/usr/sbin/sshd", @"/etc/apt"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    return NO;
}

- (void)setupMenu {
    disable_debugger();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];

        // --- BOLINHA FLUTUANTE ---
        self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.floatingButton.frame = CGRectMake(50, 150, 60, 60);
        self.floatingButton.backgroundColor = [UIColor purpleColor];
        self.floatingButton.layer.cornerRadius = 30;
        self.floatingButton.layer.borderWidth = 2;
        self.floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.floatingButton setTitle:@"SPACE" forState:UIControlStateNormal];
        
        [self.floatingButton addTarget:self action:@selector(expandMenu) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.floatingButton addGestureRecognizer:pan];

        // --- PAINEL DE FUNÇÕES ---
        self.mainPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        self.mainPanel.center = window.center;
        self.mainPanel.backgroundColor = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.98];
        self.mainPanel.layer.cornerRadius = 20;
        self.mainPanel.layer.borderWidth = 1.5;
        self.mainPanel.layer.borderColor = [UIColor purpleColor].CGColor;
        self.mainPanel.hidden = YES;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 280, 30)];
        title.text = is_bypassed() ? @"SPACE XIT - BYPASS ON" : @"SPACE XIT - SECURE";
        title.textColor = [UIColor purpleColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:17];
        [self.mainPanel addSubview:title];

        UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(245, 10, 25, 25)];
        [close setTitle:@"X" forState:UIControlStateNormal];
        close.backgroundColor = [UIColor colorWithRed:0.3 green:0.0 blue:0.0 alpha:1.0];
        close.layer.cornerRadius = 12.5;
        [close addTarget:self action:@selector(minimizeMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.mainPanel addSubview:close];

        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 280, 340)];
        [self.mainPanel addSubview:self.scrollView];

        // Adicionando as Funções com Tags para a lógica
        [self addCheatOption:@"BYPASS ANTICHEAT" yPos:10 tag:99];
        [self addCheatOption:@"AIMBOT" yPos:60 tag:1];
        [self addCheatOption:@"ESP MASTER" yPos:110 tag:2];
        [self addCheatOption:@"GOD MODE" yPos:160 tag:3];
        [self addCheatOption:@"UNLOCK ALL" yPos:210 tag:4];
        [self addCheatOption:@"NO RECOIL" yPos:260 tag:5];

        self.scrollView.contentSize = CGSizeMake(280, 320);

        [window addSubview:self.floatingButton];
        [window addSubview:self.mainPanel];
    });
}

- (void)addCheatOption:(NSString *)name yPos:(CGFloat)y tag:(NSInteger)tag {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, 30)];
    lbl.text = name;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:lbl];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(210, y, 50, 30)];
    sw.onTintColor = [UIColor purpleColor];
    sw.tag = tag;
    [sw addTarget:self action:@selector(cheatChanged:) forControlEvents:UIControlEventValueChanged];
    if(tag == 99) [sw setOn:YES animated:YES];
    [self.scrollView addSubview:sw];
}

// Lógica para quando você ligar/desligar uma chave
- (void)cheatChanged:(UISwitch *)sw {
    if (sw.tag == 1) { // AIMBOT
        if (sw.on) { /* Lógica de ligar */ } else { /* Lógica de desligar */ }
    }
    // Adicione os outros tags (2, 3, 4...) conforme precisar
}

- (void)expandMenu { self.mainPanel.hidden = NO; self.floatingButton.hidden = YES; }
- (void)minimizeMenu { self.mainPanel.hidden = YES; self.floatingButton.hidden = NO; }
- (void)handlePan:(UIPanGestureRecognizer *)g { self.floatingButton.center = [g locationInView:self.floatingButton.superview]; }

@end

%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [[SpaceMenu sharedInstance] setupMenu];
    }];
}
