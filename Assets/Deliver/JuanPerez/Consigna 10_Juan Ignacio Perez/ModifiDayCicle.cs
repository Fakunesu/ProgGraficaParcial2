using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModifiDayCicle : MonoBehaviour
{
    public enum SpinAxis { Horizontal, Vertical }

    [SerializeField] private GameObject directionalLight;
    [SerializeField] private Projector projector;

    [SerializeField] private float currentRotation;
    [SerializeField] private Material windowMaterial;

    [SerializeField] private Color lightColor;
    [SerializeField] private Color darkColor;

    [SerializeField] private float rotationSpeed = 10f;
    public SpinAxis spinAxis = SpinAxis.Vertical;

    private float currentAngle = 0f;
    private Quaternion baseRotation;

    void Awake()
    {
        // Guardamos la rotación inicial del objeto (la que tenga puesta en el editor/escena)
        baseRotation = projector.transform.localRotation;
    }

    void Update()
    {
        // --- 1) Avanzar el ángulo (si rotás manualmente desde aquí) ---
        currentAngle += rotationSpeed * Time.deltaTime;

        // --- 2) Reiniciar a 0 si supera 360° ---
        if (currentAngle >= 360f)
        {
            currentAngle -= 360f; // resta en vez de "= 0" para no perder el remanente del frame
        }

        // --- 3) Elegir el eje de giro según la opción seleccionada ---
        Vector3 axis = (spinAxis == SpinAxis.Vertical) ? Vector3.right : Vector3.up;

        // --- 4) Aplicar el giro SOBRE la rotación base (no la pisa) ---
        projector.transform.localRotation = baseRotation * Quaternion.AngleAxis(currentAngle, axis);

        if (directionalLight)
        {
            directionalLight.transform.localRotation = baseRotation * Quaternion.AngleAxis(currentAngle, axis);
        } 

        // --- 5) Calcular el factor de mezcla (0 = lightColor, 1 = darkColor) ---
        // PingPong(angle, 180): sube 0->180 y baja 180->0, justo lo que necesitamos.
        float t = Mathf.PingPong(currentAngle, 180f) / 180f;

        Color blended = Color.Lerp(lightColor, darkColor, t);

        // --- 6) Aplicar el color resultante ---
        if (windowMaterial != null)
            windowMaterial.SetColor("_LightColor", blended);

        if (projector != null)
            projector.material = windowMaterial;
    }

    /// <summary>
    /// Si la rotación viene de otro lado (animación, otro script, input del usuario, etc.),
    /// no llames al Update de este script y usá este método pasándole el ángulo actual (0-360).
    /// </summary>
    public Color GetColorForAngle(float angleDegrees)
    {
        float normalizedAngle = Mathf.Repeat(angleDegrees, 360f); // por si llega negativo o >360
        float t = Mathf.PingPong(normalizedAngle, 180f) / 180f;
        return Color.Lerp(lightColor, darkColor, t);
    }
        
}
