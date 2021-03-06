#ifndef GARDEN_MATRIX_HEADER_INCLUDED
#define GARDEN_MATRIX_HEADER_INCLUDED

#include "gl.h"
#include "vector.h"


struct Mat4 {
    GLfloat entries[16];
};

extern const Mat4 Mat4_Identity;
extern const Mat4 Mat4_Zero;


Mat4 mat4_mul(const Mat4 *a, const Mat4 *b);
void mat4_muli(Mat4 *a, const Mat4 *b);

Mat4 mat4_transpose(const Mat4 *m);
void mat4_transposei(Mat4 *m);

Mat4 mat4_rotation_x(GLfloat radians);
Mat4 mat4_rotation_y(GLfloat radians);
Mat4 mat4_rotation_z(GLfloat radians);

Mat4 mat4_translation(GLfloat x, GLfloat y, GLfloat z);

void mat4_print(const Mat4 *m);

Vec4 mat4_lmul_vec(const Mat4 *m, const Vec4 *v);

#endif
