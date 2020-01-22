%%
clear all;
clc;
%%  Ask for parameters
%   asks the user for the Sampling frequency
msg1 = 'Hello user, Please specify the Sampling frequency of the signal in (Hz): ';
Fs = input(msg1);

%   asks the user for the Start and end of time scale
T = zeros(1,2);
msg2 = 'Now, Please specify the Start of time scale of the signal: ';
T(1,1) = input(msg2);
msg3 = 'Now, Please specify the end of time scale of the signal: ';
T(1,2) = input(msg3);
T = sort(T);
%   asks the user for Number of the break points and their positions
nBP = -1;
while (~(nBP>=0)) && (~(mod(nBP,1)))
    msg4 = 'Please Enter the number of breakpoints in the signal ';
    nBP = (input(msg4));
end

BP = zeros(1,nBP);

if  (nBP)
msg5 = 'Please Enter the first breakpoint in the signal ';
BP(1,1) = input(msg5);    
end

if (nBP > 1)
     for i = 2:length(BP)
        msg6 = 'Please Enter the next breakpoint in the signal ';
        BP(1,i) = input(msg6);
     end    
end

BO = T;

for i = 1:length(BP)
    if ((BP(i)>T(1,1))&&(BP(i)<T(1,2)))
      BO = [BO,BP(i)];   
    end
end 

BO = sort(BO);
S = (BO(1,length(BO))-(BO(1,1))).*(Fs);
t = linspace(BO(1,1),BO(1,length(BO)),S);
%%  Generate the signal
D=0;
for i = 1:length(BO)-1
    SW_1=0;
    while ~((SW_1 >= 1)&&(SW_1 <= 5))
        disp(' (1) DC signal ');
        disp(' (2) Ramp signal ');
        disp(' (3) General order polynomial ');
        disp(' (4) Exponential signal ');
        disp(' (5) Sinusoidal signal ');
        msg7 = 'Please enter the number of the wanted signal from the above list: ';
        SW_1 = input(msg7);
    end
    
    switch SW_1
        case 1
            disp('DC signal');
            msg8 = 'Please enter the Amplitude of the DC signal: ';
            A = input(msg8);
            DC = (A).*(ones(1,(((BO(1,i+1))-(BO(1,i)))).*(Fs)));
            signal_i = DC;       

        case 2
            disp('Ramp signal');
            msg9 = 'Please enter the Slope of the ramp signal: ';
            m = input(msg9);
            msg10 = 'Please enter the intercept of the ramp signal: ';
            c = input(msg10);
            t1 = linspace(BO(1,i),BO(1,i+1),(BO(1,i+1)-(BO(1,i))).*(Fs));
            Ramp = ((m).*(t1))+c;
            signal_i = Ramp;       

        case 3
            disp('General order polynomial');
            msg11 = 'Please enter the Amplitude of the polynomial signal: ';
            A = input(msg11);
            msg12 = 'Please enter the Power of the polynomial signal: ';
            n = input(msg12);
            msg13 = 'Please enter the Intercept of the polynomial signal: ';
            c = input(msg13);
            t1 = linspace(BO(1,i),BO(1,i+1),(BO(1,i+1)-(BO(1,i))).*(Fs));
            Poly = (t1).^(n);
            Poly = (Poly).*(A);
            Poly = Poly + c ;
            signal_i = Poly; 
            
        case 4
            disp('Exponential signal');
            msg14 = 'Please enter the Amplitude of the Exponential signal: ';
            A = input(msg14);
            msg15 = 'Please enter the Exponent of the Exponential signal: ';
            a = input(msg15);
            t1 = linspace(BO(1,i),BO(1,i+1),(BO(1,i+1)-(BO(1,i))).*(Fs));
            A_a_t =(a).^(t1);
            A_a_t = (A).*(A_a_t);
            signal_i = A_a_t;

        case 5
            disp('Sinusoidal signal');
            msg16 = 'Please enter the Amplitude of the Sinusoidal signal: ';
            A = input(msg16);
            msg17 = 'Please enter the Frequency of the Sinusoidal signal in Hz: ';
            f = input(msg17);
            msg18 = 'Please enter the Phase of the Sinusoidal signal in degrees: ';
            ph = input(msg18);

            t1 = linspace(BO(1,i),BO(1,i+1),(BO(1,i+1)-(BO(1,i))).*(Fs));
            sinusoidal = sin(((2).*(pi).*(f).*(t1))+((ph).*(pi)./(180)));  
            sinusoidal = (A).*(sinusoidal);
            signal_i = sinusoidal;

        otherwise
            disp('Error');
    end
        
    if (D==0)
        signal_1 = signal_i;
        D=1;
    else 
        signal_1 = [signal_1  signal_i];
    end 
end 
%% Plot the first signal
figure;
plot(t,signal_1);
grid on;
%%  Signal operations
disp('Hi again, Do you want to perform any operations on the generated signal ? ');
SW_2=0;
    while ~((SW_2 >= 1)&&(SW_2 <= 6))
        disp(' (1) Amplitude Scaling ');
        disp(' (2) Time reversal ');
        disp(' (3) Time shift ');
        disp(' (4) Expanding the signal ');
        disp(' (5) Compressing the signal ');
        disp(' (6) None ');
        msg19 = 'Kindly choose from the above list ';
        SW_2 = input(msg19);
    end
switch SW_2
        case 1
            disp('Amplitude Scaling');
            msg20 = 'Please enter the scale value: ';
            A_1 = input(msg20);
            A_1 = abs(A_1);
            signal_2 = (A_1).*(signal_1);
            t2 = t;
     
        case 2
            disp('Time reversal');
            signal_2 = (signal_1);
            t2 = -t;
            
        case 3
            disp('Time shift');
            msg22 = 'Please enter the shift value: ';
            sh = input(msg22);
            signal_2 = (signal_1);
            t2 = t + sh;
     
        case 4
            disp('Expanding the signal');
            msg23 = 'Please enter the expanding value: ';
            ex = input(msg23);
            ex = abs(ex);
            signal_2 = (signal_1);
            t2 = (ex).*(t);
     
        case 5
            disp('Compressing the signal');
            msg24 = 'Please enter the compressing value: ';
            comp = input(msg24);
            comp = abs(comp);
            signal_2 = (signal_1);
            t2 = (t)./(comp);     
        
        case 6
            disp('None');
            signal_2 = (signal_1);
            t2 = t;
    
        otherwise
            disp('Error');
end
%% Plot the second signal
figure;
plot(t2,signal_2);
grid on;