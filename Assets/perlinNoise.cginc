// PerlinNoise.cginc

float Hash(int2 xy)
{
    int seed = xy.x * 1619 + xy.y * 31337;
    seed = (seed << 13) ^ seed;
    return (1.0 - ((seed * (seed * seed * 15731 + 789221) + 1376312589) & 0x7FFFFFFF) / 1073741824.0);
}

float Smooth(float t, float frequency)
{
    float smoothness = frequency * 0.5; // Adjust the smoothness based on frequency
    t = t * smoothness;
    return t * t * t * (t * (t * 6 - 15) + 10);
}

float PerlinNoise(float x, float y, float frequency, float amplitude)
{
    float2 xy = float2(x * frequency, y * frequency);
    int2 floorXY = int2(floor(xy));
    int2 XY = int2(floorXY.x & 255, floorXY.y & 255);
    float x1 = lerp(Hash(XY), Hash(XY + int2(1, 0)), Smooth(xy.x - floorXY.x, frequency));
    float x2 = lerp(Hash(XY + int2(0, 1)), Hash(XY + int2(1, 1)), Smooth(xy.x - floorXY.x, frequency));

    return lerp(x1, x2, Smooth(xy.y - floorXY.y, frequency)) * amplitude;
}
