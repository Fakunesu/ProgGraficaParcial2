using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Water2DLevelController : MonoBehaviour
{
    [Header("Detección")]
    public Transform detectionOrigin;
    public Vector3 detectionOffset = Vector3.zero;

    [Tooltip("Tamaño de la caja de detección. X y Z definen el área horizontal; Y define el rango vertical considerado. Si querés ignorar X/Z, poné valores grandes ahí.")]
    public Vector3 boxSize = new Vector3(10f, 5f, 10f);

    public bool useOriginRotation = false;

    public LayerMask objectsLayer;

    [Header("Distancias de influencia (para el cálculo del nivel)")]
    [Tooltip("Distancia vertical (eje Y) a partir de la cual un objeto ya no influye (nivel = 0.5)")]
    public float maxDistance = 10f;

    [Tooltip("Distancia vertical (eje Y) a la que un objeto genera la influencia máxima (nivel = 1)")]
    public float minDistance = 1f;

    [Header("Suavizado")]
    public float smoothSpeed = 2f;

    [Header("Shader")]
    public string shaderPropertyName = "_WaterLevel";

    private float currentWaterLevel = 0.5f;
    [SerializeField] private Material waterMaterial;

    void Update()
    {
        float targetLevel = CalculateTargetWaterLevel();

        // Interpolación suave hacia el valor objetivo (evita saltos bruscos)
        currentWaterLevel = Mathf.Lerp(currentWaterLevel, targetLevel, Time.deltaTime * smoothSpeed);

        ApplyToShader(currentWaterLevel);
    }

    private Vector3 GetDetectionCenter()
    {
        Transform origin = detectionOrigin != null ? detectionOrigin : transform;
        return origin.position + origin.TransformDirection(detectionOffset);
    }

    private Quaternion GetDetectionRotation()
    {
        if (!useOriginRotation)
        {
            return Quaternion.identity;
        }

        Transform origin = detectionOrigin != null ? detectionOrigin : transform;
        return origin.rotation;
    }

    private float CalculateTargetWaterLevel()
    {
        Vector3 center = GetDetectionCenter();
        Quaternion rotation = GetDetectionRotation();

        // El box decide QUÉ objetos se detectan (incluyendo el rango horizontal si lo limitás)
        Collider[] nearbyObjects = Physics.OverlapBox(center, boxSize * 0.5f, rotation, objectsLayer);

        if (nearbyObjects.Length == 0)
        {
            // Sin objetos detectados -> nivel mínimo permitido
            return 0.5f;
        }

        float closestVerticalDistance = maxDistance;

        foreach (Collider col in nearbyObjects)
        {
            // Solo nos importa qué tan cerca está en el eje Y; X y Z se ignoran a propósito
            float verticalDist = Mathf.Abs(center.y - col.transform.position.y);
            if (verticalDist < closestVerticalDistance)
            {
                closestVerticalDistance = verticalDist;
            }
        }

        // Normaliza la distancia vertical: 0 = lejos (maxDistance), 1 = cerca (minDistance)
        float t = Mathf.InverseLerp(maxDistance, minDistance, closestVerticalDistance);
        t = Mathf.Clamp01(t);

        // Remapea siempre al rango [0.5, 1]
        return Mathf.Lerp(0.5f, 1f, t);
    }

    private void ApplyToShader(float level)
    {
        if (waterMaterial != null)
        {
            waterMaterial.SetFloat(shaderPropertyName, level);
        }
    }

    // Útil para ver el área de detección en el editor
    void OnDrawGizmosSelected()
    {
        Vector3 center = GetDetectionCenter();
        Quaternion rotation = GetDetectionRotation();

        Gizmos.color = Color.cyan;
        Matrix4x4 oldMatrix = Gizmos.matrix;
        Gizmos.matrix = Matrix4x4.TRS(center, rotation, Vector3.one);
        Gizmos.DrawWireCube(Vector3.zero, boxSize);
        Gizmos.matrix = oldMatrix;
    }
}
