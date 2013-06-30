package
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * 
	 * @author LC
	 */
	[SWF(width="640", height="480", backgroundColor="0x333333", frameRate="30")]
	public class Main extends Sprite
	{
		
		private var world:b2World;
		private var sphereVector:Vector.<b2Body>;
		public function Main()
		{
			world=new b2World(new b2Vec2(0,5),true);
			debugDraw();
//			addChild(textMon);
//			textMon.textColor=0xffffff;
//			textMon.width=300;
//			textMon.height=300;
//			textFormat.size=25;
//			textMon.defaultTextFormat=textFormat;
//			brick(275,435,30,30, "breakable");
//			brick(365,435,30,30, "breakable");
//			brick(320,405,120,30, "breakable");
//			brick(320,375,60,30, "unbreakable");
//			brick(305,345,90,30, "breakable");
//			brick(320,300,120,60, "unbreakable");
//			idol(320,242);
			floor();
			sphereVector=new Vector.<b2Body>();
			for (var i:int=0; i<3; i++) {
				sphereVector.push(sphere(170+i*150,410,40));
			}
			var force:b2Vec2=new b2Vec2(0,-15);
			var forceByMass:b2Vec2=force.Copy();
			forceByMass.Multiply(sphereVector[1].GetMass());
			var forceByMassByTime:b2Vec2=forceByMass.Copy();
			forceByMassByTime.Multiply(30);
			var sphereCenter:b2Vec2=sphereVector[0].GetWorldCenter();
			sphereVector[0].ApplyForce(forceByMassByTime,sphereCenter);
			sphereCenter=sphereVector[1].GetWorldCenter();
			sphereVector[1].ApplyImpulse(forceByMass,sphereCenter);
			sphereVector[2].SetLinearVelocity(force);
			addEventListener(Event.ENTER_FRAME,updateWorld);
//			stage.addEventListener(MouseEvent.CLICK, destroyBrick);
		}
		
		private function sphere(pX:int, pY:int, r:Number):b2Body
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(pX/worldScale, pY/worldScale);
			bodyDef.type = b2Body.b2_dynamicBody;
			var obj:Object = {};
			obj.visible = true;
			obj.pY = pY;
			bodyDef.userData = obj;
			var circleShape:b2CircleShape = new b2CircleShape(r/worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.4;
			fixtureDef.friction=0.5;
			var theSphere:b2Body=world.CreateBody(bodyDef);
			theSphere.CreateFixture(fixtureDef);
			return theSphere;
		}
		
		private var worldScale:Number = 30;
		private function floor():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(320/worldScale, 465/worldScale);
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(320/worldScale, 15/worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.restitution = 0.4;
			fixtureDef.friction = 0.5;
			var theFloor:b2Body = world.CreateBody(bodyDef);
			theFloor.CreateFixture(fixtureDef);
		}
		
		private function brick(pX:int,pY:int,w:Number,h:Number, s:String):void {
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
			var data:Object = {};
			data.visible = true;
			data.s = s;
			bodyDef.userData = data;
			var polygonShape:b2PolygonShape=new b2PolygonShape();
			polygonShape.SetAsBox(w/2/worldScale,h/2/worldScale);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape=polygonShape;
			fixtureDef.density=2;
			fixtureDef.restitution=0.4;
			fixtureDef.friction=0.5;
			var theBrick:b2Body=world.CreateBody(bodyDef);
			theBrick.CreateFixture(fixtureDef);
		}
		
		private function idol(pX:Number,pY:Number):void {
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			bodyDef.type=b2Body.b2_dynamicBody;
			var obj:Object = {};
			obj.visible = true;
			obj.s = "idol";
			bodyDef.userData = obj;
			var polygonShape:b2PolygonShape=new b2PolygonShape();
			polygonShape.SetAsBox(5/worldScale,20/worldScale);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape=polygonShape;
			fixtureDef.density=1;
			fixtureDef.restitution=0.4;
			fixtureDef.friction=0.5;
			var theIdol:b2Body=world.CreateBody(bodyDef);
			theIdol.CreateFixture(fixtureDef);
			var bW:Number = 5/worldScale;
			var bH:Number = 20/worldScale;
			var boxPos:b2Vec2 = new b2Vec2(0,10/worldScale);
			var boxAngle:Number = -Math.PI/4;
			polygonShape.SetAsOrientedBox(bW,bH,boxPos,boxAngle);
			fixtureDef.shape = polygonShape;
			theIdol.CreateFixture(fixtureDef);
			boxAngle = Math.PI/4;
			polygonShape.SetAsOrientedBox(bW,bH,boxPos,boxAngle);
			fixtureDef.shape=polygonShape;
			theIdol.CreateFixture(fixtureDef);
			var vertices:Vector.<b2Vec2>=new Vector.<b2Vec2>();
			vertices.push(new b2Vec2(-15/worldScale, -25/worldScale));
			vertices.push(new b2Vec2(0,-40/worldScale));
			vertices.push(new b2Vec2(15/worldScale, -25/worldScale));
			vertices.push(new b2Vec2(0,-10/worldScale));
			polygonShape.SetAsVector(vertices,4);
			fixtureDef.shape=polygonShape;
			theIdol.CreateFixture(fixtureDef);
		}
		
		private var textMon:TextField = new TextField();
		private var textFormat:TextFormat = new TextFormat();
		private function updateWorld(e:Event):void
		{
			var maxHeight:Number;
			var currHeight:Number;
			var outHeight:Number;
			world.Step(1/30,10,10);
			for (var i:int=0; i<3; i++) 
			{
				var obj:Object = sphereVector[i].GetUserData();
				maxHeight=obj.pY;
				currHeight=sphereVector[i].GetPosition().y*worldScale;
				maxHeight=Math.min(maxHeight,currHeight);
				obj.pY = maxHeight;
				sphereVector[i].SetUserData(obj);
				outHeight=obj.pY;
				trace("Sphere "+i+":"+Math.round(outHeight));
			}
			trace("---------------");
			world.ClearForces();
			world.DrawDebugData();
			
			
//			var radToDeg:Number = 180/Math.PI;
//			world.Step(1/30,10,10);
//			world.ClearForces();
//			for (var b:b2Body=world.GetBodyList(); b; b=b.GetNext()) {
//				if (b.GetUserData() && b.GetUserData()["s"]=="idol") {
//					var position:b2Vec2=b.GetPosition();
//					var xPos:Number=Math.round(position.x*worldScale);
//					textMon.text=xPos.toString();
//					textMon.appendText(",");
//					var yPos:Number=Math.round(position.y*worldScale);
//					textMon.appendText(yPos.toString());
//					textMon.appendText("\nangle: ");
//					var angle:Number=Math.round(b.GetAngle()*radToDeg);
//					textMon.appendText(angle.toString());
//					textMon.appendText("\nVelocity: ");
//					var velocity:b2Vec2=b.GetLinearVelocity();
//					var xVel:Number=Math.round(velocity.x*worldScale);
//					textMon.appendText(xVel.toString());
//					textMon.appendText(",");
//					var yVel:Number=Math.round(velocity.y*worldScale);
//					textMon.appendText(yVel.toString());
//				}
//			}
//			world.DrawDebugData();
		}
		
		private function destroyBrick(e:MouseEvent):void
		{
			var px:Number = mouseX/worldScale;
			var py:Number = mouseY/worldScale;
			world.QueryPoint(queryCallback,new b2Vec2(px,py));
			
		}
		
		private function queryCallback(fixture:b2Fixture):Boolean
		{
			var touchedBody:b2Body = fixture.GetBody();
			trace(touchedBody);
			if(touchedBody.GetUserData() && touchedBody.GetUserData()["s"] == "breakable")
			{
				world.DestroyBody(touchedBody);
			}
			return false;
		}
		
		private function debugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			debugDraw.SetAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		
	}
}