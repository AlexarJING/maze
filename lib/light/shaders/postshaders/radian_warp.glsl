extern float power;
extern vec2 limit;
extern vec2 ic;

vec2 warp(vec2 ic,vec2 tc,float power ) {
  tc=tc*2.0-1.0;
  ic=ic*2.0-1.0;
  float r = distance(tc,ic);
  float phi = atan(tc.y-ic.y, tc.x-ic.x);
  r=pow(r,power);

  return vec2(r * cos(phi)+ic.x,r * sin(phi)+ic.y);
}

vec4 effect( vec4 color, Image texture, vec2 tc, vec2 sc )
{
  if (tc.x < ic.x - limit.x || tc.x > ic.x + limit.x 
    || tc.y> ic.y + limit.y || tc.y< ic.y - limit.y) {
    return Texel(texture,tc);
  }
  vec2 uv=warp(ic,tc,power);
  uv = (uv+1)/2;
  return Texel(texture,uv);

}