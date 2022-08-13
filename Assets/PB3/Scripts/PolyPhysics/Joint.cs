using Poly;
using UnityEngine;

namespace PolyPhysics
{
    public abstract class Joint : LoggingWorldObject
    {
        public Rigidbody connectedBody;
        public bool autoConfigureConnectedAnchor = true;
        public bool autoConfigureThisAnchor;

        [ShowIf("autoConfigureThisAnchor", reverse: true)] public Vector2 anchor;
        [ShowIf("autoConfigureConnectedAnchor", reverse: true)] public Vector2 connectedAnchor;
    }
}