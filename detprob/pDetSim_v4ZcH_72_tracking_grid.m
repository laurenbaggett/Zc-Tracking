% Montecarlo Simulation - for probability of click detection.
% Kait Frasier  7/23/2013
% JAH 9/2017 to make grid search for best fit to percent RL plot
% v2 click only
% v3 add bin remove global variables 6-2022
% v4 table for output 9-2022
% Zc version for SOCAL Cuviers, remove reference to gend
tic
clearvars % better than all
close all %clear all the figures
site = 'H'; % sites = {'A2','CCE1','E','G2','H','M','N','R','S','SN','U'};
whichparm = 'GRID'; % optiopns GRID SL Alt

if strcmp(whichparm,'GRID')
    fignum = 0; % if fignum = 0 make no figures
else
    fignum = 1;
end
cell400 = {'A2','G2'};
if ismember(site,cell400)
    yes400 = 'y';
else
    yes400 = 'n';
end
%
saveDir = 'F:\Zc_Analysis\monteCarlo\JohnKaitTrackingMonteCarlo';
if isfolder(saveDir)
    ranlet = char(randi(+'AZ'));
    saveDir = [saveDir,ranlet];
    disp(['Make new folder: ',saveDir])
    if isfolder(saveDir) % 2nd layer of checking
        ranlet = char(randi(+'AZ'));
        saveDir = [saveDir,ranlet];
        disp(['Make new folder: ',saveDir])
    end
end
mkdir(saveDir);
spVec = {'Zc'}; itSp = 1; species = spVec{itSp};
fnParms = fullfile(saveDir,sprintf('Parms_%s.txt', species)); % name of file to save results

%Parameters
n = 500; % the number of model runs in the probability distribution
N = 100000; %100000 simulate this many points per model run usually 100000
thresh = 112; % pp detection
% maxRange in meters
maxRange = 5000;% in meters
botbin = 125;
botbinb = 125;
if strcmp(yes400,'y')
    topbin = 135; %limits used for error assessment
    topbinb = 135; %limits for bin error assessment
else
    topbin = 160; %limits used for error assessment
    topbinb = 160; %limits for bin error assessment
end
RLbins = thresh:1:171; % bins used for plotting

% Parameters that can have multiple values have %***

