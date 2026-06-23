using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModifiDayCicle : MonoBehaviour
{
    public enum SpinAxis { Horizontal, Vertical }

    [SerializeField] private GameObject directionalLight;
    [SerializeField] private List<Projector> projectors = new List<Projector>();

    [SerializeField] private float currentRotation;
    [SerializeField] private Material windowMaterial;

    [SerializeField] private Color lightColor;
    [SerializeField] private Color sunsetColor;
    [SerializeField] private Color darkColor;

    [SerializeField] private float rotationSpeed = 10f;
    public SpinAxis spinAxis = SpinAxis.Vertical;

    private float currentAngle = 0f;
    private List<Quaternion> projectorBaseRotations = new List<Quaternion>();
    private Quaternion directionalLightBaseRotation;

    void Awake()
    {
        // Guardamos la rotación inicial de CADA projector (la que tenga puesta en el editor/escena)
        projectorBaseRotations.Clear();
        foreach (var p in projectors)
        {
            projectorBaseRotations.Add(p != null ? p.transform.localRotation : Quaternion.identity);
        }

        if (directionalLight)
        {
            directionalLightBaseRotation = directionalLight.transform.localRotation;
        }
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
        Quaternion spin = Quaternion.AngleAxis(currentAngle, axis);

        // --- 4) Aplicar el giro SOBRE la rotación base de cada projector (no la pisa) ---
        for (int i = 0; i < projectors.Count; i++)
        {
            if (projectors[i] == null) continue;
            projectors[i].transform.localRotation = projectorBaseRotations[i] * spin;
        }

        if (directionalLight)
        {
            directionalLight.transform.localRotation = directionalLightBaseRotation * spin;
        }

        // --- 5) Calcular el color según el tramo de 90° en el que esté el ángulo ---
        // 0-90: light->sunset | 90-180: sunset->dark | 180-270: dark->sunset | 270-360: sunset->light
        Color blended = GetColorForAngle(currentAngle);

        // --- 6) Aplicar el color resultante a todos los projectors ---
        if (windowMaterial != null)
            windowMaterial.SetColor("_LightColor", blended);

        foreach (var p in projectors)
        {
            if (p != null)
                p.material = windowMaterial;
        }
    }

    /// <summary>
    /// Si la rotación viene de otro lado (animación, otro script, input del usuario, etc.),
    /// no llames al Update de este script y usá este método pasándole el ángulo actual (0-360).
    ///
    /// Divide el círculo en 4 tramos de 90° con un color "pico" en cada extremo (0/360, 90, 180, 270):
    ///   0°   -> lightColor
    ///   90°  -> sunsetColor
    ///   180° -> darkColor
    ///   270° -> sunsetColor
    ///   360° -> lightColor (vuelve a empezar)
    /// </summary>
    public Color GetColorForAngle(float angleDegrees)
    {
        float normalizedAngle = Mathf.Repeat(angleDegrees, 360f); // por si llega negativo o >360

        if (normalizedAngle < 90f)
        {
            // 0 -> 90: light -> sunset
            float t = normalizedAngle / 90f;
            return Color.Lerp(lightColor, sunsetColor, t);
        }
        else if (normalizedAngle < 180f)
        {
            // 90 -> 180: sunset -> dark
            float t = (normalizedAngle - 90f) / 90f;
            return Color.Lerp(sunsetColor, darkColor, t);
        }
        else if (normalizedAngle < 270f)
        {
            // 180 -> 270: dark -> sunset
            float t = (normalizedAngle - 180f) / 90f;
            return Color.Lerp(darkColor, sunsetColor, t);
        }
        else
        {
            // 270 -> 360: sunset -> light
            float t = (normalizedAngle - 270f) / 90f;
            return Color.Lerp(sunsetColor, lightColor, t);
        }
    }

}
