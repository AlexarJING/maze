extern number time = 0.0;
extern number size = 64.0;
extern number strength = 1.0;
extern vec2 offset = vec2(0,0);

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
    float dist = sqrt(pow(texture_coords.x * size - size *offset.x, 2.0) + pow(texture_coords.y * size - size*offset.y, 2.0));
    float tmp = sin( dist - time * 16.0) /sqrt(dist);
    vec2 uv         = vec2(
        texture_coords.x - tmp * strength / 1024.0 ,
        texture_coords.y - tmp * strength / 1024.0
    );
    vec3 col        = vec3(
        texture2D(texture,uv).x,
        texture2D(texture,uv).y,
        texture2D(texture,uv).z
    );
 return vec4(col, 1.0);
}