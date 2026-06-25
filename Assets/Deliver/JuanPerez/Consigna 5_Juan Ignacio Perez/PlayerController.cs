using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [Header("Movimiento (Eje X)")]
    [SerializeField] private float moveSpeed = 5f;

    [Header("Salto (Eje Y)")]
    [SerializeField] private float jumpForce = 7f;
    [SerializeField] private Transform groundCheck;
    [SerializeField] private float groundCheckRadius = 0.2f;
    [SerializeField] private LayerMask groundLayer;

    private Rigidbody rb;
    private bool isGrounded;
    private float horizontalInput;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();

        // Congelamos rotaciones que no necesitamos y la posición en Z,
        // así nos asegurás que el player solo se mueve en el plano X/Y.
        rb.constraints = RigidbodyConstraints.FreezeRotationX
                        | RigidbodyConstraints.FreezeRotationZ
                        | RigidbodyConstraints.FreezePositionZ;
    }

    private void Update()
    {
        // Input Manager clásico (Edit > Project Settings > Input Manager)
        horizontalInput = Input.GetAxis("Horizontal"); // A/D o flechas <-/->

        if (groundCheck != null)
        {
            isGrounded = Physics.CheckSphere(groundCheck.position, groundCheckRadius, groundLayer);
        }

        if (Input.GetButtonDown("Jump") && isGrounded) // Espacio por default
        {
            Jump();
        }
    }

    private void FixedUpdate()
    {
        // Movemos solo en X, dejamos la Y como está (gravedad / impulso de salto)
        Vector3 velocity = rb.velocity;
        velocity.x = horizontalInput * moveSpeed;
        rb.velocity = velocity;
    }

    private void Jump()
    {
        // Reseteamos la velocidad vertical para que el salto siempre tenga la misma altura
        Vector3 velocity = rb.velocity;
        velocity.y = 0f;
        rb.velocity = velocity;

        rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
    }

    private void OnDrawGizmosSelected()
    {
        if (groundCheck == null) return;
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(groundCheck.position, groundCheckRadius);
    }

}
