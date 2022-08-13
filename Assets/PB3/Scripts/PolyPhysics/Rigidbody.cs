namespace PolyPhysics
{
    public class Rigidbody : LoggingWorldObject, IEntity
    {
        public float _mass = 1f;
        public float inertiaMultiplierDebug = 1f;
        public bool requestFullRecollision;
        public Rigidbody _collisionGroupParent;
    }
}
