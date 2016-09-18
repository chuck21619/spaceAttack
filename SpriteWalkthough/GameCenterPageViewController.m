//
//  GameCenterPageViewController.m
//  SpaceAttack
//
//  Created by charles johnston on 9/17/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "GameCenterPageViewController.h"

@implementation GameCenterPageViewController
{
    NSArray * _viewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView * background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.image = [UIImage imageNamed:@"menuBackground.png"];
    [self.view insertSubview:background atIndex:0];
    
    self.delegate = self;
    self.dataSource = self;
    
    UIViewController * achievementsPage = [self.storyboard instantiateViewControllerWithIdentifier:@"highscoresAchievementsVC"];
    UIViewController * highScoresPage = [self.storyboard instantiateViewControllerWithIdentifier:@"highScoresVC"];
    
    _viewControllers = @[achievementsPage, highScoresPage];
    [self setViewControllers:@[achievementsPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [self.view addSubview:backButton];
}

- (void) viewDidLayoutSubviews
{
    //this is because the page controller defaults to having a small gap at the bottom
    [super viewDidLayoutSubviews];
    for ( UIView * subview in self.view.subviews )
    {
        if ( [subview isKindOfClass:[UIScrollView class]] )
            subview.frame = self.view.bounds;
    }
}

- (void) backAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
