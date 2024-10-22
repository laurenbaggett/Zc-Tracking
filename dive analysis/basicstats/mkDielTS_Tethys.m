%% mkDielTS_Tethys
% LMB 1/4/24
% this script will plot acoustic presence diel plots for each site, the
% deployments that I used for tracking
% acoustic presence process, verified by me using the single channel data

% connect to tethys to query diel data
q=dbInit('Server','breach.ucsd.edu','Port',9779);

% lat lon of san diego for diel data
lat = 32 + 42/60 + 52.9/3600;
lon = 360 - (117 + 09/60 + 21.6/3600);

% acoustic data
% site N
load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_N_68\SOCAL_N_68_Zc_encounterTimes.mat');
pres = horzcat(bwEnc.startEnc,bwEnc.endEnc);
effStart = datetime('29-Apr-2020');
effEnd = datetime('15-Oct-2020');

% site E
% load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_E_63_ES\SOCAL_E_63_ES_encounterTimes.mat');
% pres = horzcat(bwEnc.startEnc,bwEnc.endEnc);
% effStart = datetime('15-Mar-2018');
% effEnd = datetime('11-Jul-2018');

% % site H
% bw1 = load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_H_72_HE\SOCAL_H_72_HE_encounterTimes.mat');
% bw2 = load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_H_73_HE\SOCAL_H_73_HE_encounterTimes.mat');
% bw3 = load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_H_74_HE\SOCAL_H_74_HE_encounterTimes.mat');
% bw4 = load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_H_75_HE\SOCAL_H_75_HE_encounterTimes.mat');
% presSt = vertcat(bw1.bwEnc.startEnc, bw2.bwEnc.startEnc, bw3.bwEnc.startEnc, bw4.bwEnc.startEnc);
% presEd = vertcat(bw1.bwEnc.endEnc, bw2.bwEnc.endEnc, bw3.bwEnc.endEnc, bw4.bwEnc.endEnc);
% pres = horzcat(presSt,presEd);
% effStart = datetime('05-Jun-2021');
% effEnd = datetime('17-Apr-2023');

% % site W
% bw1 = load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_W_01_WW\SOCAL_W_01_WW_encounterTimes.mat');
% bw2 = load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_W_02_WW\SOCAL_W_02_WW_encounterTimes.mat');
% bw3 = load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_W_03_WW\SOCAL_W_03_WW_encounterTimes.mat');
% bw4 = load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_W_04_WW\SOCAL_W_04_WW_encounterTimes.mat');
% bw5 = load('F:\GDrive_Backup\Lauren Baggett MS\AI_Classification\Time_Tables\Zc\SOCAL_W_05_WW\SOCAL_W_05_WW_encounterTimes.mat');
% presSt = vertcat(bw1.bwEnc.startEnc, bw2.bwEnc.startEnc, bw3.bwEnc.startEnc, bw4.bwEnc.startEnc, bw5.bwEnc.startEnc);
% presEd = vertcat(bw1.bwEnc.endEnc, bw2.bwEnc.endEnc, bw3.bwEnc.endEnc, bw4.bwEnc.endEnc, bw5.bwEnc.endEnc);
% pres = horzcat(presSt,presEd);
% effStart = datetime('29-Jul-2021');
% effEnd = datetime('25-Sep-2023');

% no effort times
% % site H
% noefforttimes = vertcat([datetime('18-Dec-2021'), datetime('21-Dec-2021')],...
%     [datetime('22-May-2022'), datetime('23-May-2022')],...
%     [datetime('15-Oct-2022'), datetime('17-Oct-2022')]);

% site W
% noefforttimes = vertcat([datetime('22-Jan-2022'), datetime('10-Mar-2022')],...
%     [datetime('14-Oct-2022'), datetime('17-Oct-2022')],...
%     [datetime('15-Apr-2023'), datetime('16-Apr-2023')]);

% diel data
night = dbDiel(q,lat, lon,  effStart, effEnd); %get sunrise sunset data

% plotting
h = figure(1);
% plotting
night = visPresence(night, 'Color', 'black', ...
        'LineStyle', 'none', 'Transparency', 0.1);

% noeffort = visPresence(sort(noefforttimes), ... %plot no effort
%         'Color',[0 0.4 0.8],...
%         'LineStyle', 'none','Transparency',.1,...
%         'DateRange', [effStart, effEnd]);

acoustic = visPresence(sort(pres),...
    'Color',[0 0.4470 0.7410],...
    'Label','slow_click',...
    'DateRange', [effStart, effEnd]); % 'DateRange', [fixStart, fixEnd]

set(gca, 'YDir', 'reverse');
title('Site N Zc Presence')
ylabel('Date')
xlabel('Hour [UTC]')
numTicks = 10;
L = get(gca,'YLim');
set(gca, 'YTick',linspace(L(1),L(2),numTicks))

