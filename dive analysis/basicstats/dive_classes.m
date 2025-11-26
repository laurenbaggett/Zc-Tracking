%% dive_classes

% new script to classify dive classes
% old analysis: types 1, 2, and 3 from only one site and with old spline
% smoothing approach. now, just break into two classes (initial descent and
% presumed foraging)

% define initial descent if the track starts more than 200 m above the
% seafloor
% possibly modify this to be 300 m or something since site N

% deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};
% deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};
% deps = {'SOCAL_E_63'};
% deps = {'SOCAL_N_68'}; 
deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05',...
    'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75',...
    'SOCAL_E_63','SOCAL_N_68'};

th = 200; % threshold for distance above seafloor, in m

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']);
        
        for i = 1:length(df)
            
            myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
            trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
            myFile = dir([df(i).folder,'\',df(i).name,'\*distFromSeafloor.mat']);
            load(fullfile([myFile.folder,'\',myFile.name])); % load distance from seafloor

            turns = nan(1,numel(whale)); % preallocate to save when the cutoff happens

            for wn = 1:numel(whale)

                if size(whale{wn},2) > 14 % if we have a whale with generated smooth
                    % check if the whale starts at more than 300 meters
                    % above the seafloor
                    if distfromsf{wn}(1,2) > th
                        % when the whale makes it to foraging depth
                        turnidx = find(distfromsf{wn}(:,2)<th,1,'first');
                        if isempty(turnidx)
                            turnidx = size(distfromsf{wn},1);
                        end
                        turns(wn) = turnidx;
                    end % close if statement for th
                end % close if statement for generated smooth

            end % for loop for whale number

            if any(~isnan(turns))
                save([df(i).folder,'\',df(i).name,'\',trackNum,'_turns2.mat'],'turns') % save the matrix
                disp(string(trackNum))
            end

        end % for loop for data frame
end % for loop for deployments

%% compare these to the speeds and save some info

% in the end we want to save one matrix with median velocities for these
% initial descent portions of the track, and then another with median
% velocities for those tracks that are at the seafloor

% deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};
% deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};
% deps = {'SOCAL_E_63'};
% deps = {'SOCAL_N_68'}; 
% deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05',...
    % 'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75',...
    % 'SOCAL_E_63','SOCAL_N_68'};

initialSpds = []; % preallocate
forageSpds = []; % preallocate

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']);
    
    for i = 1:length(df)

        myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
        load(fullfile([myFile.folder,'\',myFile.name])); % load the file

        myFile = dir([df(i).folder,'\',df(i).name,'\*distSpd.mat']); % load the folder name
        % trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
        
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
        myFile = dir([df(i).folder,'\',df(i).name,'\*turns.mat']);
        
        if ~isempty(myFile)
            
            load(fullfile([myFile.folder,'\',myFile.name])); % load turns, if it exists
            
            for wn = 1:length(turns) % size(medianSpd,2) % for each whale
                if ~isnan(turns(1,wn))
                    initialSpds = [initialSpds, nanmedian(spd(1:turns(1,wn)-1,wn))];
                    forageSpds = [forageSpds, nanmedian(spd(turns(1,wn)-1:end,wn))];
                else
                    forageSpds = [forageSpds,medianSpd(wn)];
                end
            end
        
        else
            for wn = 1:size(medianSpd,2)
                forageSpds = [forageSpds,medianSpd(wn)];
            end
        end 
    
    end
end

% forageSpds2 = forageSpds;
% forageSpds2(forageSpds2==0) = nan;
% 
% figure
% histogram(initialSpds(~isnan(initialSpds)))
% figure
% histogram(forageSpds2(~isnan(forageSpds2)))
%% 
cmap = cmocean('matter');
a = floor(size(cmap,1)/4);
cmap2 = [cmap(a,:);cmap(a*2,:);cmap(a*3,:);cmap(a*4,:)];

figure
scatter(1,1,[],'filled','markerfacecolor',cmap2(1,:))
hold on
scatter(2,2,[],'filled','markerfacecolor',cmap2(2,:))
scatter(3,3,[],'filled','markerfacecolor',cmap2(3,:))
scatter(4,4,[],'filled','markerfacecolor',cmap2(4,:))