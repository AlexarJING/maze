extern vec2 size;
vec2 clamp(vec2 pos) {
    number x = pos.x;
    number y = pos.y;
    if (x < 0.0) x = 0.0;
    if (y < 0.0) y = 0.0;
    if (x > 1.0) x = 1.0;
    if (y > 1.0) y = 1.0;
    return vec2(x, y);
}
vec4 effect ( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
    number distance = 1.0;
    number num = 0.0;
    vec4 averagecolor = vec4(0.0, 0.0, 0.0, 0.0);
    for (number x = -6.0 ; x <= 6.0; x++)
    for (number y = -6.0 ; y <= 6.0; y++) {
        vec4 color = Texel(texture, clamp(vec2(texture_coords.x + x/size.x, texture_coords.y + y/size.y)));
        if (color.a > 0.0) {
            num = num + 1.0;
            averagecolor.r = (averagecolor.r + color.r);
            averagecolor.g = (averagecolor.g + color.g);
            averagecolor.b = (averagecolor.b + color.b);
            averagecolor.a = (averagecolor.a + color.a);
            number x1 = x/size.x;
            number y1 = y/size.y;
            number dist = sqrt( x1*x1 + y1*y1 ) * 200;
            if (dist < distance) {
                distance = dist;
            }
        }
    }
    return vec4(averagecolor.r / num, averagecolor.g / num, averagecolor.b / num, averagecolor.a / num - distance);
}