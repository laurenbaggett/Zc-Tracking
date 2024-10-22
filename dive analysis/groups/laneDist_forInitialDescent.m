%% laneDist_forInitialDescent

% this script will plot late distances for initial descent tracks where
% there are more than one whale

% first, identify encounters where more than one whale is exhibiting the
% initial descent behavior
% then, grab lane distance only for those whales
% plot lane distance during this behavior, see if there is any clustering
% lane distance vs number of whales exhibiting this behavior? maybe tighter
% lane distance when 3 or 4 whales are diving from the surface, compared to
% when there are 2? or maybe the lane distance is consistent regardless of
% number of whales? is there a difference between sites?

% for a later project: lane distance at the seafloor when whales are
% exhibiting coordinated behavior

df = dir(['F:\Tracking\Erics_detector\SOCAL_W_05\cleaned_tracks\track*']); % directory of folders containing files

idlaneMax = [];
idlaneMin = [];
idlaneMean = [];
idnumwhales = [];
idtracknum = [];

for i = 1:length(df)

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    for b = 1:numel(whale) % remove any fields that are 0x0
        if height(whale{b}) < 3
            whale{b} = [];
        end
    end
    whale(cellfun('isempty',whale)) = []; % remove any empty fields

    if numel(whale)>1 % if we have more than one whale
        myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']); % load the folder name
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
        initial = find(z_stats(6,:)==1);

        if length(initial) > 1 % if there is more than one whale in initial descent phase
            % initial will have the indices of where there are initial
            % descent whales (whale numbers)
            % find these pairs in the lane distance calculations
            myFile = dir([df(i).folder,'\',df(i).name,'\*laneDist.mat']); % load the folder name
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

            % calculate the number of pair combinations of initial descent
            % whales
            np = nchoosek(1:length(initial),2); % find the pair combos

            for n = 1:height(np) % for each pair combo
                % find the matching labelstr index
                for s = 1:length(labelstr)
                smatch = strfind(labelstr{s},[num2str(np(n,1)),'  ',num2str(np(n,2))]);
                if cell2mat(smatch)~=0
                    idlaneMax = vertcat(laneMax(s),idlaneMax);
                    idlaneMin = vertcat(laneMin(s),idlaneMin);
                    idlaneMean = vertcat(laneMeans(s),idlaneMean);
                    idnumwhales = vertcat(length(initial),idnumwhales);
                    idtracknum = vertcat(string(trackNum),idtracknum);
                end
                end

            end


        end % end if statement for multiple whales in initial descent

    end % end if statement for multiple whales

end % move on to the next file in this deployment

fullTable = horzcat(idlaneMin,idlaneMax,idlaneMean,idnumwhales,idtracknum);

writematrix(fullTable,'F:\Tracking\Erics_detector\SOCAL_W_05\deployment_stats\SOCAL_W_05_initialDescent_laneDist.csv')