%% diveClass_summaryPerSite
% LMB 2023a 4/10/24
% make summary tables giving encounter number, dive class, whale number,
% total numwhales per deployment.

df = dir(['F:\Tracking\Erics_detector\SOCAL_W_05\cleaned_tracks\track*']); % directory of folders containing files
diveClassSummary = []; % initialize

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']); % load the folder name
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    trackNum = str2num(extractAfter(trackNum,'track'));
    
    for wn = 1:length(whale)
        rw = horzcat(trackNum,z_stats(6,wn),wn,length(whale));
        diveClassSummary = vertcat(diveClassSummary,rw);
    end

end

save('F:\Tracking\Erics_detector\SOCAL_W_05\deployment_stats\SOCAL_W_05_diveClassSummary.mat','diveClassSummary');

%% actually calculate some summary stats here

siteList = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04', 'SOCAL_W_05'};
nums = [1,2,3,4, 5];
% siteList = {'SOCAL_E_63'};
% nums = [63];
fullSiteTbl = [];

for j = 1:length(siteList)

    myFile = dir(['F:\Tracking\Erics_detector\',char(siteList(j)),'\deployment_stats\*diveClassSummary.mat']);
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    diveClassSummary(:,5) = nums(j);
    fullSiteTbl = vertcat(fullSiteTbl,diveClassSummary);    

end

initialDescent = fullSiteTbl(find(fullSiteTbl(:,2)==1),:);
consistentTrajectory = fullSiteTbl(find(fullSiteTbl(:,2)==2),:);
variableTrajectory = fullSiteTbl(find(fullSiteTbl(:,2)==3),:);
weird = fullSiteTbl(find(fullSiteTbl(:,2)==4),:);
other = fullSiteTbl(find(fullSiteTbl(:,2)~=1),:);

fullMinusWeird = fullSiteTbl(find(fullSiteTbl(:,2)~=4),:);

initialDescentProportion = height(initialDescent)/height(fullMinusWeird);
consistentTrajectoryProportion = height(consistentTrajectory)/height(fullMinusWeird);
variableTrajectoryProportion = height(variableTrajectory)/height(fullMinusWeird);
weirdProportion = height(weird)/height(fullSiteTbl);
notInitial = height(other)/height(fullSiteTbl);

% SOCAL W
% initial descent proportion = 0.1302
% consistent trajectory proportion = 0.2921
% variable trajectory proportion = 0.5777
% proportion not initial descent = 0.8883

% SOCAL H
% initial descent proportion = 0.186256781193490
% consistent trajectory proportion = 0.171790235081374
% variable trajectory proportion = 0.641952983725136
% proportion not initial descent = 0.825423728813559

% SOCAL E
% initial descent proportion = 0.051490514905149
% consistent trajectory proportion = 0.271002710027100
% variable trajectory proportion = 0.677506775067751
% proportion not initial descent = 0.954869358669834

% SOCAL N
% initial descent proportion = 0.269230769230769
% consistent trajectory proportion = 0.102564102564103
% variable trajectory proportion = 0.628205128205128
% proportion not initial descent = 0.743902439024390