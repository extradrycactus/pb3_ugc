using UnityEngine;

#pragma warning disable 0414
namespace Common.Determinism
{
    public class OrderedBehaviour : Common.Class.BaseMonoBehaviour
    {
        [SerializeField] private int _persistentId = -1;
    }
}
