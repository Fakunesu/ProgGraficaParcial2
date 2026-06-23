using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Water2DLevelController : MonoBehaviour
{
    [Header("Detección")]
    [Tooltip("Transform que define desde dónde se hace la detección. Si está vacío, se usa este mismo objeto.")]
    public Transform detectionOrigin;

    [Tooltip("Offset adicional (en espacio local del origen) respecto al punto de detección")]
    public Vector3 detectionOffset = Vector3.zero;

    [Tooltip("Tamaño COMPLETO de la caja de detección (no half-extents)")]
    public Vector3 boxSize = new Vector3(10f, 5f, 10f);

    [Tooltip("Si está activo, la caja rota junto con el 'detectionOrigin'. Si no, siempre queda alineada a los ejes del mundo.")]
    public bool useOriginRotation = false;

    [Tooltip("Capa(s) de los objetos que afectan el nivel del agua")]
    public LayerMask objectsLayer;

    [Header("Distancias de influencia (para el cálculo del nivel)")]
    [Tooltip("Distancia desde el centro de detección a partir de la cual un objeto ya no influye (nivel = 0.5)")]
    public float maxDistance = 10f;

    [Tooltip("Distancia a la que un objeto genera la influencia máxima (nivel = 1)")]
    public float minDistance = 1f;

    [Header("Suavizado")]
    [Tooltip("Qué tan rápido se interpola hacia el nivel objetivo. Mayor = más rápido")]
    public float smoothSpeed = 2f;

    [Header("Shader")]
    [Tooltip("Nombre de la propiedad float en el shader (debe coincidir exactamente)")]
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

        Collider[] nearbyObjects = Physics.OverlapBox(center, boxSize * 0.5f, rotation, objectsLayer);

        if (nearbyObjects.Length == 0)
        {
            // Sin objetos cerca -> nivel mínimo permitido
            return 0.5f;
        }

        float closestDistance = maxDistance;

        foreach (Collider col in nearbyObjects)
        {
            float dist = Vector3.Distance(center, col.transform.position);
            if (dist < closestDistance)
            {
                closestDistance = dist;
            }
        }

        // Normaliza la distancia: 0 = lejos (maxDistance), 1 = cerca (minDistance)
        float t = Mathf.InverseLerp(maxDistance, minDistance, closestDistance);
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

    // Útil para ver el área de detección y los rangos de influencia en el editor
    void OnDrawGizmosSelected()
    {
        Vector3 center = GetDetectionCenter();
        Quaternion rotation = GetDetectionRotation();

        // Caja de detección (respeta rotación si useOriginRotation está activo)
        Gizmos.color = Color.cyan;
        Matrix4x4 oldMatrix = Gizmos.matrix;
        Gizmos.matrix = Matrix4x4.TRS(center, rotation, Vector3.one);
        Gizmos.DrawWireCube(Vector3.zero, boxSize);
        Gizmos.matrix = oldMatrix;
    }
}
