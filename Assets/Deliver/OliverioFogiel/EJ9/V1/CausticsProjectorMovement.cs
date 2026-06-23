using UnityEngine;

[RequireComponent(typeof(Projector))]
public class CausticsProjectorMovement : MonoBehaviour
{
    [SerializeField] private float speedX = 0.03f;
    [SerializeField] private float speedY = 0.05f;
    [SerializeField] private float rotationSpeed = 1f;

    private Projector projector;
    private Material projectorMaterial;
    private Vector2 offset;

    private void Awake()
    {
        projector = GetComponent<Projector>();

        // Crea una instancia propia para no modificar el material del Project.
        projectorMaterial = projector.material;
    }

    private void Update()
    {
        offset += new Vector2(speedX, speedY) * Time.deltaTime;

        projectorMaterial.SetTextureOffset("_MainTex", offset);

        transform.Rotate(
            Vector3.up,
            rotationSpeed * Time.deltaTime,
            Space.World
        );
    }
}