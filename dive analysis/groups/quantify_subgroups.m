%% quantify_subgroups
% LMB 3/25/24 2023a

deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05', ...
    'SOCAL_E_63','SOCAL_N_68',...
    'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};

totalSubgroups = [];

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',deps{j},'\cleaned_tracks\track*']); % directory of folders containing files
    spd = 60*60*24;

    for i = 1:length(df) % for each track

        myFile = dir([df(i).folder,'\',df(i).name,'\*distBtwnWhales.mat']); % load the folder name

        if size(myFile,1)>0

            trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
            myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

            for b = 1:numel(whale) % remove any fields that are 0x0
                if height(whale{b}) == 0
                    whale{b} = [];
                end
            end
            whale(cellfun('isempty',whale)) = []; % remove any empty fields

            if numel(whale)>=2 % if there are at least two whales

                % define some subgroups!
                subgroup = []; % initialize

                % the first way that we could define a subgroup is by time.
                % if these individuals don't overlap in time at all, then
                % they're not in the same subgroup.
                % these wouldn't be saved in the encSep struct

                % calculate all the pair combinations
                np = nchoosek(1:numel(whale),2);

                % find the pair combinations not saved in the labelstr
                for n = 1:numel(labelstr) % find those that are saved
                    nums = str2double(regexp(string(labelstr{n}),'\d+','match'));
                end
                % retain only the ones that don't match
                [~,idx] = ismember(np,nums,'rows');
                sep = np(idx==0,:);

                for n = 1:size(sep,1)
                    subgroup = [subgroup; table({['whale pair ', num2str(sep(n,:))]},numel(whale),{'time'})];
                end

                % this could also be a subgroup by distance though!
                % let's define a subgroup as more than a 1 km separation
                % these individuals would surely still know that each other are
                % there, but 1 km is definitely above the mean pairs distances
                % I typically see

                distances = []; % initialize for storing
                for n = 1:numel(encSep)
                    if ~isempty(encSep{n})
                        distances = [distances;nanmean(encSep{n}(:,1))];
                    end
                end

                labelstr(cellfun('isempty',labelstr)) = []; % remove any empty fields

                if any(distances>1000) % more than 1 km mean separation

                    aboveth = find(distances > 1000); % find which pairs are above the threshold

                    for t = 1:length(aboveth) % for each one
                        subgroup = [subgroup;table(labelstr{aboveth(t)},numel(whale),{'distance'})];
                    end
                else
                    % this is not a subgroup by distance, move on
                end


            end % close if statement for having 2 whales

        end % close if statement for file matching

        if size(subgroup,1)>0
            save([myFile.folder,'\',trackNum,'_subgroup.mat'],'subgroup'); % save the subgroup table
            subgroup2 = table(subgroup.Var1,subgroup.Var2,subgroup.Var3,repmat({trackNum},size(subgroup,1),1),repmat({deps{j}},size(subgroup,1),1));
            totalSubgroups = [totalSubgroups;subgroup2]; % save to master table
        end

    end % close loop for each track

    % add in some code here that will save a summary per deployment, allow
    % for subsequent code that will estimate the number of subgroups per
    % deployment

    % hypothesis that these whales are often subgrouping, but our recording
    % radius is too small to find all the subgroups

end % close loop for each deployment

%% compile
% now that we've defined subgroups, go back in and do some thinking about
% this

% hopefully those subgroups are straightforward to define

