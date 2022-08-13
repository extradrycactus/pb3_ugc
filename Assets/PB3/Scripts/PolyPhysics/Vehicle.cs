using System;
using UnityEngine;

#pragma warning disable 0414
namespace PolyPhysics
{
    [SelectionBase]
    public class Vehicle : Action
    {
        [Header("Designer Balanced")]

        [Range(0.1f, 100f), SerializeField]
        [Tooltip("MASS: Scales mass of wheels & chassis proportionally, to reach this total mass.")]
        private float _mass;

        [Range(-30f, 30f), SerializeField]
        [Tooltip("SPEED: Vehicle will try to achieve this velocity, if engine is strong enough.")]
        public float _targetVelocity;

        [Range(0.1f, 100f), SerializeField]
        [Tooltip("ACC: Desired acceleration & deceleration till target velocity is achieved. Effective acceleration is limited by engine strength.")]
        private float _desiredAcceleration;

        [Range(0.1f, 100f), SerializeField]
        [Tooltip("HP: Define strength of engine, by max acceleration on level ground.")]
        private float _acceleration;

        [Range(0.1f, 100f), SerializeField]
        [Tooltip("BREAKING: Multiplies desired deceleration and also defines strength of brakes as a multiplier of engine strength.")]
        private float _brakingForceMultiplier = 1f;

        [Range(0.1f, 3f), SerializeField]
        [Tooltip("SHOCKS: Scale shocks strength & damping relatively to vehicle mass.")]
        private float _shocksMultiplier = 1f;

        [SerializeField]
        [Tooltip("IDLE: If acceleration/deceleration & velocity can be increased above given desired values by using gravity, it is done. When above target velocity, engine is disengaged and gravity is still used for acceleration.")]
        private bool _idleOnDownhill;

        [Header("Velocity control")]

        [SerializeField]
        [Tooltip("Multiplies desired deceleration and also defines strength of brakes as a multiplier of engine strength. Applied at high speed (>= 2x topSpeed)")]
        private float _highSpeedBrakingForceMultiplier = 1f;

        public enum StrengthMethod { Acceleration, MaxSlope, TorquePerWheel }

        [Header("Engine strength & torque profile")]

        [SerializeField]
        [Tooltip("Define max engine strength by max acceleration, or max slope the vehicle can climb.")]
        private StrengthMethod _method;

        [Range(0.1f, 90f), SerializeField]
        [Tooltip("Define strength of engine, by max slope the car can continue climbing at constant speed.")]
        private float _maxSlope;

        [Range(0.1f, 100f), SerializeField, Obsolete]
        private float _torquePerWheel; // ignored for now

        [Range(0.1f, 10000f), SerializeField]
        [Tooltip("Determines speed at which torque is zero. Torque is linearly interpolated from max value at zero speed, to zero value at top speed.")]
        private float _topSpeed = float.PositiveInfinity;

        [Range(0f, 10f), SerializeField]
        [Tooltip("If non-zero, used in the gameplay code to set top-speed as a multiple of targetSpeed.")]
        public float _topSpeedMultiplier;

        [Header("Suspension control")]
        [Tooltip("Automatically scale shocks strength & damping proportionally to vehicle mass.")]
        public bool scaleShocksWithMass = true;

        [Header("Gameplay orientation")]

        [SerializeField]
        private bool _isFlipped;
    }
}