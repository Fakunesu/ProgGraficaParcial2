using System.Collections;

using System.Collections.Generic;

using UnityEngine;

public class PostProcessScript : MonoBehaviour

{
    [Header("Shaders general")]

    [SerializeField] private Shader drunkedShader;
    [SerializeField] private Shader damagedShader;

    private Material drunkMaterial;
    private Material damagedMaterial;
    private RenderTexture tempRT;

    [Header("Drunked Shaders")]

    [SerializeField]public float drunked;

    [SerializeField]private bool hasJustDrink;

    private float soberTimer;
    
    private float soberTimerTime=10f;

    [Header("Damage Shader")]

    [SerializeField] public float damagePercentage;

    [SerializeField] private float damageFadeSpeed = 0.7f;




    private void Awake()

    {
        hasJustDrink = false;
        drunkMaterial = new Material(drunkedShader);
        damagedMaterial = new Material(damagedShader);

    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)

    {

        tempRT = RenderTexture.GetTemporary(source.width, source.height);

        Graphics.Blit(source, tempRT, drunkMaterial);
        Graphics.Blit(tempRT, destination, damagedMaterial);

        RenderTexture.ReleaseTemporary(tempRT);

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

        damagePercentage = Mathf.MoveTowards(
            damagePercentage,
            0f,
            damageFadeSpeed * Time.deltaTime
        );
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

        // TEST DE DAÑO
        if (Input.GetKeyDown(KeyCode.H))
        {
            TakeDamage(1);
        }

        if (Input.GetKeyDown(KeyCode.J))
        {
            TakeDamage(2);
        }

        if (Input.GetKeyDown(KeyCode.K))
        {
            TakeDamage(3);
        }

        

        // Modificar Shader

        drunkMaterial.SetFloat("_alcoholDrinked", drunked);

        damagedMaterial.SetFloat("_damage", damagePercentage);

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

    public void TakeDamage(float intensity)
    {
        damagePercentage = (damagePercentage + intensity);
    }

}


