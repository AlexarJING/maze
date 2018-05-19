extern Image img; //texture
extern vec2 ic; //first point
extern vec2 oc; //second point
extern float r; //warp radian
extern float limit; //max warp radian

vec2 warp (vec2 tc,vec2 ic,vec2 oc,float r) {
float dis_x_c=distance(tc,ic);
float dis_m_c=distance(tc,oc);
float div=pow(r,2.0) - pow(dis_x_c,2.0) + pow(dis_m_c,2.0);
if (div==0.0) div=0.0000000001;
float factor=pow((pow(r,2.0) - pow(dis_x_c,2.0)) / div,2.0);
return vec2(tc-factor*(oc-ic));
}

vec4 effect( vec4 color, Image texture, vec2 tc, vec2 sc )
{
if (distance(tc,ic)>r) {
  vec2 rc=limit*tc-0.5*limit+0.5;
  if (rc.x<0.0 || rc.x>1.0 ||  rc.y<0.0 || rc.y>1.0) {
    return vec4(0,0,0,0);
  }else{    
    return Texel(img,rc);
  }
}

vec2 uv=warp(tc,ic,oc,r);

if (uv.x<0.0 || uv.x>1.0 ||  uv.y<0.0 || uv.y>1.0) {
  return vec4(0,0,0,0);
}else{    
  vec2 rc=limit*uv-0.5*limit+0.5;
  if (rc.x<0.0 || rc.x>1.0 ||  rc.y<0.0 || rc.y>1.0) {
    return vec4(0,0,0,0);
  }else{    
    return Texel(img,rc);
  }
}
}