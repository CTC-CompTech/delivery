#import "cocos2d.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate>

@property (retain, nonatomic) NSNumber *obstacleCount;
//@property (retain, nonatomic) NSNumber *scrollingSpeed;
@property (retain, nonatomic) NSNumber *level;
@property (retain, nonatomic) NSNumber *obstacleDistance;
@property (retain, nonatomic) NSMutableArray *lasts;

@property BOOL abilityUse;

-(id)init;
+(MainScene*)instance;

@end
