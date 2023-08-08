//Castle Engine Bloom shader to work with Screen Effects
//original shader code taken from https://github.com/kiwipxl/GLSL-shaders/blob/master/bloom.glsl
//then improved

        uniform float bloom_spread = 3; 
        uniform float bloom_intensity = 1; 
        uniform float bloom_treshold = 0.98; 
		
        vec4 screen_get_color_my(ivec2 pos);
        
        void main (void)
        {
          ivec2 size; 
          size.x=screen_width; 
          size.y=screen_height; 
          vec2 texpos = screenf_01_position; 
          float uv_x = texpos.x * size.x; 
          float uv_y = texpos.y * size.y; 
        
          vec4 sum = vec4(0.0); 

          for (int n = 0; n < 9; ++n) { 
            uv_y = (texpos.y * size.y) + (bloom_spread * float(n - 4));
            vec4 h_sum = vec4(0.0); 

            h_sum += screen_get_color_my(ivec2(uv_x - (4.0 * bloom_spread), uv_y));

            h_sum += screen_get_color_my(ivec2(uv_x - (3.0 * bloom_spread), uv_y));
            h_sum += screen_get_color_my(ivec2(uv_x - (2.0 * bloom_spread), uv_y));
            h_sum += screen_get_color_my(ivec2(uv_x - bloom_spread, uv_y)); 
            h_sum += screen_get_color_my(ivec2(uv_x, uv_y));
            h_sum += screen_get_color_my(ivec2(uv_x + bloom_spread, uv_y)); 
            h_sum += screen_get_color_my(ivec2(uv_x + (2.0 * bloom_spread), uv_y));
            h_sum += screen_get_color_my(ivec2(uv_x + (3.0 * bloom_spread), uv_y)); 
            h_sum += screen_get_color_my(ivec2(uv_x + (4.0 * bloom_spread), uv_y)); 

            sum += h_sum / 9.0; 
          } 


        //part of original edge detect shader from examples,
          float x = screenf_x();
          float y = screenf_y();

          #define SCAN_DISTANCE 1.0
          vec4 left   = screenf_get_color(vec2(x - SCAN_DISTANCE, y));
          vec4 right  = screenf_get_color(vec2(x + SCAN_DISTANCE, y));
          vec4 top    = screenf_get_color(vec2(x, y - SCAN_DISTANCE));
          vec4 bottom = screenf_get_color(vec2(x, y + SCAN_DISTANCE));
          vec4 mag = screenf_get_original_color(); 
         //end part
       
	      //add bloom color to original color
          mag=screenf_get_original_color()+((sum / 9.0) * bloom_intensity); 

        


          gl_FragColor = mag; 


        }
        // function to get only highlighted parts of image
        vec4 screen_get_color_my(ivec2 pos){
          
		      vec4 res = vec4(0.0,0.0,0.0,0.0); 
          vec4 smp = screen_get_color(pos); 
		  
          if ((0.2126*smp.r + 0.7152*smp.g + 0.0722*smp.b)>bloom_treshold){
             res=smp; 
          }
             return  res; 
        }                       
