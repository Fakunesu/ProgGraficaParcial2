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
        currentAngle += rotationSpeed * Time.deltaTime;

        if (currentAngle >= 90f && currentAngle < 270f)
        {
            currentAngle = 270f;
        }

        if (currentAngle >= 360f)
        {
            currentAngle -= 360f; 
        }

        Vector3 axis = (spinAxis == SpinAxis.Vertical) ? Vector3.right : Vector3.up;
        Quaternion spin = Quaternion.AngleAxis(currentAngle, axis);

        for (int i = 0; i < projectors.Count; i++)
        {
            if (projectors[i] == null) continue;
            projectors[i].transform.localRotation = projectorBaseRotations[i] * spin;
        }

        if (directionalLight)
        {
            directionalLight.transform.localRotation = directionalLightBaseRotation * spin;
        }

        Color blended = GetColorForAngle(currentAngle);

        if (windowMaterial != null)
            windowMaterial.SetColor("_LightColor", blended);

        foreach (var p in projectors)
        {
            if (p != null)
                p.material = windowMaterial;
        }
    }

    public Color GetColorForAngle(float angleDegrees)
    {
        float normalizedAngle = Mathf.Repeat(angleDegrees, 360f); 

        if (normalizedAngle < 90f)
        {
            float t = normalizedAngle / 90f;
            return Color.Lerp(lightColor, sunsetColor, t);
        }
        else if (normalizedAngle < 180f)
        {
            float t = (normalizedAngle - 90f) / 90f;
            return Color.Lerp(sunsetColor, darkColor, t);
        }
        else if (normalizedAngle < 270f)
        {
            float t = (normalizedAngle - 180f) / 90f;
            return Color.Lerp(darkColor, sunsetColor, t);
        }
        else
        {
            float t = (normalizedAngle - 270f) / 90f;
            return Color.Lerp(sunsetColor, lightColor, t);
        }
    }

}
