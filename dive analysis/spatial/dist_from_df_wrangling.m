%% dist_from_sf_wrangling
% modified to account for new dive classifications

% deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};
% deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};
% deps = {'SOCAL_E_63'};
% deps = {'SOCAL_N_68'};
deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05', ...
    'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75', ...
    'SOCAL_E_63','SOCAL_N_68'};

mDst = [];
stdDst = [];
site_desc = []; % 1 is W, 2 is H, 3 is E, 4 is N
site = [];
% class = [];
init = 0;
deep = 0;

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']);

    for i = 1:length(df)

        myFile = dir([df(i).folder,'\',df(i).name,'\*distFromSeafloor.mat']); % load the folder name
        trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
        % z_stats is outdated, look for turns
        myFile = dir([df(i).folder,'\',df(i).name,'\*turns.mat']); % load the folder name

        if ~isempty(myFile) % if we have a turns file
            load(fullfile([myFile.folder,'\',myFile.name])); % load the file
            % brWhales = ~isnan(turns);
            init = init+1;
        else
            turns = nan(1,numel(distfromsf)); % else, these whales are at depth
            deep = deep+1;
        end

        for wn = 1:numel(distfromsf)

            if size(distfromsf{wn},1)>0

                if ~isnan(turns(wn)) % if we have a whale that needs to be separated into foraging sections only

                    if turns(wn)<length(distfromsf{wn}(:,1))

                            medDepth = nanmedian(distfromsf{wn}(turns(wn):end,2));
                            stdDepth = nanstd(distfromsf{wn}(turns(wn):end,2));
                            % if medDepth>200
                            %     keyboard
                            % end
                            mDst = [mDst;medDepth];
                            stdDst = [stdDst;stdDepth];
                            stlet = deps{j}(7);

                            stlet = deps{j}(7);
                            if stlet == 'W'
                                site = [site;1];
                            elseif stlet == 'H'
                                site = [site;2];
                            elseif stlet == 'E'
                                site = [site;3];
                            elseif stlet == 'N'
                                site = [site;4];
                            end

                    end

                end

                if sum(~isnan(distfromsf{wn}(:,1))) > 50 % size(distfromsf{wn}(:,1),1) > 20 % if we have at least 10 data points
                    % medDepth = mn{1,wn};
                    medDepth = nanmedian(distfromsf{wn}(:,2));
                    % stdDepth = mn{2,wn};
                    stdDepth = nanstd(distfromsf{wn}(:,2));
                    % if medDepth>200
                    %     keyboard
                    % end
                    mDst = [mDst;medDepth];
                    stdDst = [stdDst;stdDepth];
                    stlet = deps{j}(7);
                    if stlet == 'W'
                        site = [site;1];
                    elseif stlet == 'H'
                        site = [site;2];
                    elseif stlet == 'E'
                        site = [site;3];
                    elseif stlet == 'N'
                        site = [site;4];
                    end
                end
            end
        end
            clear turns

    end

end

mDstTable = table(mDst,stdDst,site,'VariableNames',{'median','std','site'});
writetable(mDstTable,'F:\Tracking\allDeps_foragingOnly_distFromSf.csv');



%% old code
% LMB 3/13/24 2023a

% load in the data
% % site H
% h72 = load('F:\Tracking\Erics_detector\SOCAL_H_72\deployment_stats\SOCAL_H_72_mean_distfromsf_NEW.mat');
% h73 = load('F:\Tracking\Erics_detector\SOCAL_H_73\deployment_stats\SOCAL_H_73_mean_distfromsf_NEW.mat');
% h74 = load('F:\Tracking\Erics_detector\SOCAL_H_74\deployment_stats\SOCAL_H_74_mean_distfromsf_NEW.mat');
% h75 = load('F:\Tracking\Erics_detector\SOCAL_H_75\deployment_stats\SOCAL_H_75_mean_distfromsf_NEW.mat');
% full = horzcat(h72.distfromsfmeans, h73.distfromsfmeans, h74.distfromsfmeans);
% % site E
% a = load('F:\Tracking\Erics_detector\SOCAL_E_63\deployment_stats\SOCAL_E_63_mean_distfromsf_NEW.mat');
% full = a.distfromsfmeans;
% % site N
a = load('F:\Tracking\Erics_detector\SOCAL_N_68\deployment_stats\SOCAL_N_68_mean_distfromsf_NEW.mat');
full = a.distfromsfmeans;
% % site W
% a = load('F:\Tracking\Erics_detector\SOCAL_W_01\deployment_stats\SOCAL_W_01_mean_distfromsf_NEW.mat');
% b = load('F:\Tracking\Erics_detector\SOCAL_W_02\deployment_stats\SOCAL_W_02_mean_distfromsf_NEW.mat');
% c = load('F:\Tracking\Erics_detector\SOCAL_W_03\deployment_stats\SOCAL_W_03_mean_distfromsf_NEW.mat');
% d = load('F:\Tracking\Erics_detector\SOCAL_W_04\deployment_stats\SOCAL_W_04_mean_distfromsf_NEW.mat');
% e = load('F:\Tracking\Erics_detector\SOCAL_W_05\deployment_stats\SOCAL_W_05_mean_distfromsf_NEW.mat');
% full = horzcat(a.distfromsfmeans,b.distfromsfmeans,c.distfromsfmeans,d.distfromsfmeans,e.distfromsfmeans);

avg = [];
sd = [];
clss = [];
tnum = [];
med = [];

for i = 1:length(full)
    whale = full{i};
    for wn = 1:size(whale,2)
        avg = vertcat(avg,whale(1,wn));
        sd = vertcat(sd,whale(2,wn));
        clss = vertcat(clss,whale(4,wn));
        tnum = vertcat(tnum,whale(3,wn));
        % med = vertcat(med,whale(5,wn));
    end
end

% avg = str2double(avg);
% sd = str2double(sd);
% clss = str2double(clss);

mdfsf = table(avg,sd,clss, tnum);

writetable(mdfsf, 'F:\Tracking\Erics_detector\siteN_disffromsf_masterTable_NEW.csv');