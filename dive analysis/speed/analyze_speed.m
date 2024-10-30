%% analyze_speed

% load in data, make some visualizations

deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};
% deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};
% deps = {'SOCAL_E_63'};
% deps = {'SOCAL_N_68'};

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']);

    for i = 1:length(filePath)
        
        myFile = dir([df(i).folder,'\',df(i).name,'\*distSpd.mat']); % load the folder name
        trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
        



    end

end
