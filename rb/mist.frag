#version 110

uniform sampler2D in_Texture;
uniform vec4 in_MistColor;
uniform float in_Alpha;
uniform float in_Time;

uniform int in_WindowWidth;
uniform int in_WindowHeight;

varying vec2 var_TexCoord;

void main()
{
  vec2 texCoord = var_TexCoord;
  vec4 color = texture2D(in_Texture, texCoord);
  
  float noiseX = sin(texCoord.x*6.0+in_Time);
  float smallNoiseX = (sin(texCoord.x*25.0-in_Time*2.0))/8.0;
  float smallNoiseY = (sin(texCoord.y*25.0-in_Time*2.0))/8.0;
  float noiseY = sin(texCoord.y*3.0+texCoord.x+in_Time*0.8);
  float alpha = in_Alpha * ((1.5 + (noiseX+noiseY+smallNoiseX+smallNoiseY))/4.0);
  if (alpha > 1.0) { alpha = 1.0; }
  if (alpha < 0.0) { alpha = 0.0; }
  
  color = in_MistColor * (1.0 - alpha) + color * alpha;

  gl_FragColor = color;
}
