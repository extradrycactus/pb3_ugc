using UnityEngine;
using UnityEngine.Serialization;

public enum ZedAxisVehicleType
{
    BOAT,
    PLANE,
    TRAIN,
}

public class ZedAxisVehicle : MonoBehaviour
{
	[Header("Required")]
    public string m_DisplayName;
	public ZedAxisVehicleType m_Type;
	public float m_DefaultSpeed;

    [Header("Advanced/Optional")]
	public GameObject m_DayLights;
	public GameObject m_NightLights;
    public string m_InAudioGroup = "[None]";
    public string m_LoopAudioGroup = "[None]";
    public string m_OutAudioGroup = "[None]";

	[Header("Do Not Edit")]
    public CuttingController_TwoPlanes [] m_CuttingPlaneControllers;
    public MeshRenderer m_MeshRenderer;
    public Transform m_ScalingTransform;
    public MeshRenderer m_OutlineMeshRenderer;
    public MeshFilter m_OutlineMeshFilter;
	public GameObject m_PhysicsPrefab;
    public GameObject m_ProfileOutlines;

}