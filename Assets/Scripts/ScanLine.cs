using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScanLine : MonoBehaviour
{
    [SerializeField] Material _mat;
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, _mat);
    }
}