% Dive altitude above seafloor. Allows for two different depths.
if strcmp(whichparm,'Alt') || strcmp(whichparm,'GRID')
    diveAltitudeMean1 = (275:25:325)'; %***
    div2 = 100*ones(1,length(diveAltitudeMean1));
    diveAltitudeMean1 = [diveAltitudeMean1,div2'];
    ld1 = length(diveAltitudeMean1);
    diveAltitudeMean2 = (0:1:ld1-1)'; %***
    div2 = 10*ones(1,length(diveAltitudeMean2));
    diveAltitudeMean2 = [diveAltitudeMean2,div2'];
else
    diveAltitudeMean1 = [375,50]; %***
    diveAltitudeMean2 = [2,10]; %***
end
diveAltitudeStd1 = [10,30];
diveAltitudeStd2 = [10,30];
sizeDiveAlt = size(diveAltitudeMean1,1);
diveType1Percent = [1.0, 0];% What fraction of the dives should go to altitude 1?
% Assumes the rest all go to dive altitude 2.
minAltitude = 10; % minimum dive altitude in meters (aka how close to the bottom can they get?)
maxDiveDepthMean = [1500,10]; % maximum dive depth in meters (model doesn't let them dive deeper than this)
maxDiveDepthStd = [10,10]; % maximum dive depth in meters (model doesn't let them dive deeper than this)

% Source Level in dBpp
if strcmp(whichparm,'SL') || strcmp(whichparm,'GRID')
    SLmean = (221:1:223)';  %****
    sl2 = 6*ones(1,length(SLmean)); % change to 6 is +-3
    SLmean = [SLmean,sl2'];
else
    SLmean = [221,5];  %****
end
SLstd = [2,3];
sizeSL = size(SLmean,1);

% Angle of incline during dive descent phase
if ~strcmp(whichparm,'dAng')
    descAngleMean = [60,4]; %***
else
    descAngleMean = (60)'; %*** (40:2:42)
    des2 = 4*ones(1,length(descAngleMean));
    descAngleMean = [descAngleMean,des2'];
end
sizeDescAngle = size(descAngleMean,1);
descAngleStd = [7,1];

% Depth of clicking start
clickStartMean = [200,20];
clickStartStd = [65,10];

% % Directivity
if strcmp(whichparm,'Direct') || strcmp(whichparm,'GRID')
    directivityIdx = (23:1:25)';
    %     directivityIdx = (21)';
    dir2 = 2*ones(1,length(directivityIdx));
    directivityIdx = [directivityIdx,dir2'];
else
    directivityIdx = [21,2]; %***
end
sizeDirectivityIdx = size(directivityIdx,1);
% Beam for for Click 90 and 180 deg
minAmpSm = [35,5]; %TL side
% minAmpBm = [25,5];
minAmpBm = [25,5]; % TL back

% Beam for Group

if strcmp(whichparm,'minBeam') || strcmp(whichparm,'GRID')
    %     minBeamAmp  = (25:5:35)'; %***
    minBeamAmp  = (33)'; %***
    mBA2 = 10*ones(1,length(minBeamAmp));
    minBeamAmp = [minBeamAmp,mBA2'];
else
    minBeamAmp = [33,3];  %***
end
sizeminBeamAmp = size(minBeamAmp,1);
minBeamAmps = [2,3];

if ~strcmp(whichparm,'bAng')
    botAngle = [0,50]; %***
else
    botAngle = (0:1:5)'; %***
    bot2 = 5*ones(1,length(botAngle));
    botAngle = [botAngle,bot2'];
end
sizeBotAngle  = size(botAngle,1);
descentPm = [.1 , .1];

% Parameters Unique to the Bin Method
rotHorizm = [180,20];
srotHoriz = size(rotHorizm);
rotHorizs = [10,10];

if strcmp(whichparm,'rVForg') || strcmp(whichparm,'GRID')
    rotVertForage = (50:5:70)';
    %     rotVertForage = (55)';
    rot2 = 5*ones(1,length(rotVertForage));
    rotVertForage= [rotVertForage,rot2'];
else
    rotVertForage = [55,5]; %*** Parms6
end
sizerotVertForage = size(rotVertForage,1);
rotVertForages = [5,5];
rotVertDivem = [30,20];
srotVertDive = size(rotVertDivem);
rotVertDives = [5,10];

% File paths for loading and storing
% TLprofile_directory = 'C:\Users\Alba\Documents\Alba_PhD_Output\SpermWhale_detection_outputs\TransmissionLoss';
%scuviers_Jan\\40kHz\\Sit_40kH_3DTL.mat
%G:\Shared drives\SOCAL BW-Density Estimation\data\probDet\TransmissionLoss
TLfile1 = 'F:\Tracking\prop\SOCAL_H_72\SOCAL_H_72_HS_40kH_3DTL.mat';
TLfile2 =  'F:\Tracking\prop\SOCAL_H_72\SOCAL_H_72_HW_40kH_3DTL.mat';
disp(['TLFile: ',TLfile1,' ', TLfile2])
load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_4ch_offset_m.mat');
grid = 100; % 100m x 100m grid squares for output

% Check if output directory exits
if ~exist(saveDir,'dir')
    mkdir(saveDir)
end
% Initialize Table file with grid search results
% counts number of cases
nsim =  sizeDiveAlt * sizeSL * sizeDescAngle * sizeDirectivityIdx * ...
    sizeBotAngle * sizerotVertForage * sizeminBeamAmp;
% Table with results
T = pDetSimTab(nsim,n,N,thresh,maxRange,clickStartMean,clickStartStd,minAmpSm,minAmpBm,descentPm);
%
dif = zeros(nsim,1);
difb = zeros(nsim,1);
% counts for location of dif by variable
dif1 = []; dif2 = []; dif3 = []; dif4 = []; dif5 = []; dif6 = []; dif7 = [];
pD = zeros(nsim,1);
pDs = zeros(nsim,1);
pDb = zeros(nsim,1);
pDsb = zeros(nsim,1);
miss = zeros(nsim,1);
missb = zeros(nsim,1);

% Load Transmission loss model for this site
polarFile1 = fullfile(TLfile1);
sprintf('Loading TL file %s\n', polarFile1);
a1 = load(polarFile1)
polarFile2 = fullfile(TLfile2);
sprintf('Loading TL file %s\n', polarFile2);
a2 = load(polarFile2)

% Convert cell arrays to 3D matrix - speed up computation
% rd_all and sortedTLVec cell array
celmaxColA = max(cell2mat(cellfun(@(x)size(x,2),a1.rd_all,'uni',false)));
celmaxRowA = max(cell2mat(cellfun(@(x)size(x,1),a1.rd_all,'uni',false)));
celmaxColB = max(cell2mat(cellfun(@(x)size(x,2),a1.sortedTLVec,'uni',false)));
celmaxRowB = max(cell2mat(cellfun(@(x)size(x,1),a1.sortedTLVec,'uni',false)));
for ic = 1: length(a1.rd_all)
    celValA = a1.rd_all{ic};
    celValB = a1.sortedTLVec{ic};
    a1.rd_all{ic} = [a1.rd_all{ic};nan(celmaxRowA-length(celValA),celmaxColA)];
    a1.sortedTLVec{ic} = [a1.sortedTLVec{ic};nan(celmaxRowB-size(celValB,1),celmaxColB)];
end
a1.rd_all= cat(length(a1.rd_all),a1.rd_all{:});
a1.sortedTLVec= cat(length(a1.sortedTLVec),a1.sortedTLVec{:});

rr_int1 = round(a1.rr(2)-a1.rr(1)); % figure out what the range step size is
nrr_new1 = rr_int1*a1.nrr;
% % rr_new = 0:rr_int:nrr_new; % Real values of the range vector? (in m)
% pDetTotal1 = nan(n,1);
% pDetTotalb1 = nan(n,1);
binVec = 0:maxRange/50:maxRange;
% binnedCounts = [];
% binnedPercDet = nan(n,length(binVec)-1);

for ic = 1: length(a2.rd_all)
    celValA = a2.rd_all{ic};
    celValB = a2.sortedTLVec{ic};
    a2.rd_all{ic} = [a2.rd_all{ic};nan(celmaxRowA-length(celValA),celmaxColA)];
    a2.sortedTLVec{ic} = [a2.sortedTLVec{ic};nan(celmaxRowB-size(celValB,1),celmaxColB)];
end
a2.rd_all= cat(length(a2.rd_all),a2.rd_all{:});
a2.sortedTLVec= cat(length(a2.sortedTLVec),a2.sortedTLVec{:});

rr_int2 = round(a2.rr(2)-a2.rr(1)); % figure out what the range step size is
nrr_new2 = rr_int2*a2.nrr;

% initialize for saving
allsim = [];
alldet = [];
allprob = [];
% % center of bins and nper number of percent for measurements
% icen = find(center >= botbin & center < topbin); % not really center now is edge!
% lnper = log10(nper(icen)); %used for goodness of fit
% lnbper = log10(nbper(icen)); %used for goodness of fit
% %nper = nper(icen);
% inot = find(~isinf(lnper));
% ibnot = find(~isinf(lnbper));
isim = 0; %counter for num of simulations per site
itot = sizeDiveAlt * sizeSL * sizeDescAngle * sizeDirectivityIdx * ...
    sizeBotAngle * sizerotVertForage * sizeminBeamAmp;
for itParms1 = 1: sizeDiveAlt
    fprintf('Loop DiveAlt %d of %d\n', itParms1, sizeDiveAlt)
    diveAltitude1_itr = diveAltitudeMean1(itParms1,:);
    diveAltitude2_itr = diveAltitudeMean2(itParms1,:);
    for itParms2 = 1: sizeSL
        fprintf('  Loop SL %d of %d\n', itParms2, sizeSL)
        SL_itr = SLmean(itParms2,:);
        for itParms3 = 1: sizeDescAngle
            fprintf('    Loop DescAngle %d of %d\n', itParms3, sizeDescAngle)
            descAngle_itr = descAngleMean(itParms3,:);
            for itParms4 = 1: sizeDirectivityIdx
                fprintf('      Loop Directivity %d of %d\n', itParms4, sizeDirectivityIdx)
                directivityIdx_itr = directivityIdx(itParms4,:);
                for itParms5 = 1: sizeBotAngle
                    fprintf('        Loop BotAngle %d of %d\n', itParms5, sizeBotAngle)
                    botAngle_itr = botAngle(itParms5,:);
                    for itParms6 = 1: sizerotVertForage
                        fprintf('        Loop rotVertForag %d of %d\n', itParms6, sizerotVertForage)
                        rotVertForagem = rotVertForage(itParms6,:);
                        for itParms7 = 1 : sizeminBeamAmp
                            fprintf('        Loop minBeamAmp %d of %d\n', itParms7, sizeminBeamAmp)
                            minBeamAmpm = minBeamAmp(itParms7,:);

                            % variables to pick from a distribution for CV estimation
                            diveAlt1_itr_mean = diveAltitude1_itr(1) + diveAltitude1_itr(2)*rand(n,1); % mean dive altitude is somewhere between 175 and 225m
                            diveAlt1_itr_std = diveAltitudeStd1(1) + diveAltitudeStd1(2)*rand(n,1);% dive depth std. dev. is 10 to 20m
                            diveAlt2_itr_mean = diveAltitude2_itr(1) + diveAltitude2_itr(2)*rand(n,1); % mean dive altitude is somewhere between 175 and 225m
                            diveAlt2_itr_std = diveAltitudeStd2(1) + diveAltitudeStd2(2)*rand(n,1);% dive depth std. dev. is 10 to 20m
                            diveType1Percent_itr = diveType1Percent(1)+ diveType1Percent(2)*rand(n,1);
                            diveType2Percent_itr = 1-diveType1Percent_itr;
                            maxDiveDepth_mean = maxDiveDepthMean(1) + maxDiveDepthMean(2)*rand(n,1);
                            maxDiveDepth_std = maxDiveDepthStd(1) + maxDiveDepthStd(2)*rand(n,1);

                            SL_mean = SL_itr(1) + SL_itr(2)*rand(n,1); % mean source level is between 210 and 220 dB pp - gervais
                            SL_std = SLstd(1) + SLstd(2)*rand(n,1); % add 2 to 5 db std dev to source level.
                            descAngle_mean = descAngle_itr(1) + descAngle_itr(2)*rand(n,1); % mean descent angle in deg, from tyack 2006 for blainvilles;
                            descAngle_std = descAngleStd(1) + descAngleStd(2)*rand(n,1); % std deviation of descent angle in deg, from tyack 2006 for blainvilles;
                            clickStart_mean = clickStartMean(1) + clickStartMean(2)*rand(n,1); % depth in meters at which clicking starts, from tyack 2006 for blainvilles;
                            clickStart_std =  clickStartStd(1) + clickStartStd(2)*rand(n,1); % depth in meters at which clicking starts, from tyack 2006 for Cuvier's - blainvilles was unbelievably large;
                            directivity = directivityIdx_itr(1) + directivityIdx_itr(2)*rand(n,1); % directivity is between 25 and 27 dB PP (Zimmer et al 2005: Echolocation clicks of free-ranging Cuvier's beaked whales)
                            minAmpSide_mean = minAmpSm(1) + minAmpSm(2)*rand(n,1); % minimum off-axis dBs down from peak
                            minAmpBack_mean = minAmpBm(1) + minAmpBm(2)*rand(n,1); % minimum off-axis dBs down from peak
                            botAngle_std = botAngle_itr(1) + botAngle_itr(2)*rand(n,1);  % std of vertical angle shift allowed if foraging at depth
                            descentPerc = descentPm(1) + descentPm(2)*rand(n,1);
                            % Group Only
                            minBeamAmp_mean = minBeamAmpm(1) + minBeamAmpm(2)*rand(n,1); % minimum off-axis dBs down from peak
                            minBeamAmp_std = minBeamAmps(1) + minBeamAmps(2)*rand(n,1);
                            rotHorizDeg = rotHorizm(1) + rotHorizm(2)*rand(n,1);
                            rotHorizDeg_std = rotHorizs(1) + rotHorizs(2)*rand(n,1);
                            rotVertDegForage = rotVertForagem(1) + rotVertForagem(2)*rand(n,1);
                            rotVertDegForageStd = rotVertForages(1) + rotVertForages(2)*rand(n,1);
                            rotVertDegDive = rotVertDivem(1) + rotVertDivem(2)*rand(n,1);
                            rotVertDegDiveStd = rotVertDives(1) + rotVertDives(2)*rand(n,1);
                            %
                            isim = isim + 1;
                            fprintf(' Loop isim %d of itot %d\n', isim, itot)
                            %Write to Parms Table
                            T.site(isim) = site;
                            T.dAltitude1m(isim) = diveAltitude1_itr(1);
                            T.dAltitude1ms(isim) = diveAltitude1_itr(2);
                            T.dAltitude1s(isim) = diveAltitudeStd1(1);
                            T.dAltitude1ss(isim) = diveAltitudeStd1(2);
                            T.dAltitude2m(isim) =  diveAltitude2_itr(1);
                            T.dAltitude2ms(isim) = diveAltitude2_itr(2);
                            T.dAltitude2s(isim) = diveAltitudeStd2(1);
                            T.dAltitude2ss(isim) = diveAltitudeStd2(2);
                            T.SLm(isim) = SL_itr(1);
                            T.SLms(isim) = SL_itr(2);
                            T.SLs(isim) = SLstd(1);
                            T.SLss(isim) = SLstd(2);
                            T.dAnglem(isim) = descAngle_itr(1);
                            T.dAnglems(isim) = descAngle_itr(1);
                            T.dAngles(isim) = descAngleStd(1);
                            T.dAngless(isim) = descAngleStd(2);
                            T.directm(isim) = directivityIdx_itr(1);
                            T.directms(isim) = directivityIdx_itr(2);
                            T.botAnglem(isim) = botAngle_itr(1);
                            T.botAnglems(isim) = botAngle_itr(2);
                            T.rVForm(isim) = rotVertForagem(1);
                            T.rVForms(isim) = rotVertForagem(2);
                            T.rVFors(isim) = rotVertForages(1);
                            T.rVForss(isim) = rotVertForages(2);
                            T.mBeamAm(isim) = minBeamAmpm(1);
                            T.mBeamAms(isim) = minBeamAmpm(2);
                            T.mBeamAs(isim) = minBeamAmps(1);
                            T.mBeamAss(isim) = minBeamAmps(2);

                            % Function for click
                            [sumsim,sumdet,fprob,xline,yline] = ...
                                ClickSimPm_tracking(a1,a2,...
                                diveAlt1_itr_mean, diveAlt1_itr_std, diveAlt2_itr_mean, diveAlt2_itr_std, ...
                                diveType1Percent_itr, maxDiveDepth_mean, maxDiveDepth_std, ...
                                SL_mean,SL_std,rr_int1,rr_int2,minAltitude, ...
                                descAngle_mean,descAngle_std,clickStart_mean,clickStart_std, ...
                                directivity,minAmpSide_mean, ...
                                minAmpBack_mean,botAngle_std,descentPerc, ...
                                binVec,n,N,maxRange,thresh,RLbins,offset, grid);
                            % function for click end

                            % save the output for future iterations
                            allsim = cat(3,sumsim,allsim);
                            alldet = cat(3,sumdet,alldet);
                            allprob = cat(3,fprob,allprob);
                        end
                    end
                end
            end
        end
    end
end

save('F:\Zc_Analysis\tracking_figures\track_density\SOCAL_H_72_detectionProbability.mat','allsim','alldet','allprob','xline','yline')

% make final probability of detection file and figure!
allsim2 = sum(allsim,3);
alldet2 = sum(alldet,3);
prb = alldet2./allsim2;
prb_plot = prb;
prb_plot(prb_plot==0) = NaN; % replace zeros with NaNs for plotting

% load bathymetry
load('F:\Tracking\bathymetry\socal2');
% load instruments
load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_harp4chPar');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
% convert lat lon to meters, from Eric
plotAx = [-4000, 4000, -4000, 4000];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

figure
h = imagesc(xline,yline,prb_plot,'AlphaData',0.8)
set(h,'AlphaData',~isnan(prb_plot))
c = cmocean('matter')
% c = flipud(cmocean('ice')); % flipud(cmocean('solar'));
% c = c(10:end,:);
colormap(c)
colorbar
hold on
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
caxis([0 1])
set(gca,'YDir','normal')
plot(h1(1,1),h1(1,2),'s','markeredgecolor','white','markerfacecolor',[0.6 0.6 0.6],'markersize',6);
plot(h2(1,1),h2(1,2),'s','markeredgecolor','white','markerfacecolor',[0.6 0.6 0.6],'markersize',6);
title('SOCAL H 72 Detection Probability')


% save('F:\Zc_Analysis\tracking_figures\track_density\SOCAL_W_01_detectionProbability.mat','allsim','alldet','allprob','xline','yline')