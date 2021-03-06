#ifndef GARDEN_LOAD_SHADER_HEADER_INCLUDED
#define GARDEN_LOAD_SHADER_HEADER_INCLUDED

#include "lib/gl.h"


struct Resource_Error;
struct Resource_Set;
struct Shader_Resource;

enum Shader_Load_Error {
    Shader_Load_Error_None,
    Shader_Load_Error_Opening_File,
    Shader_Load_Error_Compiling_Shader,
};

enum Shader_Error_Type {
    Shader_Error_Unknown,
    Shader_Error_Vert,
    Shader_Error_Frag,
    Shader_Error_Link,
};

struct Shader_Error {
    char *message;
    Shader_Error_Type type;
};


Shader_Load_Error shader_load(Shader_Resource *resource, Resource_Error *err);
GLuint compile_shader(const char *vert_src, const char *frag_src,
                      Shader_Error *err);
void free_shader_error(Shader_Error *err);

Shader_Load_Error shader_set_add(Resource_Set *set,
                                 const char *vert_src, const char *frag_src,
                                 Shader_Resource **out_shader,
                                 Resource_Error *err);


#endif
