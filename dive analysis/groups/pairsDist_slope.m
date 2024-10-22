%% laneDist_slope

% load in the value
% site W
a = load('F:\Tracking\Erics_detector\SOCAL_E_63\deployment_stats\SOCAL_E_63_distBtwnGrps.mat');
siteDist = a.grpDistVals';
siteSlopes = a.grpDistSlopes';
% a = load('F:\Tracking\Erics_detector\SOCAL_H_72\deployment_stats\SOCAL_H_72_distBtwnGrps.mat');
% b = load('F:\Tracking\Erics_detector\SOCAL_H_73\deployment_stats\SOCAL_H_73_distBtwnGrps.mat');
% c = load('F:\Tracking\Erics_detector\SOCAL_H_74\deployment_stats\SOCAL_H_74_distBtwnGrps.mat');
% d = load('F:\Tracking\Erics_detector\SOCAL_H_75\deployment_stats\SOCAL_H_75_distBtwnGrps.mat');
% siteDist = horzcat(a.grpDistVals,b.grpDistVals,c.grpDistVals,d.grpDistVals);
% siteSlopes= horzcat(a.grpDistSlopes,b.grpDistSlopes,c.grpDistSlopes,d.grpDistSlopes)';

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
            mn = vertcat(mn,mean(abs(thisEnc{j}(:,1))));
            mx = vertcat(mx,max(abs(thisEnc{j}(:,1))));
            miin = vertcat(miin,min(abs(thisEnc{j}(:,1))));
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

figure
plot(allSlp,'o')
xlim([1 length(allSlp)])
ylim([-10 10])
ylabel('Slope')
title('Site E')