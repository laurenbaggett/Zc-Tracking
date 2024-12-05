%% laneDist_slope

deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75',...
    'SOCAL_E_63','SOCAL_N_68',...
    'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};

siteDist = [];
siteSlopes = [];
site = [];

for j = 1:length(deps)

    a = load(['F:\Tracking\Erics_detector\',deps{j},'\deployment_stats\',deps{j},'_distBtwnGrps']);
    thst = deps{j}(7);
    site = [site;repmat(thst,length(a.grpDistMeans),1)];
    % site{j} = thst;
    siteDist = [siteDist;a.grpDistVals'];
    siteSlopes = [siteSlopes;a.grpDistSlopes'];

end

% for each, run a linear model and calculate the slope, add to the means
% string
allMeans = [];
allMax = [];
allMin = [];
allSlp = [];
allSite = [];

for i = 1:length(siteDist)
    thisEnc = siteDist{i};
    thisSlp = siteSlopes{i};
    thisSite = site(i);

    mn = [];
    mx = [];
    miin = [];
    slp = [];
    ste = [];

    for j = 1:length(thisEnc)
        if ~isempty(thisEnc{j})
            mn = vertcat(mn,mean(abs(thisEnc{j}(:,1))));
            mx = vertcat(mx,max(abs(thisEnc{j}(:,1))));
            miin = vertcat(miin,min(abs(thisEnc{j}(:,1))));
            slp = vertcat(slp,thisSlp{j});
            ste = vertcat(ste,thisSite);
        end
    end

    allMeans = vertcat(allMeans, mn);
    allMax = vertcat(allMax,mx);
    allMin = vertcat(allMin,miin);
    allSlp = vertcat(allSlp,slp);
    allSite = vertcat(allSite,ste);
end


% figure
% errorbar(1:height(allMeans),allMeans,allMeans-allMin,allMax-allMeans,0,0,'o','color','black')
% ylabel('Distance Between Pairs (m)')
% xlim([0 height(allMeans)])
% ylim([0 7000])
% title('Site N')
breaks = [0:10:5000];

figure
histogram(allSlp)
xlim([-13 13])
title('slopes, all deployments')

figure
histogram(allMeans,breaks)
title('mean pairs distance, all deployments')

% by site
figure
tiledlayout(1,4)
nexttile
histogram(allSlp(allSite=='W'),'facecolor','#0072BD')
title('W slope')
xlim([-12 12])
nexttile
histogram(allSlp(allSite=='H'),'facecolor','#D95319')
title('H slope')
xlim([-12 12])
nexttile
histogram(allSlp(allSite=='E'),'facecolor','#7E2F8E')
title('E slope')
xlim([-12 12])
nexttile
histogram(allSlp(allSite=='N'),'facecolor','#77AC30')
title('N slope')
xlim([-12 12])


figure
tiledlayout(1,4)
nexttile
histogram(allMeans(allSite=='W'),'facecolor','#0072BD')
title('W distance')
xlim([0 4000])
nexttile
histogram(allMeans(allSite=='H'),'facecolor','#D95319')
title('H distance')
xlim([0 4000])
nexttile
histogram(allMeans(allSite=='E'),'facecolor','#7E2F8E')
title('E distance')
xlim([0 4000])
nexttile
histogram(allMeans(allSite=='N'),'facecolor','#77AC30')
title('N distance')
xlim([0 4000])

df = table(allMeans,allSlp,allSite);
writetable(df,'F:\Zc_Analysis\dist_btwn_pairs\dist_btwn_pairs_allsites.csv');

%% simulate some fake data for plotting visualization purposes
allSite = allSite(~isnan(allSlp));
allSlp = rmmissing(allSlp);
allMeans = rmmissing(allMeans);

simMeans = allMeans-500;
simMeans(simMeans<0) = 0;

randSecs = normrnd(120,30,218,1);

figure
tiledlayout(1,2)
nexttile
histogram(allMeans)
hold on
histogram(simMeans)
xlabel('Distance (m)')
legend('Track Distance','Lane Distance')
nexttile
histogram(randSecs)
xlabel('Time Lag (s)')

figure
tiledlayout(1,2)
nexttile
boxplot([allMeans, simMeans])
xlabel('Track Dist    Lane Dist')
nexttile
histogram(randSecs)
xlabel('Time Lag (s)')

%% by site

deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75',...
    'SOCAL_E_63','SOCAL_N_68',...
    'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};

siteDist = [];
siteSlopes = [];

for j = 1:length(deps)

    a = load(['F:\Tracking\Erics_detector\',deps{j},'\deployment_stats\',deps{j},'_distBtwnGrps'])
    siteDist = [siteDist;a.grpDistVals'];
    siteSlopes = [siteSlopes;a.grpDistSlopes'];

end

% for each, run a linear model and calculate the slope, add to the means
% string
allMeans = [];
allMax = [];
allMin = [];
allSlp = [];

for i = 1:length(siteDist)
    thisEnc = siteDist{i};
    thisSlp = siteSlopes{i};

    mn = [];
    mx = [];
    miin = [];
    slp = [];

    for j = 1:length(thisEnc)
        if ~isempty(thisEnc{j})
            mn = vertcat(mn,nanmean(abs(thisEnc{j}(:,1))));
            mx = vertcat(mx,nanmax(abs(thisEnc{j}(:,1))));
            miin = vertcat(miin,nanmin(abs(thisEnc{j}(:,1))));
            slp = vertcat(slp,thisSlp{j});
        end
    end

    allMeans = vertcat(allMeans, mn);
    allMax = vertcat(allMax,mx);
    allMin = vertcat(allMin,miin);
    allSlp = vertcat(allSlp,slp);
end


% figure
% errorbar(1:height(allMeans),allMeans,allMeans-allMin,allMax-allMeans,0,0,'o','color','black')
% ylabel('Distance Between Pairs (m)')
% xlim([0 height(allMeans)])
% ylim([0 7000])
% title('Site N')

allSlp = rmmissing(allSlp);
allMeans = rmmissing(allMeans);

figure
histogram(allSlp)
xlim([-13 13])
title('slopes, all deployments')

figure
histogram(allMeans,100)
title('mean pairs distance, all deployments')

%% bin by time intervals

deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75',...
    'SOCAL_E_63','SOCAL_N_68',...
    'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};

siteDist = [];
siteSlopes = [];

for j = 1:length(deps)

    a = load(['F:\Tracking\Erics_detector\',deps{j},'\deployment_stats\',deps{j},'_distBtwnGrps']);
    siteDist = [siteDist;a.grpDistVals'];
    siteSlopes = [siteSlopes;a.grpDistSlopes'];

end

% for each, run a linear model and calculate the slope, add to the means
% string
allMeans = [];
allMax = [];
allMin = [];
allTms = [];

for i = 1:length(siteDist)
    thisEnc = siteDist{i};
    mn = [];
    mx = [];
    miin = [];
    slp = [];
    tms = [];

    for j = 1:length(thisEnc)
        if ~isempty(thisEnc{j})

            % do some binning by time
            bin_start = thisEnc{j}(1,2);
            bin_end = thisEnc{j}(end,2);
            bin_width = 60/(60*60*24);
            bin_edges = bin_start:bin_width:bin_end;
            [~,bin_idx] = histc(thisEnc{j}(:,2),bin_edges);

            bin_means = zeros(1,length(bin_edges)-1);
            
            for i = 1:length(bin_means)

                bin_data = thisEnc{j}(bin_idx==i,:);
                mn = vertcat(mn,nanmean(abs(bin_data(:,1))));
                mn(mn==0)=nan;
                mx = vertcat(mx,nanmax(abs(bin_data(:,1))));
                miin = vertcat(miin,nanmin(abs(bin_data(:,1))));

                % calculate the duration from this info
                bin_data(isnan(bin_data(:,1)),2) = nan;
                tdiffs = diff(datetime(bin_data(:,2),'convertfrom','datenum'));
                tms = vertcat(tms,nansum(tdiffs));

            end
        end
    end

    allMeans = vertcat(allMeans, mn);
    allMax = vertcat(allMax,mx);
    allMin = vertcat(allMin,miin);
    allTms = vertcat(allTms,tms);
end


% figure
% errorbar(1:height(allMeans),allMeans,allMeans-allMin,allMax-allMeans,0,0,'o','color','black')
% ylabel('Distance Between Pairs (m)')
% xlim([0 height(allMeans)])
% ylim([0 7000])
% title('Site N')

figure
histogram(allSlp)
xlim([-13 13])
title('slopes, all deployments')

figure
histogram(allMeans,100)
title('mean pairs distance, all deployments')

% grab only values which have a full minute of data
figure
histogram(allTms)

idx = allTms>=duration(0,0,0);
longMeans = allMeans(idx);

breaks = 0:50:3500;
figure
histogram(longMeans,breaks)
title('mean pairs distance (1 minute bins), all deployments')
xlabel('mean pairs distance (m)')

longmeansall = longMeans;


%% plotting only nearest neighbor distances

deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75',...
    'SOCAL_E_63','SOCAL_N_68',...
    'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};

siteDist = [];
siteSlopes = [];

for j = 1:length(deps)

    a = load(['F:\Tracking\Erics_detector\',deps{j},'\deployment_stats\',deps{j},'_distBtwnGrps']);
    siteDist = [siteDist;a.grpDistVals'];
    siteSlopes = [siteSlopes;a.grpDistSlopes'];

end

% for each, run a linear model and calculate the slope, add to the means
% string
allMeans = [];
allMax = [];
allMin = [];
allTms = [];

for i = 1:length(siteDist)
    thisEnc = siteDist{i};
    mn = [];
    mx = [];
    miin = [];
    slp = [];
    tms = [];

    for j = 1:length(thisEnc)
        if ~isempty(thisEnc{j})

            % do some binning by time
            bin_start = thisEnc{j}(1,2);
            bin_end = thisEnc{j}(end,2);
            bin_width = 60/(60*60*24);
            bin_edges = bin_start:bin_width:bin_end;
            [~,bin_idx] = histc(thisEnc{j}(:,2),bin_edges);

            bin_means = zeros(1,length(bin_edges)-1);
            
            for i = 1:length(bin_means)

                bin_data = thisEnc{j}(bin_idx==i,:);
                mn(i,j) = nanmean(abs(bin_data(:,1)));
                mx(i,j) = nanmax(abs(bin_data(:,1)));
                miin(i,j) = nanmin(abs(bin_data(:,1)));

                % calculate the duration from this info
                bin_data(isnan(bin_data(:,1)),2) = nan;
                tdiffs = diff(datetime(bin_data(:,2),'convertfrom','datenum'));
                tms(i,j) = seconds(nansum(tdiffs));

            end
        end
    end

    mn(mn(:,:)==0)=nan;
    [mn,idx] = nanmin(mn,[],2);
    tmssave = [];
    for id = 1:length(idx)
        tmssave(id) = tms(id,idx(id));
    end
    tms = tmssave';

    allMeans = vertcat(allMeans, mn);
    % allMax = vertcat(allMax,mx);
    % allMin = vertcat(allMin,miin);
    allTms = vertcat(allTms,tms);
end


% figure
% errorbar(1:height(allMeans),allMeans,allMeans-allMin,allMax-allMeans,0,0,'o','color','black')
% ylabel('Distance Between Pairs (m)')
% xlim([0 height(allMeans)])
% ylim([0 7000])
% title('Site N')

figure
histogram(allSlp)
xlim([-13 13])
title('slopes, all deployments')

figure
histogram(allMeans,100)
title('mean pairs distance, all deployments')

% grab only values which have a full minute of data
figure
histogram(allTms)

idx = allTms>=duration(0,0,0);
longMeans = allMeans(idx);

breaks = 0:50:3500;
figure
histogram(longMeans,breaks)
hold on
histogram(longmeansall,breaks)
title('mean pairs distance (1 minute bins), all deployments')
xlabel('mean pairs distance (m)')
