using System.Collections;

using System.Collections.Generic;

using UnityEngine;

public class PostProcessScript : MonoBehaviour

{


    [SerializeField] private Shader shader;

    private Material material;

    public Color myColor;

    public Vector2 myCenterVector;

    public Vector2 myStepValueVector;

    public Color damageColor;

    public Color healColor;

    public Color accentColor = Color.white;

    private float damageTotalTime = 0;

    public float damageFlashUmbral;

    public float healTimeCounter;

    private bool parpadear = false;

    private float hitflashCounter = 0f;

    private readonly int ColorID = Shader.PropertyToID("_ColorMult");

    private readonly int CenterVector = Shader.PropertyToID("_CenterVector");

    private readonly int StepValueVector = Shader.PropertyToID("_StepValueVector");

    [SerializeField]public float drunked;

    [SerializeField]private bool hasJustDrink;

    private float soberTimer;
    
    private float soberTimerTime=10f;


   

    private void Awake()

    {
        hasJustDrink = false;
        material = new Material(shader);

    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)

    {

        Graphics.Blit(source, destination, material);

    }

    private void FixedUpdate()
    {
        if (hasJustDrink == true)
        {
            if (soberTimer <= soberTimerTime)
            {
                soberTimer += Time.deltaTime;
            }
            else
            {
                hasJustDrink = false;
            }
        }
        
        if (hasJustDrink == false)
        {
            Sobering();
        }
        
    }
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            Drunked();
            hasJustDrink = true;
        }

        if (Input.GetKeyDown(KeyCode.P))
        {
            Peepee();
        }

        if (parpadear)

        {

            myStepValueVector.x = Mathf.Lerp(0.3f, -2f, 0.5f);


        }


        //Parpadeo

        if (Input.GetKey(KeyCode.W))

        {

            Debug.Log("parpadear");

            Parpadear();

        }


        // Modificar Shader


        material.SetColor(ColorID, myColor);

        material.SetVector(CenterVector, myCenterVector);

        material.SetVector(StepValueVector, myStepValueVector);


        material.SetFloat("_alcoholDrinked", drunked);

    }

    private void Drunked()
    {
        drunked = drunked +0.1f * 1.2f;
        soberTimer = 0;
        return;
    }

    private void Sobering()
    {
        if (drunked > 0)
        {
            drunked -= 0.1f;
        }
        else if (drunked < 0)
        {
            drunked += 0.1f;
        }
        else { drunked = 0; }
    }

    private void Peepee()
    {
        drunked = 0;
    }
    private void Parpadear()

    {

        parpadear = !parpadear;

    }
}


