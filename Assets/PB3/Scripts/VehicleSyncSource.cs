using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum VehicleSyncPart
{
	CHASSIS,
    WHEELS_BEGIN,
	WHEEL_FRONT = WHEELS_BEGIN,
	WHEEL_BACK,
    WHEEL_3rd_AXIS,
    WHEEL_4th_AXIS,
    WHEEL_5th_AXIS,
    WHEELS_END,
    CHASSIS_TRAILER // Don't reorder enum, unless we are also versioning vehicle assets.
}

public class VehicleSyncSource : MonoBehaviour
{
	public VehicleSyncPart m_VehicleSyncPart;
}
