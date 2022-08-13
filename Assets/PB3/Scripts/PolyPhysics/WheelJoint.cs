using Poly;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace PolyPhysics
{
    [RequireComponent(typeof(Rigidbody))]
    public class WheelJoint : Joint
    {
        [Range(0f, 1f)]
        public float stiffness = 1f;
        [Range(0f, 1f)]
        public float damping = 1f;

        [Header("Prismatic movement")]

        [Tooltip("Prismatic movement is oriented in the Y direction")]
        public bool enablePrismaticMovement;
        [ShowIf("enablePrismaticMovement")] public Vector2 prismaticAxis = Vector2.up;
        [ShowIf("enablePrismaticMovement")] public Vector2 prismaticLimits = new Vector2(-0.1f, 0.1f);

        [Header("Spring action")]
        public bool enableSpring;
        [ShowIf("enableSpring")] public float springConstant = 1000f;
        [ShowIf("enableSpring")] public float dampingConstant = 1000f; //< [N * sec / m]
        [ShowIf("enableSpring")] public float dampingConstantMultiplier = 0.02f / 4f;
        [ShowIf("enableSpring")] public float regressionFixup_DampingMultiplier = 2f;

        [Header("Motor")]
        public bool enableMotor;
        [NonSerialized] public bool useSimpleVelocityMotor; // Uses for pinned custom shapes
        [ShowIf("enableMotor")] public bool idleOnDownhill;
        [ShowIf("enableMotor")] public float targetMotorVelocity = 360f;
        [ShowIf("enableMotor")] public float maxMotorTorque = 1f;
        [ShowIf("enableMotor")] public float brakingForceMultiplier = 1f;
        [ShowIf("enableMotor")] public float highSpeedBrakingForceMultiplier = 1f;

        [Header("Acceleration Control")]
        [ShowIf("enableMotor")] public float desiredAcceleration = float.PositiveInfinity;
        [ShowIf("enableMotor")] public float topSpeed = float.PositiveInfinity;
    }
}