package
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	
	/**
	 * 创建一个小车
	 * @author licheng
	 */	
	[SWF(width="1000", height="480", backgroundColor="0x333333", frameRate="30")]
	public class Main0602 extends Sprite
	{
		private var world:b2World;
		private var worldScale:Number=30;
		private var left:Boolean = false;
		private var right:Boolean = false;
		private var down:Boolean = false;
		private var frj:b2RevoluteJoint;
		private var rrj:b2RevoluteJoint;
		private var motorSpeed:Number = 0;
		
		public function Main0602()
		{
			super();
			world=new b2World(new b2Vec2(0,9.81),true);
			debugDraw();
			ground();
			var frontCart:b2Body=addCart(200,430,true);
			var rearCart:b2Body=addCart(100,430,false);
			var dJoint:b2DistanceJointDef=new b2DistanceJointDef();
			dJoint.bodyA=frontCart;
			dJoint.bodyB=rearCart;
			dJoint.localAnchorA=new b2Vec2(0,0);
			dJoint.localAnchorB=new b2Vec2(0,0);
			dJoint.length=100/worldScale;
			var distanceJoint:b2DistanceJoint = world.CreateJoint(dJoint) as b2DistanceJoint;
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
					down=true;
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
				case 38 :
					down=false;
					break;
			}
		}
		
		private function addCart(pX:Number,pY:Number,motor:Boolean):b2Body {
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
			var polygonShape:b2PolygonShape=new b2PolygonShape();
			polygonShape.SetAsBox(40/worldScale,20/worldScale);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape=polygonShape;
			fixtureDef.density=1;
			fixtureDef.restitution=0.5;
			fixtureDef.friction=0.5;
			var body:b2Body=world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			var frontWheel:b2Body=addWheel(pX+20,pY+15);
			var rearWheel:b2Body=addWheel(pX-20,pY+15);
			var rJoint:b2RevoluteJointDef=new b2RevoluteJointDef();
			rJoint.bodyA=body;
			rJoint.bodyB=frontWheel;
			rJoint.localAnchorA.Set(20/worldScale,15/worldScale);
			rJoint.localAnchorB.Set(0,0);
			var rj:b2RevoluteJoint;
			if (motor) {
				rJoint.enableMotor=true;
				rJoint.maxMotorTorque=1000;
				rJoint.motorSpeed=0;
				frj = world.CreateJoint(rJoint) as b2RevoluteJoint;
			}
			else
			{
				rj = world.CreateJoint(rJoint) as b2RevoluteJoint;
			}
			
			rJoint.bodyB = rearWheel;
			rJoint.localAnchorA.Set(-20/worldScale,15/worldScale);
			if(motor)
			{
				rrj = world.CreateJoint(rJoint) as b2RevoluteJoint;
			}
			else
			{
				rj = world.CreateJoint(rJoint) as b2RevoluteJoint;
			}
			return body;
		}
		
		private function addWheel(pX:Number,pY:Number):b2Body {
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			bodyDef.type = b2Body.b2_dynamicBody;
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
		
		private function ground():void {
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(500/worldScale, 470/worldScale);
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(500/worldScale, 10/worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			var groundBody:b2Body = world.CreateBody(bodyDef);
			groundBody.CreateFixture(fixtureDef);
		}
		
		private function updateWorld(e:Event):void {
			if (left) {
				motorSpeed-=0.1;
			}
			if (right) {
				motorSpeed+=0.1;
			}
			if(down)
			{
				motorSpeed=0;
			}
			motorSpeed*0.99;
			if (motorSpeed>10) {
				motorSpeed=10;
			}
			if (motorSpeed<-10) {
				motorSpeed=-10;
			}
			frj.SetMotorSpeed(motorSpeed);
			rrj.SetMotorSpeed(motorSpeed);
			world.Step(1/30,10,10);
			world.ClearForces();
			world.DrawDebugData();
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
		
		
		
		
		
	}
}