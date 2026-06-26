using System.Collections;

using System.Collections.Generic;

using UnityEngine;

public class PostProcessScript : MonoBehaviour

{
    [Header("Shaders general")]

    [SerializeField] private Shader drunkedShader;
    [SerializeField] private Shader damagedShader;
    [SerializeField] private Shader flashBangShader;

    private Material drunkMaterial;
    private Material damagedMaterial;
    private Material flashBangMaterial;
    private RenderTexture tempRT;

    [Header("Drunked Shaders")]

    [SerializeField]public float drunked;

    [SerializeField]private bool hasJustDrink;

    private float soberTimer;
    
    private float soberTimerTime=10f;

    [Header("Damage Shader")]

    [SerializeField] public float damagePercentage;

    [SerializeField] private float damageFadeSpeed = 0.7f;

    [Header("FlashBang Shader")]

    [SerializeField] public float flashBangIntensity;

    [SerializeField] private float flashBangDuration = 4f;

    [SerializeField] private float flashDamage = 2f;

    private float flashBangPeak;

    private float flashBangTimer;


    private void Awake()

    {
        hasJustDrink = false;
        drunkMaterial = new Material(drunkedShader);
        damagedMaterial = new Material(damagedShader);
        flashBangMaterial = new Material(flashBangShader);

    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        RenderTexture tempRT1 = RenderTexture.GetTemporary(source.width, source.height);
        RenderTexture tempRT2 = RenderTexture.GetTemporary(source.width, source.height);

        Graphics.Blit(source, tempRT1, drunkMaterial);
        Graphics.Blit(tempRT1, tempRT2, damagedMaterial);
        Graphics.Blit(tempRT2, destination, flashBangMaterial);

        RenderTexture.ReleaseTemporary(tempRT1);
        RenderTexture.ReleaseTemporary(tempRT2);

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

        if (flashBangIntensity > 0f)
        {
            flashBangTimer += Time.deltaTime;
            float t = Mathf.Clamp01(flashBangTimer / flashBangDuration);
            flashBangIntensity = Mathf.Lerp(flashBangPeak, 0f, t);
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
        if (Input.GetKeyDown(KeyCode.F))
        {
            FlashBang(1f);
            TakeDamage(flashDamage);
        }


        // Modificar Shader

        drunkMaterial.SetFloat("_alcoholDrinked", drunked);

        damagedMaterial.SetFloat("_damage", damagePercentage);

        flashBangMaterial.SetFloat("_flash", flashBangIntensity);

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

    public void FlashBang(float intensity)
    {
        flashBangIntensity = intensity;
        flashBangPeak = intensity;
        flashBangTimer = 0f;
    }

}


