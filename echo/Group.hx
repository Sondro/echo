package echo;

import glib.Disposable;
import echo.Echo;
/**
 * Container for storing a collection of Bodies. Use these to group Bodies for a `Listener`
 *
 * TODO: Make a `Typed` version of this
 */
class Group implements IEcho implements IDisposable {
  public var members:Array<Body>;
  public var type(default, null):EchoType;

  public function new(?members:Array<Body>) {
    this.members = members == null ? [] : members;
    type = GROUP;
  }

  public function add(body:Body):Body {
    members.remove(body);
    members.push(body);
    return body;
  }

  public function remove(body:Body):Body {
    members.remove(body);
    return body;
  }

  public function clear() {
    members = [];
  }

  public function dispose() members = null;
}
