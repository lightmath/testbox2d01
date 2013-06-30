package
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	
	public class customContact extends b2ContactListener
	{
		private const KILLBRICK:Number=5;
		private const KILLPIG:Number=1;
		
		override public function BeginContact(contact:b2Contact):void
		{
//			trace("a collision started");
			var fixtureA:b2Fixture=contact.GetFixtureA();
			var fixtureB:b2Fixture=contact.GetFixtureB();
			var bodyA:b2Body=fixtureA.GetBody();
			var bodyB:b2Body=fixtureB.GetBody();
//			trace("first body: "+bodyA.GetUserData());
//			trace("second body: "+bodyB.GetUserData());
//			trace("---------------------------");
		}
		
		override public function EndContact(contact:b2Contact):void
		{
//			trace("a collision ended");
			var fixtureA:b2Fixture=contact.GetFixtureA();
			var fixtureB:b2Fixture=contact.GetFixtureB();
			var bodyA:b2Body=fixtureA.GetBody();
			var bodyB:b2Body=fixtureB.GetBody();
//			trace("first body: "+bodyA.GetUserData());
//			trace("second body: "+bodyB.GetUserData());
//			trace("---------------------------");
		}
		
		override public function PreSolve(contact:b2Contact,
										  oldManifold:b2Manifold):void {
			if (contact.GetManifold().m_pointCount>0) {
				trace("a collision has been pre solved");
				var fixtureA:b2Fixture=contact.GetFixtureA();
				var fixtureB:b2Fixture=contact.GetFixtureB();
				var bodyA:b2Body=fixtureA.GetBody();
				var bodyB:b2Body=fixtureB.GetBody();
				trace("first body: "+bodyA.GetUserData());
				trace("second body: "+bodyB.GetUserData());
				trace("---------------------------");
			}
			
//			var fixtureA:b2Fixture=contact.GetFixtureA();
//			var fixtureB:b2Fixture=contact.GetFixtureB();
//			var dataA:String=fixtureA.GetBody().GetUserData();
//			var dataB:String=fixtureB.GetBody().GetUserData();
//			if (dataA=="cart" && dataB=="projectile") {
//				contact.SetEnabled(false);
//			}
//			if (dataB=="cart" && dataA=="projectile") {
//				contact.SetEnabled(false);
//			}
		}
		
		override public function PostSolve(contact:b2Contact,impulse:b2ContactImpulse):void 
		{
			var fixtureA:b2Fixture=contact.GetFixtureA();
			var fixtureB:b2Fixture=contact.GetFixtureB();
			var dataA:String=fixtureA.GetBody().GetUserData();
			var dataB:String=fixtureB.GetBody().GetUserData();
			var force:Number=impulse.normalImpulses[0];
			switch (dataA) {
				case "pig" :
					if (force>KILLPIG) {
						fixtureA.GetBody().SetUserData("remove");
					}
					break;
				case "brick" :
					if (force>KILLBRICK) {
						fixtureA.GetBody().SetUserData("remove");
					}
					break;
			}
			switch (dataB) {
				case "pig":
					if(force>KILLPIG)
					{
						fixtureB.GetBody().SetUserData("remove");
					}
					break;
				case "brick" :
					if (force>KILLBRICK) {
						fixtureB.GetBody().SetUserData("remove");
					}
					break;
			}
		}
		
	}
}