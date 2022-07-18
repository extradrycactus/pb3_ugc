using UnityEngine;

public enum SpinAxis
{
    Y,
    X,
    Z,
}

public class Spin : MonoBehaviour
{
    public SpinAxis m_SpinAxis = SpinAxis.Y;
    public float speed = 10f;
    public bool reverse = false;
}