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
	 * 
	 * @author LC
	 */
	[SWF(width="640", height="480", backgroundColor="0x333333", frameRate="30")]
	public class Main01 extends Sprite
	{
		private var world:b2World;
		private var worldScale:Number=30;
		private var theBird:Sprite=new Sprite();
		private var slingX:int=100;
		private var slingY:int=250;
		private var slingR:int = 75;
		
		public function Main01()
		{
			super();
			world=new b2World(new b2Vec2(0,5),true);
			debugDraw();
			floor();
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
			var slingCanvas:Sprite=new Sprite();
			slingCanvas.graphics.lineStyle(1,0xffffff);
			slingCanvas.graphics.drawCircle(0,0,slingR);
			addChild(slingCanvas);
			slingCanvas.x=slingX;
			slingCanvas.y=slingY;
			theBird.graphics.lineStyle(1,0xfffffff);
			theBird.graphics.beginFill(0xffffff);
			theBird.graphics.drawCircle(0,0,15);
			addChild(theBird);
			theBird.x=slingX;
			theBird.y=slingY;
			theBird.addEventListener(MouseEvent.MOUSE_DOWN, birdClick);
			addEventListener(Event.ENTER_FRAME,updateWorld);
		}
		
		private function birdClick(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, birdMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, birdRelease);
			theBird.removeEventListener(MouseEvent.MOUSE_DOWN, birdClick);
		}
		
		private function birdMove(e:MouseEvent):void {
			theBird.x=mouseX;
			theBird.y=mouseY;
			var distanceX:Number=theBird.x-slingX;
			var distanceY:Number=theBird.y-slingY;
			if (distanceX*distanceX+distanceY*distanceY>slingR*slingR) {
				var birdAngle:Number=Math.atan2(distanceY,distanceX);
				theBird.x=slingX+slingR*Math.cos(birdAngle);
				theBird.y=slingY+slingR*Math.sin(birdAngle);
			}
		}
		
		private function birdRelease(e:MouseEvent):void {
			trace("bird released at "+theBird.x+","+theBird.y);
			var distanceX:Number = theBird.x-slingX;
			var distanceY:Number=theBird.y-slingY;
			var velocityX:Number=distanceX*-1/5;
			var velocityY:Number=distanceY*-1/5;
			var birdVelocity:b2Vec2=new b2Vec2(velocityX,velocityY);
			var sphereX:Number=theBird.x/worldScale;
			var sphereY:Number=theBird.y/worldScale;
			var r:Number = 15/worldScale;
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(sphereX,sphereY);
			bodyDef.type=b2Body.b2_dynamicBody;
			var circleShape:b2CircleShape=new b2CircleShape(r);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape=circleShape;
			fixtureDef.density=4;
			fixtureDef.restitution=0.4;
			fixtureDef.friction = 0.5;
			var physicsBird:b2Body = world.CreateBody(bodyDef);
			physicsBird.CreateFixture(fixtureDef);
			physicsBird.SetLinearVelocity(birdVelocity);
			removeChild(theBird);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,birdMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,birdRelease);
		}	
		
		private function brick(pX:int,pY:int,w:Number,h:Number):void{
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
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
		
		private function floor():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(320/worldScale,465/worldScale);
			var polygonShape:b2PolygonShape=new b2PolygonShape();
			polygonShape.SetAsBox(320/worldScale,15/worldScale);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape=polygonShape;
			fixtureDef.restitution=0.4;
			fixtureDef.friction=0.5;
			var theFloor:b2Body=world.CreateBody(bodyDef);
			theFloor.CreateFixture(fixtureDef);
		}
		
		private function debugDraw():void {
			var debugDraw:b2DebugDraw=new b2DebugDraw();
			var debugSprite:Sprite=new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		
		private function updateWorld(e:Event):void {
			world.Step(1/30,10,10);
			world.ClearForces();
			world.DrawDebugData();
		}
	}
}