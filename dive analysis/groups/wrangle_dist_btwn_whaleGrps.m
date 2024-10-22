%% wrangle_dist_btwn_whaleGrps

% load in the data
% % site H
% a = load('F:\Tracking\Erics_detector\SOCAL_H_72\deployment_stats\SOCAL_H_72_distBtwnGrps.mat');
% b = load('F:\Tracking\Erics_detector\SOCAL_H_73\deployment_stats\SOCAL_H_73_distBtwnGrps.mat');
% c = load('F:\Tracking\Erics_detector\SOCAL_H_74\deployment_stats\SOCAL_H_74_distBtwnGrps.mat');
% d = load('F:\Tracking\Erics_detector\SOCAL_H_75\deployment_stats\SOCAL_H_75_distBtwnGrps.mat');
% mns= horzcat(a.grpDistMeans, b.grpDistMeans, c.grpDistMeans, d.grpDistMeans);
% lab = horzcat(a.labs,b.labs,c.labs,d.labs);

% % site E
% a = load('F:\Tracking\Erics_detector\SOCAL_E_63\deployment_stats\SOCAL_E_63_distBtwnGrps.mat');
% mns = a.grpDistMeans;
% lab = a.labs;
% site N
a = load('F:\Tracking\Erics_detector\SOCAL_N_68\Zc\deployment_stats\SOCAL_N_68_distBtwnGrps.mat');
mns = a.grpDistMeans;
lab = a.labs;
% % % site W
% a = load('F:\Tracking\Erics_detector\SOCAL_W_01\deployment_stats\SOCAL_W_01_distBtwnGrps.mat');
% b = load('F:\Tracking\Erics_detector\SOCAL_W_02\deployment_stats\SOCAL_W_02_distBtwnGrps.mat');
% c = load('F:\Tracking\Erics_detector\SOCAL_W_03\deployment_stats\SOCAL_W_03_distBtwnGrps.mat');
% d = load('F:\Tracking\Erics_detector\SOCAL_W_04\deployment_stats\SOCAL_W_04_distBtwnGrps.mat');
% mns = horzcat(a.grpDistMeans,b.grpDistMeans,c.grpDistMeans,d.grpDistMeans);
% lab = horzcat(a.labs,b.labs,c.labs,d.labs);

% remove gaps from blanks
mns(cellfun('isempty',mns)) = []; % remove any empty fields
lab(cellfun('isempty',lab)) = []; % remove any empty fields

% go into each deployment struct
mnsGrp = [];

for i = 1:length(mns)
    
    % remove blanks    
    thisenc = mns{i};
    thisenc(cellfun('isempty',thisenc)) = []; % remove any empty fields
    thislab = lab{i};
    thislab(cellfun('isempty',thislab)) = []; % remove any empty fields

    mnvec = [];
    whales = [];

    for np = 1:length(thisenc)
        mnvec = vertcat(mnvec,thisenc(np)); % grab the means
        pair = string(thislab{np}); % convert the cell to a string
        whales = vertcat(whales,str2num(extractBetween(pair,strlength(pair),strlength(pair)))); % grab the last value of the string
    end

    maxWhale = max(whales); % find the number of whales in this encounter
    grpSz = repelem(maxWhale,size(mnvec,1))'; % repeat the group size
    mnsGrp = vertcat(mnsGrp,horzcat(cell2mat(mnvec),grpSz)); % save means with grp size

end

save('F:\Tracking\Erics_detector\siteN_mnDistBtwnPairs.mat','mnsGrp')
% save the site, also the number of whales in the encounter
% make a boxplot of these means per site
% make a boxplot of these means per number of individuals in the encounter