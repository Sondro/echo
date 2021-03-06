package state;

import hxmath.math.Vector2;
import echo.Body;
import echo.Group;
import echo.World;
import glib.FSM;
import glib.Random;

using echo.Echo;

class GroupsState extends State<World> {
  var body_count:Int = 50;
  var circles:Group;
  var rects:Group;
  var floors:Group;
  var timer:Float;

  override public function enter(world:World) {
    Main.state_text.text = "Sample: Group Collisions";
    timer = 0;
    // And split them between the two groups
    circles = new Group();
    rects = new Group();
    floors = new Group();

    // Add some platforms for the bodies to bounce off of
    // Setting the Mass to 0 makes them unmovable
    for (i in 0...4) {
      var floor = new Body({
        mass: 0,
        x: (world.width / 4) * i + (world.width / 8),
        y: world.height - 30,
        elasticity: 0.3,
        shape: {
          type: RECT,
          width: world.width / 8,
          height: 10
        }
      });
      floors.add(floor);
      world.add(floor);
    }

    world.listen(circles, rects);
    world.listen(circles, floors);
    world.listen(rects, floors);
  }

  override function update(world:World, dt:Float) {
    timer += dt;
    if (timer > 0.3 + Random.range(-0.2, 0.2)) {
      if (circles.members.length < body_count) launch(world.add(circles.add(make_circle())), world, true);
      else {
        var found = false;
        for (member in circles.members) {
          if (found) continue;
          if (offscreen(member, world)) {
            launch(member, world, true);
            found = true;
          }
        }
      }

      if (rects.members.length < body_count) launch(world.add(rects.add(make_rect())), world, false);
      else {
        var found = false;
        for (member in rects.members) {
          if (found) continue;
          if (offscreen(member, world)) {
            launch(member, world, false);
            found = true;
          }
        }
      }

      timer = 0;
    }
  }

  override public function exit(world:World) world.clear();

  inline function make_circle():Body return new Body({
    elasticity: 0.5,
    shape: {
      type: CIRCLE,
      radius: Random.range(16, 32)
    }
  });

  inline function make_rect():Body return new Body({
    elasticity: 0.5,
    shape: {
      type: RECT,
      width: Random.range(32, 64),
      height: Random.range(32, 64)
    }
  });

  inline function launch(b:Body, w:World, left:Bool) {
    b.position.set(left ? 20 : w.width - 20, w.height / 2);
    b.velocity.set(left ? 130 : -130, hxd.Math.lerp(-60, 20, Main.scene.mouseY / w.height));
  }

  inline function offscreen(b:Body, world:World) return b.y + b.shape.top > world.height || b.x + b.shape.right < 0 || b.x + b.shape.left > world.width;
}
