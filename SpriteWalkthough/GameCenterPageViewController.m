//
//  GameCenterPageViewController.m
//  SpaceAttack
//
//  Created by charles johnston on 9/17/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "GameCenterPageViewController.h"
#import "SpriteAppDelegate.h"

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
    for ( UIView * subview in [self.view subviews] )
        subview.alpha = 0;
    
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
        {
            if ( subview.tag == 9 )
            {
                subview.alpha = .15;
                continue;
            }
            
            subview.alpha = 1;
        }
    }];
}

- (void) viewDidLayoutSubviews
{
    //this is because the page controller defaults to having a small gap at the bottom
    [super viewDidLayoutSubviews];
//    for ( UIView * subview in self.view.subviews )
//    {
//        if ( [subview isKindOfClass:[UIScrollView class]] )
//            subview.frame = self.view.bounds;
//    }
}

- (void) turnPageToAchievements
{
    [self setViewControllers:@[[_viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void) turnPageToHighScores
{
    [self setViewControllers:@[[_viewControllers lastObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
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
    NSUInteger currentIndex = [_viewControllers indexOfObject:viewController];
    
    ++currentIndex;
    currentIndex = currentIndex % (_viewControllers.count);
    return [_viewControllers objectAtIndex:currentIndex];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return _viewControllers.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
