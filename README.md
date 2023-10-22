# SingleTrack_Controller

Contributors: Iskandar Khemakhem, Patrick Riedel

State feedback Controller of a single-track model on a given racetrack.

This project aims to control a single-track model on a predefined race track. The objective is for the single-track model to autonomously traverse the race track in minimal time without exceeding the track boundaries. To achieve this, a reference trajectory was created, approximating the "ideal line" of the race track, and it is tracked using a state controller. Simulations have shown that the circuit can be successfully completed under this control strategy in 83.81 seconds.

A report (in German) explains the control method used and presents the main results.

This project is part of a lab work at the Institute for Systems Theory and Automatic Control (IST) at the University of Stuttgart. The institute provides the model of a single-track car model and a template to test the results on the predefined track. 
