using UnityEngine;
using UnityEngine.SceneManagement;

[RequireComponent(typeof(CharacterController))]
public class Player : MonoBehaviour
{
    [Header("Movement")]
    [SerializeField] private float speed = 5f;
    [SerializeField] private float gravity = -20f;
    [SerializeField] private float jumpForce = 8f;

    [Header("Ground Check")]
    [SerializeField] private Transform groundCheck;
    [SerializeField] private float groundCheckRadius = 0.2f;
    [SerializeField] private LayerMask groundMask;

    private CharacterController controller;
    private float yVelocity;
    private bool isGrounded;

    private void Awake()
    {
        controller = GetComponent<CharacterController>();
    }

    private void Update()
    {
        // Revisa si hay piso debajo del player.
        isGrounded = Physics.CheckSphere(
            groundCheck.position,
            groundCheckRadius,
            groundMask
        );

        if (isGrounded && yVelocity < 0f)
        {
            yVelocity = -2f;
        }

        // Salto, aunque esté quieto.
        if (Input.GetKeyDown(KeyCode.Space) && isGrounded)
        {
            yVelocity = jumpForce;
        }

        float horizontal = Input.GetAxisRaw("Horizontal");

        Vector3 movement = new Vector3(horizontal * speed, yVelocity, 0f);

        yVelocity += gravity * Time.deltaTime;

        controller.Move(movement * Time.deltaTime);

        if (horizontal > 0f)
            transform.rotation = Quaternion.Euler(0f, 90f, 0f);
        else if (horizontal < 0f)
            transform.rotation = Quaternion.Euler(0f, -90f, 0f);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Lava"))
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        }
    }

            
}