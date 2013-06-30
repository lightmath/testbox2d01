package
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 关节和马达
	 * @author licheng
	 */	
	[SWF(width="640", height="480", backgroundColor="0x333333", frameRate="30")]
	public class Main06 extends Sprite
	{
		private var world:b2World;
		private var worldScale:Number=30;
		private var mouseJoint:b2MouseJoint;
		
		public function Main06()
		{
			super();
			world=new b2World(new b2Vec2(0,9.81),true);
			debugDraw();
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(320/worldScale,470/worldScale);
			var polygonShape:b2PolygonShape=new b2PolygonShape();
			polygonShape.SetAsBox(320/worldScale,10/worldScale);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape=polygonShape;
			var groundBody:b2Body=world.CreateBody(bodyDef);
			groundBody.CreateFixture(fixtureDef);
			bodyDef.position.Set(320/worldScale,430/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
			polygonShape.SetAsBox(30/worldScale,30/worldScale);
			fixtureDef.density=1;
			fixtureDef.friction=0.5;
			fixtureDef.restitution=0.2;
			var box2:b2Body=world.CreateBody(bodyDef);
			box2.CreateFixture(fixtureDef);
			bodyDef.position.Set(420/worldScale,430/worldScale);
			var box3:b2Body=world.CreateBody(bodyDef);
			box3.CreateFixture(fixtureDef);
			var dJoint:b2DistanceJointDef=new b2DistanceJointDef();
			dJoint.bodyA=box2;
			dJoint.bodyB=box3;
			dJoint.localAnchorA=new b2Vec2(0,0);
			dJoint.localAnchorB=new b2Vec2(0,0);
			dJoint.length=100/worldScale;
			var distanceJoint:b2DistanceJoint;
			distanceJoint=world.CreateJoint(dJoint) as b2DistanceJoint;
			bodyDef.position.Set(320/worldScale,240/worldScale);
			var box4:b2Body=world.CreateBody(bodyDef);
			box4.CreateFixture(fixtureDef);
			var rJoint:b2RevoluteJointDef=new b2RevoluteJointDef();
			rJoint.bodyA=box4;
			rJoint.bodyB=world.GetGroundBody();
			rJoint.localAnchorA=new b2Vec2(0,0);
			rJoint.localAnchorB=box4.GetWorldCenter();
			var revoluteJoint:b2RevoluteJoint;
			revoluteJoint=world.CreateJoint(rJoint) as b2RevoluteJoint;
			addEventListener(Event.ENTER_FRAME,updateWorld);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, createJoint);
		}
		
		private function createJoint(e:MouseEvent):void {
			world.QueryPoint(queryCallback,mouseToWorld());
		}
		
		private function queryCallback(fixture:b2Fixture):Boolean
		{
			var touchedBody:b2Body=fixture.GetBody();
			if (touchedBody.GetType()==b2Body.b2_dynamicBody) {
				var jointDef:b2MouseJointDef=new b2MouseJointDef();
				jointDef.bodyA=world.GetGroundBody();
				jointDef.bodyB=touchedBody;
				jointDef.target=mouseToWorld();
				jointDef.maxForce=100*touchedBody.GetMass();
				mouseJoint=world.CreateJoint(jointDef) as b2MouseJoint;
				stage.addEventListener(MouseEvent.MOUSE_MOVE,moveJoint);
				stage.addEventListener(MouseEvent.MOUSE_UP,killJoint);
			}
			return false;
		}
		private function moveJoint(e:MouseEvent):void {
			mouseJoint.SetTarget(mouseToWorld());
		}
		
		private function killJoint(e:MouseEvent):void {
			world.DestroyJoint(mouseJoint);
			mouseJoint=null;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,
				moveJoint);
			stage.removeEventListener(MouseEvent.MOUSE_UP,
				killJoint);
		}
		
		private function mouseToWorld():b2Vec2 {
			return new b2Vec2(mouseX/worldScale,mouseY/worldScale);
		}
		
		private function updateWorld(e:Event):void {
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