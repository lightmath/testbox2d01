package
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * 投石车
	 * @author licheng
	 */	
	[SWF(width="640", height="480", backgroundColor="0x333333", frameRate="30")]
	public class Main0601 extends Sprite
	{
		private var world:b2World;
		private var worldScale:Number=30;
		private var left:Boolean = false;
		private var right:Boolean = false;
		private var frj:b2RevoluteJoint;
		private var rrj:b2RevoluteJoint;
		private var motorSpeed:Number = 0;
		private var sling:b2DistanceJoint;
		
		public function Main0601()
		{
			super();
			world=new b2World(new b2Vec2(0,5),true);
			world.SetContactListener(new customContact());
			debugDraw();
			ground();
			brick(402,431,140,36);
			brick(544,431,140,36);
			brick(342,396,16,32);
			brick(604,396,16,32);
			brick(416,347,16,130);
			brick(532,347,16,130);
			brick(474,273,132,16);
			brick(474,257,32,16);
			brick(445,199,16,130);
			brick(503,199,16,130);
			brick(474,125,58,16);
			brick(474,100,32,32);
			brick(474,67,16,32);
			brick(474,404,64,16);
			brick(450,363,16,64);
			brick(498,363,16,64);
			brick(474,322,64,16);
			pig(474,232,16);
			
			var frontCart:b2Body=addCart(200,430,true);
			var rearCart:b2Body=addCart(100,430,false);
			var dJoint:b2DistanceJointDef=new b2DistanceJointDef();
			dJoint.bodyA=frontCart;
			dJoint.bodyB=rearCart;
			dJoint.localAnchorA=new b2Vec2(0,0);
			dJoint.localAnchorB=new b2Vec2(0,0);
			dJoint.length=100/worldScale;
			var distanceJoint:b2DistanceJoint;
			distanceJoint=world.CreateJoint(dJoint) as b2DistanceJoint;
			addEventListener(Event.ENTER_FRAME,updateWorld);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyReleased);
		}
		
		private function keyPressed(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 37 :
					left=true;
					break;
				case 39 :
					right = true;
					break;
				case 38 :
					world.DestroyJoint(sling);
					break;
			}
		}
		
		private function keyReleased(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 37 :
					left=false;
					break;
				case 39 :
					right=false;
					break;
			}
		}
		
		private function ground():void {
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(320/worldScale, 465/worldScale);
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(320/worldScale, 10/worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			var groundBody:b2Body = world.CreateBody(bodyDef);
			groundBody.CreateFixture(fixtureDef);
		}
		
		private function addCart(pX:Number,pY:Number,motor:Boolean):b2Body {
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
			bodyDef.userData="cart";
			var polygonShape:b2PolygonShape=new b2PolygonShape();
			polygonShape.SetAsBox(40/worldScale,20/worldScale);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape=polygonShape;
			fixtureDef.density=10;
			fixtureDef.restitution=0.5;
			fixtureDef.friction=0.5;
			var body:b2Body=world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			if (! motor) {
				var armOrigin:b2Vec2=new b2Vec2(0,-60/worldScale);
				var armW:Number=5/worldScale
				var armH:Number=60/worldScale
				polygonShape.SetAsOrientedBox(armW,armH,armOrigin);
				body.CreateFixture(fixtureDef);
				bodyDef.position.Set(pX/worldScale,(pY-115)/worldScale);
				polygonShape.SetAsBox(40/worldScale,5/worldScale);
				fixtureDef.shape=polygonShape;
				fixtureDef.filter.categoryBits=0x0002;
				fixtureDef.filter.maskBits=0x0002;
				var arm:b2Body=world.CreateBody(bodyDef);
				arm.CreateFixture(fixtureDef);
				var armJoint:b2RevoluteJointDef;
				armJoint=new b2RevoluteJointDef();
				armJoint.bodyA=body;
				armJoint.bodyB=arm;
				armJoint.localAnchorA.Set(0,-115/worldScale);
				armJoint.localAnchorB.Set(0,0);
				armJoint.enableMotor=true;
				armJoint.maxMotorTorque=1000;
				armJoint.motorSpeed=6;
				var siege:b2RevoluteJoint;
				siege = world.CreateJoint(armJoint) as b2RevoluteJoint;
				var projectileX:Number =(pX-80)/worldScale;
				var projectileY:Number = (pY-115)/worldScale;
				bodyDef.position.Set(projectileX, projectileY);
				bodyDef.userData="projectile";
				polygonShape.SetAsBox(5/worldScale, 5/worldScale);
				fixtureDef.shape = polygonShape;
				fixtureDef.filter.categoryBits = 0x0004;
				fixtureDef.filter.maskBits=0x0004;
				var projectile:b2Body=world.CreateBody(bodyDef);
				projectile.CreateFixture(fixtureDef);
				var slingJoint:b2DistanceJointDef;
				slingJoint=new b2DistanceJointDef();
				slingJoint.bodyA=arm;
				slingJoint.bodyB=projectile;
				slingJoint.localAnchorA.Set(-40/worldScale,0);
				slingJoint.localAnchorB.Set(0,0);
				slingJoint.length=30/worldScale;
				sling=world.CreateJoint(slingJoint) as b2DistanceJoint;
			}
			
			var frontWheel:b2Body=addWheel(pX+20,pY+15);
			var rearWheel:b2Body=addWheel(pX-20,pY+15);
			var rJoint:b2RevoluteJointDef=new b2RevoluteJointDef();
			rJoint.bodyA=body;
			rJoint.bodyB=frontWheel;
			rJoint.localAnchorA.Set(20/worldScale,15/worldScale);
			rJoint.localAnchorB.Set(0,0);
			if (motor) {
				rJoint.enableMotor=true;
				rJoint.maxMotorTorque=1000;
				rJoint.motorSpeed=0;
				frj = world.CreateJoint(rJoint) as b2RevoluteJoint;
			}
			else
			{
				var rj:b2RevoluteJoint;
				rj = world.CreateJoint(rJoint) as b2RevoluteJoint;
			}
			rJoint.bodyB=rearWheel;
			rJoint.localAnchorA.Set(-20/worldScale,15/worldScale);
			if (motor) {
				rrj=world.CreateJoint(rJoint) as b2RevoluteJoint;
			}
			else {
				rj=world.CreateJoint(rJoint) as b2RevoluteJoint;
			}
			return body;
		}
		
		private function addWheel(pX:Number,pY:Number):b2Body {
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
			var circleShape:b2CircleShape=new b2CircleShape(0.5);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape=circleShape;
			fixtureDef.density=1;
			fixtureDef.restitution=0.5;
			fixtureDef.friction=0.5;
			var body:b2Body=world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			return body;
		}
		
		private function debugDraw():void {
			var debugDraw:b2DebugDraw=new b2DebugDraw();
			var debugSprite:Sprite=new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		
		private function updateWorld(e:Event):void {
			if (left) {
				motorSpeed-=0.1;
			}
			if (right) {
				motorSpeed+=0.1;
			}
			motorSpeed*0.99;
			if (motorSpeed>5) {
				motorSpeed=5;
			}
			if (motorSpeed<-5) {
				motorSpeed=-5;
			}
			frj.SetMotorSpeed(motorSpeed);
			rrj.SetMotorSpeed(motorSpeed);
			world.Step(1/30,10,10);
			world.ClearForces();
			for(var b:b2Body=world.GetBodyList();b;b=b.GetNext())
			{
				if(b.GetUserData()=="remove")
				{
					world.DestroyBody(b);
				}
			}
			world.DrawDebugData();
		}
		
		private function brick(pX:int,pY:int,w:Number,h:Number):void{
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
			bodyDef.userData = "brick";
			var polygonShape:b2PolygonShape=new b2PolygonShape();
			polygonShape.SetAsBox(w/2/worldScale,h/2/worldScale);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 2;
			fixtureDef.restitution = 0.4;
			fixtureDef.friction = 0.5;
			var theBrick:b2Body = world.CreateBody(bodyDef);
			theBrick.CreateFixture(fixtureDef);
		}
		
		private function pig(pX:Number, pY:Number, r:Number):void
		{
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
			bodyDef.userData = "pig";
			var pigShape:b2CircleShape = new b2CircleShape(r/worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = pigShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.4;
			fixtureDef.friction = 0.5;
			var thePig:b2Body = world.CreateBody(bodyDef);
			thePig.CreateFixture(fixtureDef);
		}
		
	}
}