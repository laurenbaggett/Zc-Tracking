%% analyze_speed

% calcualte speed, load in data, make some visualizations

%% first, calculate speed

% deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};
% deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};
% deps = {'SOCAL_E_63'};
% deps = {'SOCAL_N_68'};
deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05', ...
    'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75', ...
    'SOCAL_E_63','SOCAL_N_68'};

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']);

    for i = 1:length(df)

        myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
        trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

        speedStruct = whale_spd(whale);

        save([df(i).folder,'\',df(i).name,'\',trackNum,'_SpeedStruct.mat'],'speedStruct');

    end
end


%%

% deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};
% deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};
% deps = {'SOCAL_E_63'};
% deps = {'SOCAL_N_68'};
deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05', ...
    'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75', ...
    'SOCAL_E_63','SOCAL_N_68'};

mSp = [];
stdSp = [];
mSpDesc = [];
stdSpDesc = [];
site_desc = []; % 1 is W, 2 is H, 3 is E, 4 is N
site = [];
% class = [];

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']);

    for i = 1:length(df)

        myFile = dir([df(i).folder,'\',df(i).name,'\*speedStruct.mat']); % load the folder name
        trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
        % z_stats is outdated, look for turns
        myFile = dir([df(i).folder,'\',df(i).name,'\*turns.mat']); % load the folder name

        if ~isempty(myFile) % if we have a turns file
            load(fullfile([myFile.folder,'\',myFile.name])); % load the file
            % brWhales = ~isnan(turns);
        else
            turns = nan(1,numel(speedStruct)); % else, these whales are at depth
        end

        for wn = 1:size(speedStruct)

            if size(speedStruct{wn},1)>0

                if ~isnan(turns(wn)) % if we have a whale that needs to be separated into initial descent/foraging sections

                    tt = speedStruct{wn}.values(1:turns(wn)-1,:);
                    tt = sum(tt(~isnan(tt.spd),2));

                    if tt.tms > 60*10 % 10 minute threshold

                        desc = speedStruct{wn}.values.spd(1:turns(wn)-1);
                        medDesc = nanmedian(desc);
                        stdDesc = nanstd(desc);
                        mSpDesc = [mSpDesc,medDesc];
                        stdSpDesc = [stdSpDesc,stdDesc];
                        stlet = deps{j}(7);
                        if stlet == 'W'
                            site_desc = [site_desc;1];
                        elseif stlet == 'H'
                            site_desc = [site_desc;2];
                        elseif stlet == 'E'
                            site_desc = [site_desc;3];
                        elseif stlet == 'N'
                            site_desc = [site_desc;4];
                        end

                    end

                    if turns(wn)<length(speedStruct{wn}.values.spd)

                        tt = speedStruct{wn}.values(turns(wn):end,:);
                        tt = sum(tt(~isnan(tt.spd),2));

                        if tt.tms > 60*10 % 10 minute threshold

                            medDepth = nanmedian(speedStruct{wn}.values.spd(turns(wn):end));
                            stdDepth = nanstd(speedStruct{wn}.values.spd(turns(wn):end));
                            mSp = [mSp,medDepth];
                            stdSp = [stdSp,stdDepth];

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

                if speedStruct{wn}.summary.trackedTimes > 60*10 % 5 minute threshold
                    mSp = [mSp,speedStruct{wn}.summary.medianSpd];
                    stdSp = [stdSp,speedStruct{wn}.summary.stdSpd];
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
            clear turns
        end

    end

end

% plot all
figure
subplot(1,2,1)
histogram(mSp,[0:1:10],'facecolor',[0 0.4470 0.7410],'facealpha',1)
title('At Depth (Foraging)')
xlabel('Median Speed');

subplot(1,2,2)
histogram(mSpDesc,[0:1:10],'facecolor',[0.8500 0.3250 0.0980],'facealpha',1)
title('Initial Descent')
xlabel('Median Speed');

% subplot(2,2,3)
% histogram(stdSp,[0:1:15],'facecolor',[0 0.4470 0.7410],'facealpha',.5)
% xlabel('Std Speed');
% 
% subplot(2,2,4)
% histogram(stdSpDesc,[0:1:15],'facecolor',[0.8500 0.3250 0.0980],'facealpha',.5)
% xlabel('Std Speed');

% now, plot by site
figure
subplot(2,4,5)
histogram(mSp(find(site==1)),[0:1:10],'facecolor',[0 0.4470 0.7410],'facealpha',.6)
ylabel('At Depth (Foraging)')
xlabel('Median Speed');
ylim([0 120])

subplot(2,4,6)
histogram(mSp(find(site==2)),[0:1:10],'facecolor',[0.8500 0.3250 0.0980],'facealpha',.6)
xlabel('Median Speed');
ylim([0 120])

subplot(2,4,7)
histogram(mSp(find(site==3)),[0:1:10],'facecolor',[0.4940 0.1840 0.5560],'facealpha',.6)
xlabel('Median Speed');
ylim([0 120])

subplot(2,4,8)
histogram(mSp(find(site==4)),[0:1:10],'facecolor',[0.4660 0.6740 0.1880],'facealpha',.6)
xlabel('Median Speed');
ylim([0 120])

subplot(2,4,1)
histogram(mSpDesc(find(site_desc==1)),[0:1:10],'facecolor',[0 0.4470 0.7410],'facealpha',1)
ylabel('Initial Descent')
title('W')

subplot(2,4,2)
histogram(mSpDesc(find(site_desc==2)),[0:1:10],'facecolor',[0.8500 0.3250 0.0980],'facealpha',1)
title('H')

subplot(2,4,3)
histogram(mSpDesc(find(site_desc==3)),[0:1:10],'facecolor',[0.4940 0.1840 0.5560],'facealpha',1)
ylim([0 20])
title('E')

subplot(2,4,4)
histogram(mSpDesc(find(site_desc==4)),[0:1:10],'facecolor',[0.4660 0. 6740 0.1880],'facealpha',1)
title('N')
ylim([0 20])

% doesn't seem to be much of a difference here


% % export for R analysis
forage = table(mSp',stdSp',site,'VariableNames',{'median','std','site'});
descend = table(mSpDesc',stdSpDesc',site_desc,'VariableNames',{'median','std','site'});
writetable(forage,'F:\Zc_Analysis\speed\speeds_atDepth.csv')
writetable(descend,'F:\Zc_Analysis\speed\speeds_descending.csv')

%%
