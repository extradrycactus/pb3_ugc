using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public enum VehicleSplashSize
{
    SMALL,
    MEDIUM,
    LARGE
}

public class Vehicle : MonoBehaviour
{
	[Header("Required")]
    public string m_DisplayName;
    public VehicleSplashSize m_SplashSize;
    [ColorUsage(true, true)] public Color m_DominantColor;

	[Header("Advanced/Optional")]
	public GameObject m_DayLights;
	public GameObject m_NightLights;
    public GameObject m_SecondaryDayLights;
    public GameObject m_SecondaryNightLights;
    public GameObject m_WheelFillMesh;
    public GameObject m_WheelFillMeshBack;
    public SpriteRenderer m_OutlineSprite;

	[Header("Do Not Edit")]
    public Transform m_ScalingTransform;
    public MeshRenderer m_MeshRenderer;
	public GameObject m_PhysicsPrefab;
    public Transform m_GameplayTriggers;
    public BoxCollider m_StaticBoundingBox;
}