using UnityEngine;

public class CameraController : MonoBehaviour
{
    [SerializeField] private Rigidbody rb;
    [SerializeField] private float speed;
    [SerializeField] private GameObject holoRay;
    [SerializeField] private Material holoMat;
    [SerializeField] private GameManager gm;
    [SerializeField] private Camera cam;
    private float checkTime = 0;


    private float moveX;
    private float moveZ;

    void Update()
    {
        moveX = Input.GetAxisRaw("Horizontal");  
        moveZ = Input.GetAxisRaw("Vertical");

        if (Input.GetMouseButtonDown(0) && !holoRay.activeSelf)
        {
            holoRay.SetActive(true);
            holoMat.SetFloat("_checking", 1);
        }

        if (holoRay.activeSelf)
        {
            checkTime += Time.deltaTime;

            if (checkTime > 1 && holoMat.GetFloat("_checking") == 1)
            {
                holoMat.SetFloat("_checking", 0);
                holoMat.SetFloat("_bool", gm.HitsTheTarget(cam.transform) ? 1 : 0);
                if (holoMat.GetFloat("_bool") == 1)
                {
                    gm.InitCam();
                }
            }
            gm.LerpImg();

            if (checkTime > 2)
            {
                checkTime = 0;
                holoRay.SetActive(false);
            }
        }
        
    }

    void FixedUpdate()
    {   
        Vector3 movement = new Vector3(moveX, 0f, moveZ).normalized;
        if (Input.GetKey(KeyCode.LeftShift))
        {
            rb.velocity = new Vector3(movement.x * speed * 2, rb.velocity.y, movement.z * speed * 2);
        }
        else
        {
            rb.velocity = new Vector3(movement.x * speed, rb.velocity.y, movement.z * speed);
        }
    }
}