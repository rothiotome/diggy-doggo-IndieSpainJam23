shader_type spatial;
render_mode depth_draw_opaque, unshaded;
uniform sampler2D ditherpattern;
uniform int dithersize = 8;
uniform float alpha = 0.5;
uniform sampler2D maintex;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 color = texture(maintex, UV) * COLOR;
	ALBEDO = color.rgb;
	
	float transparency = alpha * color.a;
	
	if(transparency >= 1.0) {
		ALPHA = 1.0;
	} else if (transparency <= 0.0){
		ALPHA = 0.0;
	} else {
		ivec2 screen_res = textureSize(SCREEN_TEXTURE, 0);
		ivec2 dither_res = textureSize(ditherpattern, 0);
		ivec2 screen_pos = ivec2(SCREEN_UV * vec2(screen_res));
		int dither_pos = int(floor(transparency * float(dither_res.y)));
				
		ivec2 ditheruv = ivec2(
			screen_pos.x % dithersize, 
			dither_pos - (screen_pos.y % dithersize)
		);
				
		ALPHA = texelFetch(ditherpattern, ditheruv, 0).r > 0.0 ? 1.0 : 0.0;
	}
}