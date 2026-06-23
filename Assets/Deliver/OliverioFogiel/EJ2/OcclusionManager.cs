using System.Collections.Generic;
using UnityEngine;

public class OcclusionManager : MonoBehaviour
{
    [Header("References")]
    [SerializeField] private Transform player;
    [SerializeField] private Camera gameplayCamera;

    [Header("Detection")]
    [SerializeField] private LayerMask occluderMask;
    [SerializeField] private float sphereCastRadius = 0.35f;

    [Header("Shader Values")]
    [SerializeField] private float cutoutRadius = 1.2f;
    [SerializeField] private float cutoutFade = 0.4f;
    [SerializeField] private float playerHeightOffset = 1f;

    [Header("Transition")]
    [SerializeField] private float transitionSpeed = 8f;

    private readonly List<Renderer> trackedRenderers = new();
    private readonly HashSet<Renderer> blockingRenderers = new();
    private readonly Dictionary<Renderer, float> cutoutAmounts = new();

    private MaterialPropertyBlock propertyBlock;

    private static readonly int CutoutCameraPos =
        Shader.PropertyToID("_CutoutCameraPos");

    private static readonly int CutoutTargetPos =
        Shader.PropertyToID("_CutoutTargetPos");

    private static readonly int CutoutRadius =
        Shader.PropertyToID("_CutoutRadius");

    private static readonly int CutoutFade =
        Shader.PropertyToID("_CutoutFade");

    private static readonly int CutoutActive =
        Shader.PropertyToID("_CutoutActive");

    private void Awake()
    {
        propertyBlock = new MaterialPropertyBlock();
    }

    private void LateUpdate()
    {
        if (player == null || gameplayCamera == null)
            return;

        blockingRenderers.Clear();

        Vector3 cameraPos = gameplayCamera.transform.position;
        Vector3 playerPos = player.position + Vector3.up * playerHeightOffset;

        Vector3 direction = playerPos - cameraPos;
        float distanceToPlayer = direction.magnitude;

        if (distanceToPlayer <= 0.01f)
            return;

        RaycastHit[] hits = Physics.SphereCastAll(
            cameraPos,
            sphereCastRadius,
            direction.normalized,
            distanceToPlayer,
            occluderMask,
            QueryTriggerInteraction.Ignore
        );

        foreach (RaycastHit hit in hits)
        {
            Renderer[] renderers = hit.collider.GetComponentsInChildren<Renderer>();

            foreach (Renderer currentRenderer in renderers)
            {
                if (currentRenderer == null)
                    continue;

                blockingRenderers.Add(currentRenderer);

                if (!trackedRenderers.Contains(currentRenderer))
                {
                    trackedRenderers.Add(currentRenderer);
                    cutoutAmounts[currentRenderer] = 0f;
                }
            }
        }

        UpdateAllCutouts(cameraPos, playerPos);
    }

    private void UpdateAllCutouts(Vector3 cameraPos, Vector3 playerPos)
    {
        for (int i = trackedRenderers.Count - 1; i >= 0; i--)
        {
            Renderer currentRenderer = trackedRenderers[i];

            if (currentRenderer == null)
            {
                trackedRenderers.RemoveAt(i);
                cutoutAmounts.Remove(currentRenderer);
                continue;
            }

            float currentAmount = cutoutAmounts[currentRenderer];
            float targetAmount = blockingRenderers.Contains(currentRenderer) ? 1f : 0f;

            currentAmount = Mathf.MoveTowards(
                currentAmount,
                targetAmount,
                transitionSpeed * Time.deltaTime
            );

            cutoutAmounts[currentRenderer] = currentAmount;

            currentRenderer.GetPropertyBlock(propertyBlock);

            propertyBlock.SetVector(CutoutCameraPos, cameraPos);
            propertyBlock.SetVector(CutoutTargetPos, playerPos);
            propertyBlock.SetFloat(CutoutRadius, cutoutRadius);
            propertyBlock.SetFloat(CutoutFade, cutoutFade);
            propertyBlock.SetFloat(CutoutActive, currentAmount);

            currentRenderer.SetPropertyBlock(propertyBlock);

            if (currentAmount <= 0f && targetAmount <= 0f)
            {
                trackedRenderers.RemoveAt(i);
                cutoutAmounts.Remove(currentRenderer);
            }
        }
    }

    private void OnDrawGizmosSelected()
    {
        if (player == null || gameplayCamera == null)
            return;

        Gizmos.color = Color.green;

        Vector3 cameraPos = gameplayCamera.transform.position;
        Vector3 playerPos = player.position + Vector3.up * playerHeightOffset;

        Gizmos.DrawLine(cameraPos, playerPos);
    }
}