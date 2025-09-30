using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderController : MonoBehaviour
{
    void Start()
    {
        GetComponent<Renderer>().material.SetColor("_BaseColor", Color.black);
    }
}
