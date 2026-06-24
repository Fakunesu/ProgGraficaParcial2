using UnityEngine;

public class SideCameraFollow : MonoBehaviour
{
    [SerializeField] private Transform player;

    [Header("Camera Position")]
    [SerializeField] private float offsetX = 0f;
    [SerializeField] private float offsetY = 1.5f;
    [SerializeField] private float fixedZ = -10f;

    [Header("Smooth Follow")]
    [SerializeField] private float smoothSpeed = 8f;

    private void LateUpdate()
    {
        if (player == null)
            return;

        Vector3 targetPosition = new Vector3(
            player.position.x + offsetX,
            player.position.y + offsetY,
            fixedZ
        );

        transform.position = Vector3.Lerp(
            transform.position,
            targetPosition,
            smoothSpeed * Time.deltaTime
        );
    }
}