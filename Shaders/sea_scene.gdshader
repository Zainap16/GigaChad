shader_type spatial;

render_mode cull_disabled;

uniform float wave_height = 1.0;
//more waves increase frequency
uniform float wave_frequency = 0.35;
uniform float wave_speed = 1.5;

uniform vec3 albedo : source_color;
uniform vec3 albedo2 : source_color;
uniform vec3 albedo3 : source_color;
uniform float roughness :  hint_range(0.0, 1.0, 0.1) = 0.02;


float get_wave_height(vec2 pos, float time)
{
	float wave1 = sin(pos.x * wave_frequency + time * wave_speed);

	float wave2 = sin(
		pos.y * (wave_frequency * 1.5)
		+ time * (wave_speed * 0.73)
	);

	float wave3 = sin(
		(pos.x + pos.y) * (wave_frequency * 0.7)
		+ time * (wave_speed * 0.53)
	);

	return (
		wave1 * 0.7 +
		wave2 * 0.3 +
		wave3 * 0.2
	) * wave_height;
}


void vertex()
{
	VERTEX.y += get_wave_height(
		VERTEX.xz,
		TIME
	);
}


void fragment()
{
	//ALBEDO = albedo;
	ROUGHNESS = 0.8;
	float light = dot(NORMAL, vec3(0.0, 1.0, 0.0));

	if (light > 0.85)
	{
		//lightess
		ALBEDO = albedo;
	}
	else if (light > 0.55)
	{
		//med
		ALBEDO = albedo2;
	}
	else
	{//darkest
		ALBEDO = albedo3;
	}

	ROUGHNESS = roughness;
}