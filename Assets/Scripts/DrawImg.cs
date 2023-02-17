using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawImg : MonoBehaviour
{
    public const int seed = 1000;

    public Material mat;

    public AnimationCurve curve;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, mat);
    }

    [ContextMenu("Test")]
    void Test()
    {
        curve = new AnimationCurve();
        for (int i = 0; i < 1000; ++i)
        {
            double x = i / 10f;
            double y = Noise(x);
            curve.AddKey((float)x, (float)y);
        }
    }

    double Noise(double x)
    { 
        double xi = Math.Floor(x);
        double xp = x - xi;
        double y1 = Math.Sin(xi) * seed;
        double y2 = Math.Sin(xi + 1) * seed;
        double lerp = xp * xp * (3 - 2 * xp);
        double y = Mathf.Lerp((float)y1, (float)y2, (float)lerp);
        return y - Math.Floor(y);
    }
}
