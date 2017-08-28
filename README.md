# MusicNotes
Identify music notes using Fourier Transform in Matlab

Still, can not accept large files yet.
NOTE:You may need to change the values of SizeWindow and SizeOverlap.

It's a program that identifies the musical notes of a small sound file.
Description of steps

1)Read the sound file
Ask if you want to hear an example first.
Reads the sound file using the audioread method.

2)Listen to file
I used the audioplayer and play functions.
x is audio signal represented by a vector and fs is the sampling rate in Hz.

3)View the graph with the data
I created two graphs with the values already transformed using the fft and fftshift functions.
The first method transforms the values according to the Fourier transform and the second shift zero-frequency component to the center of the spectrum.

4)Show detected musical notes
Divide the signal into segments and read them one at a time using a window. The segment expression is x(i : i+SizeWindow-1).
Identify the music note and print it on the console

5)Graph with music notes detected
