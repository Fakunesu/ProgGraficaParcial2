
using UnityEngine;

public class RotateCard : MonoBehaviour
{
    [Header("Referencia al objeto a rotar")]
    public Transform card;

    [Header("Configuración de velocidad de rotación")]
    public float rotationSpeed = 90f;

    [Tooltip("Ángulo máximo/mínimo en el eje X (A/D)")]
    public float maxXAngle = 25f;

    [Tooltip("Ángulo máximo/mínimo en el eje Y (W/S)")]
    public float maxYAngle = 25f;

    [Header("Comportamiento")]
    public bool returnToCenter = true;

    private float currentXAngle = 0f;
    private float currentYAngle = 0f;

    void Update()
    {
        if (card == null) return;

        HandleXRotation();
        HandleYRotation();

       
        card.localRotation = Quaternion.Euler(-currentYAngle, -currentXAngle, 0f);
    }

    private void HandleXRotation()
    {
        float inputX = 0f;

        if (Input.GetKey(KeyCode.D)) inputX = 1f;   
        else if (Input.GetKey(KeyCode.A)) inputX = -1f;

        if (inputX != 0f)
        {
            currentXAngle += inputX * rotationSpeed * Time.deltaTime;
            currentXAngle = Mathf.Clamp(currentXAngle, -maxXAngle, maxXAngle);
        }
        else if (returnToCenter)
        {
            currentXAngle = Mathf.MoveTowards(currentXAngle, 0f, rotationSpeed * Time.deltaTime);
        }
    }

    private void HandleYRotation()
    {
        float inputY = 0f;

        if (Input.GetKey(KeyCode.W)) inputY = 1f;
        else if (Input.GetKey(KeyCode.S)) inputY = -1f;

        if (inputY != 0f)
        {
            currentYAngle += inputY * rotationSpeed * Time.deltaTime;
            currentYAngle = Mathf.Clamp(currentYAngle, -maxYAngle, maxYAngle);
        }
        else if (returnToCenter)
        {
            currentYAngle = Mathf.MoveTowards(currentYAngle, 0f, rotationSpeed * Time.deltaTime);
        }
    }
}
