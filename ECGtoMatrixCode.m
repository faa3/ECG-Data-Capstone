% This file converts ECG data into numerical arras

clear;
close all;
clc;
% Include directory of your files.
files = dir("C:\Users\fanga\OneDrive\Documents\Fall 2023\elec 594\THC Docs\TCH Data\Dataset 1\JET data\**\*h5");
filesList = []; % This Variable will store the names of all files as a list.
for i=1:length(files)
    filesList = [filesList ; strcat(files(i).folder,'\',files(i).name)];
end
%filesList(1,114:131) name index for SINUS data
%filesList(1,112:129) name index for JET data
%filesList(12,:) = [];
[k, m] = size(filesList);
nameList = [];
sizeList = [];
% Perform iteration to extract recordings from each file. 
for i=1:k
    filename = filesList(i,:);
    info = h5info(filename);
    HR = h5read(info.Filename,[info.Name 'PARM_HR']); %Extract heartbeat
    ECG1 = h5read(info.Filename,[info.Name 'GE_WAVE_ECG_1_ID']); %Extract ECG from lead 1
    time = h5read(info.Filename,[info.Name 'time']);
    
    Fs = 1/mean(diff(time));
    T = 1/Fs;
    L = length(time);
    [ECGstft, f, t] = stft(ECG1, Fs); % Compute STFT
    
    hr_Hz = mean(HR)/60; %heart rate in frequency.
    %hr_Hz = 134/60
    freq_mask = (hr_Hz*0.2 < f) & (f < hr_Hz*1.8); %Create Filter
    
    freqMaskIdx = find(freq_mask == 0); 


    ECGstft(freqMaskIdx, :) =  0; % Filter out signal
    ECGatHR = istft(ECGstft, Fs); 


    ECGHilbert = hilbert(real(ECGatHR)); % Compute Hilber transform

    timeNew = [1:size(ECGHilbert)];

    % The next lines of code will perform the interpolation
    phase_broken = angle(ECGHilbert);
    phase_unbroken = unwrap(phase_broken);
    
    uniform_phase = 0: 2*pi/100 :max(phase_unbroken); % Create discrete uniform phase points to interpolate.
    
    %The next lines ensure that time points are unique and in increasing
    %order.
    samplePoints = [phase_unbroken, ECGHilbert ];
    sampleOrdered = sortrows(samplePoints);

    [~,uidx] = unique(sampleOrdered(:,1),'stable');
    uniqueSamples = sampleOrdered(uidx,:);

    SampleECG = [phase_unbroken, ECG1(1:size(phase_unbroken))]; % Since size(ECG1) > size(phase_unbroken)
    SampleECGOrdered = sortrows(SampleECG);

    [~,uidx] = unique(SampleECGOrdered(:,1),'stable');
    uniqueECG = SampleECGOrdered(uidx,:);
    
    % Perform interpolation.
    ECG_hilb_uniform_phase = interp1( uniqueSamples(:,1), uniqueSamples(:,2), uniform_phase );
    ECG_uniform_phase = interp1( uniqueECG(:,1), uniqueECG(:,2), uniform_phase );
    
    uniform_cycles = uniform_phase/(2*pi);

    % figure(1), 
    idx = 100*[1:1:floor(uniform_cycles(end))] - 5;
    % plot(uniform_cycles, ECG_uniform_phase); hold on;
    % scatter( uniform_cycles(idx) , ECG_uniform_phase(idx),'r' ); hold off;
    % xlabel('cycles'); grid;
    % 
    % figure(2)
    % plot(time,ECG1);

    % Compute hartbeat array
    heartbeat = [];
    % figure;hold on;
    for n=1:length(idx)-1
        heartbeat(n,:) = ECG_uniform_phase(idx(n):idx(n+1));
    %     plot(heartbeat(n,:), 'k');
    
    end
    
    %plot(mean(heartbeat,1), 'r','linewidth',3);
    %figure; hold on;
    [rows,cols] = size(heartbeat);
    
    %Normalize heartbeats as probabilities.
    for n=1:rows
        heartbeat(n,:) = heartbeat(n,:) - min(heartbeat(n,:));
        heartbeat(n,:) = heartbeat(n,:)/ sum(heartbeat(n,:));
        %plot(heartbeat(n,:), 'k');
    end
    %plot(mean(heartbeat,1), 'r','linewidth',3);
    writematrix(heartbeat, strcat(filename(112:129),'.csv')); 
    
    nameList = [nameList;filename(112:129)];
    sizeList = [sizeList; size(heartbeat)];
    

end
% writematrix(nameList, 'nameList.csv');
% writematrix(sizeList, 'sizeList.csv');

