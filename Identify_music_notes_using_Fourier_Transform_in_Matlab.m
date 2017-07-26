%File name: Identify music notes using Fourier Transform in Matlab
%Created by David Martins

%   1)Read the sound file.
fprintf('\nDo you want to see an example first?\n') 
opcion = menu('Do you want to see an example first?', '                       YES                      ', '                        NO                      '); %Create a small menu
switch opcion
	case 1
		filename = 'piano-phrase.wav'
        fprintf('I am going to run the piano-phrase.wav.\n')
	case 2
        fprintf('Type the file name on the command line.\n')
        fprintf('Do not forget the file extension.\n')
        while(1)
            try
                filename = input('Please enter: ','s'); %Function to read a  filename.
                [x, fs] = audioread(filename);    %Function to read a sound file.
                break;
            catch
                 fprintf('The file does not exist.\n')  %An error has occurred.
                 fprintf('Please try again.\n')
            end
        end
end

%   2)Listen to file.

fprintf('\nDo you want to listen to the file?') 
opcion = menu('Do you want to listen to the file?', '                       YES                      ', '                        NO                      ');
name = strcat('The filename is: ', filename);
disp(name);

if opcion == 1
    n = audioplayer(x, fs); %x is audio signal represented by a vector and fs is the sampling rate in Hz
    play(n);  %Function to run the audio.
end

%   3)View the graph with the data.

N = length(x);  %Function to see the length of audio file.
y = linspace(0, N/fs, N);   %Create the sequence of values for the axes.
freqs = -fs/2 : fs/N : fs/2 - fs/N; %fs/2 is not part of it.
Xfreq = fftshift(fft(x)); %Transform the data.

figure('name','Data Graphs'); %Create de window with the graphs
hold on

subplot(211), plot(y,x, 'g') %first graph
title(filename); 
xlabel('Time (s)'); 
ylabel('Amplitude');

subplot(212), plot(freqs, abs(Xfreq), 'g') %second graph
title('Signal frequency spectrum'); 
xlabel('Frequency (Hz)');
ylabel('Amplitude');

%   4)Show detected musical notes.

fprintf('\n');
SizeWindow = 2048; %%%You may need to change these values
SizeOverlap = 256;
if mod(length(x), 2) == 0 %even or odd the size of the length 
    f_window = -fs/2: fs/SizeWindow :fs/2 - fs/SizeWindow;
else
    f_window = -fs/2 + fs/(2*SizeWindow): fs/SizeWindow : fs/2 - fs/(2*SizeWindow);
end

indexes = 1: SizeWindow - SizeOverlap : length(x) - SizeWindow; %Discrete signal indices.
FF = zeros(size(indexes));
j=1;

%For each window, does
for i = indexes
    %Calculates the window correctly using the hamming method with the overlay.
    try
        X_window = fftshift(fft(x(i : i+SizeWindow-1) .* hamming(SizeWindow), SizeWindow));
    catch
        fprintf('Error');
    end
    
    %Calculate the maximum frequency.
    X_abs_max = max(abs(X_window));
    
    %Choose the frequency of the positive side
    ind = find(abs(X_window) == X_abs_max);
    
    %See the position where the maximum frequency is in the given window.
    FF(j) = f_window(ind(end));    
    j=j+1;
end


FF(FF <= 100) = 0;  %Remove noise
FreqNotes = [262/2  277/2  294/2  311/2  330/2 349/2  370/2  392/2  415/2  440/2  466/2  494/2 262  277  294  311  330  349  370  392  415  440  466  494 262*2  277*2  294*2  311*2  330*2  349*2  370*2  392*2  415*2  440*2  466*2  494*2  262*4  277*4  294*4  311*4  330*4];%List of note values
NameNotes = {'DÓ 1', 'DÓ# 1', 'RÉ 1', 'RÉ# 1', 'MI 1', 'FÁ 1', 'FÁ# 1', 'SOL 1', 'SOL# 1', 'LÁ 1', 'LÁ# 1', 'SI 1','DÓ 2', 'DÓ# 2', 'RÉ 2', 'RÉ# 2', 'MI 2', 'FÁ 2', 'FÁ# 2', 'SOL 2', 'SOL# 2', 'LÁ 2', 'LÁ# 2', 'SI 2', 'DÓ 3', 'DÓ# 3', 'RÉ 3', 'RÉ# 3', 'MI 3', 'FÁ 3', 'FÁ# 3', 'SOL 3', 'SOL# 3', 'LÁ 3', 'LÁ# 3', 'SI 3', 'DÓ 4', 'DÓ# 4', 'RÉ 4', 'RÉ# 4', 'MI 4'};
array = zeros(size(FF));
index = 1;
fprintf('List of music notes:\n');
for i=1:length(FF) %Discrete signal values
    freq = FF(i);
    ind=1;
    for j=1:1:length(FreqNotes)
        if(j ~= length(FreqNotes)) %The note is between the first and the fourth octave
            if (freq > FreqNotes(j) && freq < FreqNotes(j+1)) %Identify the nearest note.
                if(abs(freq - FreqNotes(j+1)) >= abs(freq - FreqNotes(j)))
                     ind = j;
                else
                     ind = j+1;
                end
                break;
            end
        end
    end
    
    for m=1:length(array) %Do not print consecutive notes that are the same.
        if(array(m) == round(FF(i)));
            flag = 0;
            break;
        end
        flag = 1;   
    end
    if(flag == 1) %Print notes detected
        fprintf('%-5s -> %.2f Hz\n',NameNotes{ind}, FF(i));
        array(index) = round(FF(i));
        index = index +1;  
    end
end

%   5)Graph with music notes detected.
figure('name','Data Graphs with the notes'); %Create de window with the graphs

%It only serves to make the graph conform to a frequency
duration_windows = SizeWindow*1000/fs;
duration_overlaps = SizeOverlap*1000/fs;

t3 = 1 : duration_windows-duration_overlaps : length(x)/fs*1000-duration_windows;
for i=1: 1:length(t3) %Remove gaps
    if(FF(i)== 0)
        t3(i) = NaN;
    end
end
plot(t3, FF,'og');  %Create Window with graph
rotate3d;
title('Evolution of musical notes');
xlabel('Temporal window (ms)');
ylabel('Frequency (Hz)');
fprintf('End');
pause;
close all;