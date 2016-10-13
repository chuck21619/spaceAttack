//
//  GameCenterPageViewController.m
//  SpaceAttack
//
//  Created by charles johnston on 9/17/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "GameCenterPageViewController.h"
#import "SpriteAppDelegate.h"
#import "AudioManager.h"

@implementation GameCenterPageViewController
{
    NSArray * _viewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    UIViewController * achievementsPage = [self.storyboard instantiateViewControllerWithIdentifier:@"achievementsVC"];
    UIViewController * highScoresPage = [self.storyboard instantiateViewControllerWithIdentifier:@"highScoresVC"];
    
    _viewControllers = @[achievementsPage, highScoresPage];
    [self setViewControllers:@[achievementsPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnPageToAchievements) name:@"turnPageToAchievements" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnPageToHighScores) name:@"turnPageToHighScores" object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for ( UIView * subview in [self.view subviews] )
        subview.alpha = 0;
    
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
        {
            if ( subview.tag == 9 )
            {
                subview.alpha = .1;
                continue;
            }
            
            subview.alpha = 1;
        }
    }];
}

- (void) turnPageToAchievements
{
    if ( self.view.userInteractionEnabled ) //if user spams page turns, i cant keep up
    {
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuPageTurn];
        [self setViewControllers:@[[_viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .36 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
        {
            self.view.userInteractionEnabled = YES;
        });
    }
}

- (void) turnPageToHighScores
{
    if ( self.view.userInteractionEnabled ) //if user spams page turns, i cant keep up
    {
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuPageTurn];
        [self setViewControllers:@[[_viewControllers lastObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
        self.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .36 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
        {
            self.view.userInteractionEnabled = YES;
        });
    }
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return _viewControllers[index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [_viewControllers indexOfObject:viewController];
    
    --currentIndex;
    currentIndex = currentIndex % (_viewControllers.count);
    return [_viewControllers objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.view.userInteractionEnabled = NO; //if user spams page turns, i cant keep up
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuPageTurn];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .36 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
    {
        self.view.userInteractionEnabled = YES;
    });
    
    NSUInteger currentIndex = [_viewControllers indexOfObject:viewController];
    
    ++currentIndex;
    currentIndex = currentIndex % (_viewControllers.count);
    return [_viewControllers objectAtIndex:currentIndex];
}

//pretty sure i dont needs theis method anymore
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return _viewControllers.count;
}

//pretty sure i dont needs theis method anymore
-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
