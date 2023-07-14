using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class materialUpdate : MonoBehaviour
{
    public Material material;
    // Update is called once per frame
    void Update()
    {
        float time = Time.time;
        material.SetFloat("_Time",time);       
    }
}
