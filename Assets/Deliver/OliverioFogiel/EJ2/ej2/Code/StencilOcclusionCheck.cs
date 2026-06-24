using UnityEngine;

public class StencilOcclusionCheck : MonoBehaviour
{
    [SerializeField] private Camera cam;
    [SerializeField] private Transform player;
    [SerializeField] private GameObject stencilSphere;
    [SerializeField] private LayerMask wallMask;

    private void Update()
    {
        Vector3 target = player.position + Vector3.up;

        Vector3 direction = target - cam.transform.position;
        float distance = direction.magnitude;

        bool blocked = Physics.Raycast(
            cam.transform.position,
            direction.normalized,
            distance,
            wallMask
        );

        stencilSphere.SetActive(blocked);
    }
}