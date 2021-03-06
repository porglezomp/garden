#ifndef GARDEN_LOAD_MODEL_HEADER_INCLUDED
#define GARDEN_LOAD_MODEL_HEADER_INCLUDED

#include "lib/gl.h"


struct Resource_Error;
struct Resource_Set;
struct Model_Resource;

enum Model_Load_Error {
    Model_Load_Error_None,
    Model_Load_Error_Opening_File,
    Model_Load_Error_Reading_File,
};


Model_Load_Error model_load(Model_Resource *resource, Resource_Error *err);
Model_Load_Error model_set_add(Resource_Set *set, const char *model_fname,
                               Model_Resource **out_model, Resource_Error *err);


#endif
