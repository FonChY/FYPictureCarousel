//
//  FYLayer.m
//  FYPictureCarousel
//
//  Created by fang on 15/12/27.
//  Copyright © 2015年 fang. All rights reserved.
//

#import "FYLayer.h"

@implementation FYLayer

- (void)prepareLayout
{
    [super prepareLayout];
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    //拿到所有布局属性
    NSArray *temp  =  [super  layoutAttributesForElementsInRect:rect];
    
    
    //遍历数组 得到每一个布局属性
    
    for (int i = 0; i < temp.count; i ++) {
        UICollectionViewLayoutAttributes *att = temp[i];
        
        //算比例
        
        //拿到每个item的位置  算出itemCenterX  和collectionCenterX 的一个距离
    
        CGFloat distance = ABS(att.center.x - self.collectionView.frame.size.width * 0.5 - self.collectionView.contentOffset.x);
        
        CGFloat scale = 0.5;
        
        
        CGFloat w = (self.collectionView.frame.size.width + self.itemSize.width) * 0.5;
        if (distance >= w) {
            
            scale = 0.5;
        }else{
            
            scale = scale +  (1- distance / w ) * 0.5;
            
        }
        
        att.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    
    NSLog(@"%@",temp);
    
    return  temp;
    
}
//滑动完成后，会来到此方法
//proposedContentOffset  最后停止的 contentOffset

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    //proposedContentOffset 滑动之后最后停的位置
    
    
    CGRect  rect;
    
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.frame.size;
    //获取停止时，显示的cell的frame
    NSArray *tempArray  = [super  layoutAttributesForElementsInRect:rect];
    
    CGFloat  gap = 1000;
    
    CGFloat  a = 0;
    
    for (int i = 0; i < tempArray.count; i++) {
        //判断和中心的距离，得到最小的那个
        if (gap > ABS([tempArray[i] center].x - proposedContentOffset.x - self.collectionView.frame.size.width * 0.5)) {
            
            gap =  ABS([tempArray[i] center].x - proposedContentOffset.x - self.collectionView.frame.size.width * 0.5);
            
            a = [tempArray[i] center].x - proposedContentOffset.x - self.collectionView.frame.size.width * 0.5;
            
        }
    }
    
    //把希望得到的值返回出去
    CGPoint  point  =CGPointMake(proposedContentOffset.x + a , proposedContentOffset.y);
    
    NSLog(@"%@",NSStringFromCGPoint(point));
    
    return point;
}

//当collectionView 的 bounds发生改变的时候 是否刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    
    return  YES;
}

@end
