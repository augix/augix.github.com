* General
	* Purpose: repeat monkey forvea experiment, get magnification factor
	* Date: 20161215
	* Location: ziint room 106
	* People: Anna, Guohua, Anran, Song, Li Zhemin, Du Xiao, Qian Meizhen.
	* Planed Experiment: OD, RGLum, Fovea identification, Arc, Polar Line, 7 dots on polar angle 45 degree, 9 dots.              

* Animal treatment
	* Animal: thin monkey
	* Anesthesia:
		* During Surgery: >10mg/kg/hr propofol
		* During Imaging: most of the time: ~10mg/kg/hr propofol
		* During Recovery:
	* Brain Window: 
		* Center: V1 forvea
		* Size: 
		* Window construction:

* initial OI system setup
    * VDAQ timing: 
        * 0-frame: 2 frames, 0.5s; 
        * visual stim: 3.5s; 
        * interstim: 8s
	* luminance: two light source.
    * Camera: Back 50 x Front 105; FOV: 21.3x17.6 mm
	* screen distance: 57 cm.

* Run00: OD
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
		* 15:58 eye-shutter wrong, correct left and right eye shutter.
		* 16:00 8 conditions: 2 eyes (left or right) x 4 drift grating (orientation: 0, 45, 90, 135)
		* drift grating (0,45,90 and 135 degree); square wave; SF=1.5; velocity=4; duty cycle=0.1
	* Result: 
		* Number of trials: 7
		* 
	* Conclusion:

* Run01: OD
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
		* 16:20 duty cycle=0.5; velocity=1;
	* Result: 
		* Number of trials: 1
		*  
	* Conclusion:

* Change camera to: Back 50 x Front 85; fov: 17x14mm; F-stop: 2.8 (Anna says she usually uses 2.8-4)
	
* Run02: OD
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * 16:40 SF=2; velocity=1; duty cycle=0.5;
	* Result: 
		* Number of trials: 5
		* notice eye-shutter stopped working; VSG disconnected;
	* Conclusion:

* Run03: OD
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * 16:55 similar stimulus; found good OD map; no orientation map;
	* Result: 
		* Number of trials: 5
		* 
	* Conclusion:

* Run04: OD
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * 17:05 velocity=2
	* Result: 
		* Number of trials: 3
		* 
	* Conclusion:

* Run05: OD
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * suspect there is a surpression from para-fovea
        * change window size from full screen, to about 1/3 of screen width, 1/3 of the screen height.
	* Result: 
		* Number of trials: 5
		* 
	* Conclusion:

* Run06: OD
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * SF=4;
        * suspect that screen is too high, change monitor position.
        * change to full screen stimulus
	* Result: 
		* Number of trials: 
		* 
	* Conclusion:

* Run07: RGLum
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * SF=2; velocity=1; sinewave; set eyeshutter: open (pre-stim) to close (stimulus)
	* Result: 
		* Number of trials: 20
		* 
	* Conclusion:

* Run08: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(12,3); x-center=12; x-step=3; unit (degree);
        * SF=2, velocity=4; squarewave; duty cycle=0.5;
        * choose #1; x=6
	* Result: 
		* Number of trials: 4
		* 
	* Conclusion:


* Run09: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(6,1); x-center=6; x-step=1; unit (degree);
        * choose #2; x=5
	* Result: 
		* Number of trials: 5
		* 
	* Conclusion:


* Run10: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(5,0.5); x-center=5; x-step=0.5; unit (degree);
        * heart rate = 130; suspect deep anethesia
	* Result: 
		* 
	* Conclusion:

* Run11: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
    * changed anethesia dose, heart rate = 143
	* Stimulus
        * SF: 2->4; velocity:4->2;
        * findx(12,2)
        * didn't choose
	* Result: 
		* 
	* Conclusion:


* Run12: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(0,10); x center: 0; x step: 10 degree
        * choose #2; x=-10
	* Result: 
		* Number of trials: 
		* 
	* Conclusion:

* Run13: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(-10,3); x-center=-10; x-step=3; unit (degree);
        * SF=2, velocity=4; squarewave; duty cycle=0.5;
        * choose #1; x=-16
	* Result: 
		* Number of trials: 
		* 
	* Conclusion:

* Run14: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(-16,0.8)
        * choose #2; x=-16.8
	* Result: 
		* Number of trials: 
		* 
	* Conclusion:

* Run15: find fovea on x-axis
    * take veseel map again: g0.bmp; r0.bmp
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(0,10)
        * choose #2; x=-10
	* Result: 
		* Number of trials: 
		* 
	* Conclusion:

* Run16: findx(-20,2); wrong x-center

* Run17: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(-10,2)
	* Result: 
		* Number of trials: 
		* stop
	* Conclusion:

* Run18: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(0,3)
        * choose #4; x=3
	* Result: 
		* Number of trials: 
		* 
	* Conclusion:

* Run19: find fovea on x-axis
	* Animal: heart rate: ; co2: ; temp: ; o2: ; EEG: ;
	* Stimulus
        * findx(3,1)
        * choose #1; x=1
	* Result: 
		* Number of trials: 
		* 
	* Conclusion:

* Run20: find fovea on x-axis
	* Stimulus
        * findx(1,0.2)
        * choose #3; x=1

* Run21: find fovea on x-axis
	* Stimulus
        * findx(1,0.05)
        * choose #3; x=1
        * decide fovea_x = 1

* Run22: find fovea on y-axis
    * findy(0,5): y-center=0; y-step=5 degree
    * choose #1

* Run23: findy
    * findy(-10,2)
    * choose #2

* Run24: findy
    * findy(-12,0.5)
    * choose #5

* Run25: findy
    * findy(-11,0.2)
    * choose #3

* Run26: findy
    * findy(-11,0.05)
    * choose #2
    * decide fovea_y=-11.05

* Run27: arc
    * fovea arc: 7 stims: eccentricity: 0.01, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6
    * 8 trials
    * anna suspected this brain area only respond to stimulus really close to fovea

* run28: arc
    * 7 stims: 0.01, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3
    * 17 trials

* run29: polar line
    * 8 stims: 0 15 30 45 60 75 90 180 degree
    * no signal; stop!

* run30: polar line
    * same stimulus; 6 trials; no signal.

* run31: 9 dots
    * design: 9 dots centered at fovea, minimum dot to dot distance: 2 pixels.
    * dot #5 is the fovea
         1 2 3
         4 5 6
         7 8 9
    * program: nine_dots(fovea_x=1,fovea_y=-11.05, step=2)
    * 2 trials, no signal.
