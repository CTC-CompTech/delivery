#import "cocos2d.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate> {
    NSNumber *obstacleCount;
}

@property (retain, nonatomic) NSNumber *obstacleCount;

-(id)init;
+(MainScene*)instance;

@end
