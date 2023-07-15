using UnityEngine;
using UnityEngine.UI;


public class MeshGenerator : MonoBehaviour
{
    public int width;
    public int height;
    public float scale;
    public float frequency;
    public float amplitude;

    public Slider amplitudeSlider;
    public Slider frequencySlider;
    
    private void Start()
    {
        GenerateMesh();
        
    }

    private void GenerateMesh()
    {
        Mesh mesh = new Mesh();
        mesh.name = "Generated Mesh";

        GetComponent<MeshFilter>().mesh = mesh;

        Vector3[] vertices = new Vector3[(width + 1) * (height + 1)];
        int[] triangles = new int[width * height * 6];


        // Generate vertices
        for (int z = 0, i = 0; z <= height; z++)
        {
            for (int x = 0; x <= width; x++)
            {
                vertices[i] = new Vector3(x, 0, z);
                i++;
            }
        }

        // Generate triangles
        int vert = 0;
        int tris = 0;
        for (int z = 0; z < height; z++)
        {
            for (int x = 0; x < width; x++)
            {
                triangles[tris + 0] = vert + 0;
                triangles[tris + 1] = vert + width + 1;
                triangles[tris + 2] = vert + 1;
                triangles[tris + 3] = vert + 1;
                triangles[tris + 4] = vert + width + 1;
                triangles[tris + 5] = vert + width + 2;

                vert++;
                tris += 6;
            }
            vert++;
        }

        mesh.vertices = vertices;
        mesh.triangles = triangles;
        mesh.RecalculateNormals();
    }
    private void Update(){
        Material material = GetComponent<Renderer>().material;
        frequency = frequencySlider.value;
        amplitude = amplitudeSlider.value;

        material.SetFloat("_Frequency", frequency);
        material.SetFloat("_Amplitude", amplitude);
    }
    
}
