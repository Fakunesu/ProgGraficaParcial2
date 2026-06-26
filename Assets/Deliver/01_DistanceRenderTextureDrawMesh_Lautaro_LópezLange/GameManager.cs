using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    [SerializeField] private List<GameObject> assetList;
    [SerializeField] private GameObject cam;
    private GameObject currentGoal;
    private int points;

    [SerializeField] private RawImage rtimg;


    private void Awake()
    {
        points = 0;
        InitCam();
    }

    public void InitCam()
    {
        currentGoal = assetList[Random.Range(0, assetList.Count)];
        cam.transform.position = new Vector3 (currentGoal.transform.position.x, cam.transform.position.y, currentGoal.transform.position.z);
    }

    public void LerpImg()
    {
        rtimg.color = Color.Lerp(rtimg.color, Color.white, 2 * Time.deltaTime);
    }

    public bool HitsTheTarget(Transform caster)
    {
        Debug.Log("Disparando raycast");
        Debug.DrawRay(caster.position, caster.forward * 100f, Color.red);
        if (Physics.Raycast(caster.position, caster.forward, out RaycastHit hit, 100f) && hit.collider.gameObject == currentGoal)
        {
            currentGoal = null;
            points++;
            if (points == 5)
            {
                Debug.Log("You Win!");
                rtimg.color = Color.green;
            }
            else
            {
                rtimg.color = Color.black;
            }
            return true;
        }
        return false;
    }

}
