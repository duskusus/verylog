#include "blocksmath.h"
mat4::mat4(float scale)
{
    matrix[0] = toFix(scale);
    matrix[5] = toFix(scale);
    matrix[10] = toFix(scale);
    matrix[15] = toFix(scale);
}
int16_t mat4::operator[](unsigned i) const
{
    return matrix[i];
}
int16_t &mat4::operator[](unsigned i)
{
    return matrix[i];
}
vec3 mat4::operator*(const vec3 &v) const
{
    int32_t x = v.x * matrix[0] + v.y * matrix[1] + v.z * matrix[2] + matrix[3];
    int32_t y = v.x * matrix[4] + v.y * matrix[5] + v.z * matrix[6] + matrix[7];
    int32_t z = v.x * matrix[8] + v.y * matrix[9] + v.z * matrix[10] + matrix[11];
    return vec3(x >> 6, y >> 6, z >> 6);
}
void mat4::copy(const float nm[16])
{
    for (int i = 0; i < 16; i++)
    {
        matrix[i] = toFix(nm[i]);
    }
}
void mat4::copy(const int16_t nm[16])
{
    for (int i = 0; i < 16; i++)
    {
        matrix[i] = toFix(nm[i]);
    }
}
mat4 mat4::operator*(const mat4 &other) const
{
    mat4 r;
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            int32_t n = 0;
            for (int k = 0; k < 4; k++)
            {
                n += matrix[4 * i + j] * other.matrix[4 * k + j];
            }
            r[i * 4 + j] = n >> 6;
        }
    }
    return r;
}
vec3 mat4::perspectiveTransform(const vec3 &v) const
{

    int32_t x = v.x * matrix[0] + v.y * matrix[1] + v.z * matrix[2] + matrix[3];
    int32_t y = v.x * matrix[4] + v.y * matrix[5] + v.z * matrix[6] + matrix[7];
    int32_t z = v.x * matrix[8] + v.y * matrix[9] + v.z * matrix[10] + matrix[11];

    // z divide and centering
    x = ((x << 6) / z) + (1 << 6);
    y = (1 << 6) - ((y << 6) / z);

    int16_t xp = (x * 120) / 64;
    int16_t yp = (y * 120) / 64;
    int16_t zp = z / 64;
    // xil_printf("[%d, %d, %d]\n", xp, yp, zp);
    return vec3(xp, yp, zp);
}

void mat4::translate(float x, float y, float z)
{
    matrix[3] = toFix(x);
    matrix[7] = toFix(y);
    matrix[11] = toFix(z);
    mat4 tm;
}
void mat4::print() {
    			for (int i = 0; i < 4; i++)
			{
				xil_printf("%d, %d, %d, %d\n",
						   matrix[0 + 4 * i],
						   matrix[1 + 4 * i],
						   matrix[2 + 4 * i],
						   matrix[3 + 4 * i]);
			}
}
