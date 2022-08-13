using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VehicleSyncTarget : MonoBehaviour
{
    public enum Type
    {
        Invalid,
        GameplayTrigger, 
        VisualMesh
    }

	public VehicleSyncPart m_VehicleSyncPart;
    public Type m_type;
}
