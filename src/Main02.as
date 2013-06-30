package
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	/**
	 * 碰撞检测
	 * @author LC
	 */
	[SWF(width="640", height="480", backgroundColor="0x333333", frameRate="30")]
	public class Main02 extends Sprite
	{		
		private var world:b2World;
		private var worldScale:Number=30;
		private var theBird:Sprite=new Sprite();
		private var slingX:int=100;
		private var slingY:int=250;
		private var slingR:int = 75;
		
		public function Main02()
		{
			super();
			world=new b2World(new b2Vec2(0,9.81),true);
			world.SetContactListener(new customContact());
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(320/worldScale,30/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
			bodyDef.userData="Ball";
			var circleShape:b2CircleShape;
			circleShape = new b2CircleShape(25/worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.6;
			fixtureDef.friction = 0.1;
			var theBall:b2Body = world.CreateBody(bodyDef);
			theBall.CreateFixture(fixtureDef);
			bodyDef.position.Set(320/worldScale,470/worldScale);
			bodyDef.type=b2Body.b2_staticBody;
			bodyDef.userData="Floor";
			var polygonShape:b2PolygonShape=new b2PolygonShape();
			polygonShape.SetAsBox(320/worldScale,10/worldScale);
			fixtureDef.shape=polygonShape;
			var theFloor:b2Body=world.CreateBody(bodyDef);
			theFloor.CreateFixture(fixtureDef);
			var debugDraw:b2DebugDraw=new b2DebugDraw();
			var debugSprite:Sprite=new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
			addEventListener(Event.ENTER_FRAME,updateWorld);
		}
		
		private function updateWorld(e:Event):void {
			world.Step(1/30,10,10);
			world.ClearForces();
			world.DrawDebugData();
		}
	}
}