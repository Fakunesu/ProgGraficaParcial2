using System.Collections;

using System.Collections.Generic;

using UnityEngine;

public class PostProcessScript : MonoBehaviour

{

    public float drunked;

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


    private void Awake()

    {

        material = new Material(shader);

    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)

    {

        Graphics.Blit(source, destination, material);

    }

    private void Update()
    {


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

    private void Parpadear()

    {

        parpadear = !parpadear;

    }
}


