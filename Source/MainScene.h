#import "cocos2d.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate> {
    NSNumber *obstacleCount;
}

@property (retain, nonatomic) NSNumber *obstacleCount;
@property (retain, nonatomic) NSNumber *scrollingSpeed;
@property (retain, nonatomic) NSNumber *obstacleDistance;

-(id)init;
+(MainScene*)instance;

@end
