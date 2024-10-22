%% calcRecordingEffort.m
% LMB 10/20/23 v2023a
% this plot will make a figure showing recording effort at the sites
% calculate number of seconds of data
spd = 60*60*24;

% site H
% H 72
XH{1} = load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HE\dep\SOCAL_H_72_HE_xwavLookupTable.mat');
XH{2} = load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_C4_xwavLookupTable.mat');
XH{3} = load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_C4_xwavLookupTable.mat');
% single channel start/end
eSt = XH{1}.xwavTable.startTime(2);
eEd = XH{1}.xwavTable.startTime(end);
% 4 channels
sSt = XH{2}.xwavTable.startTime(2);
sEd = XH{2}.xwavTable.startTime(end);
wSt = XH{3}.xwavTable.startTime(2);
wEd = XH{3}.xwavTable.startTime(end);
% calculate duration
st = datetime(max([eSt sSt wSt]),'convertfrom','datenum');
ed = datetime(min([eEd sEd wEd]),'convertfrom','datenum');
h72dur = ed-st;

% H 73
XH{1} = load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HE\SOCAL_H_73_HE_xwavLookupTable.mat');
XH{2} = load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HS\dep\SOCAL_H_73_HS_C4_xwavLookupTable.mat');
XH{3} = load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HW\dep\SOCAL_H_73_HW_C4_xwavLookupTable.mat');
% single channel start/end
eSt = XH{1}.xwavTable.startTime(2);
eEd = XH{1}.xwavTable.startTime(end);
% 4 channels
sSt = XH{2}.xwavTable.startTime(3);
sEd = XH{2}.xwavTable.startTime(end);
wSt = XH{3}.xwavTable.startTime(2);
wEd = XH{3}.xwavTable.startTime(end);
% calculate duration
st = datetime(max([eSt sSt wSt]),'convertfrom','datenum');
ed = datetime(min([eEd sEd wEd]),'convertfrom','datenum');
h73dur = ed-st;

% H 74
XH{1} = load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HE\SOCAL_H_74_HE_xwavLookupTable.mat');
XH{2} = load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HS\rec\SOCAL_H_74_HS_C4_xwavLookupTable.mat');
XH{3} = load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HW\rec\SOCAL_H_74_HW_C4_xwavLookupTable.mat');
% single channel start/end
eSt = XH{1}.xwavTable.startTime(1);
eEd = XH{1}.xwavTable.startTime(end);
% 4 channels
sSt = XH{2}.xwavTable.startTime(1);
sEd = XH{2}.xwavTable.startTime(end);
wSt = XH{3}.xwavTable.startTime(2);
wEd = XH{3}.xwavTable.startTime(end);
% calculate duration
st = datetime(max([eSt sSt wSt]),'convertfrom','datenum');
ed = datetime(min([eEd sEd wEd]),'convertfrom','datenum');
h74dur = ed-st;

siteHeffort = sum([h72dur h73dur h74dur]);

% site W
% W 01
XH{1} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WE\dep\SOCAL_W_01_WE_C4_xwavLookupTable.mat');
XH{2} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WS\dep\SOCAL_W_01_WS_C4_xwavLookupTable.mat');
XH{3} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WW\SOCAL_W_01_WW_xwavLookupTable.mat');
% single channel start/end
eSt = XH{1}.xwavTable.startTime(2);
eEd = XH{1}.xwavTable.startTime(end);
% 4 channels
sSt = XH{2}.xwavTable.startTime(2);
sEd = XH{2}.xwavTable.startTime(end);
wSt = XH{3}.xwavTable.startTime(2);
wEd = XH{3}.xwavTable.startTime(end);
% calculate duration
st = datetime(max([eSt sSt wSt]),'convertfrom','datenum');
ed = datetime(min([eEd sEd wEd]),'convertfrom','datenum');
w01dur = ed-st;

% W 02
XH{1} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WE\dep\SOCAL_W_02_WE_C4_xwavLookupTable.mat');
XH{2} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WS\dep\SOCAL_W_02_WS_C4_xwavLookupTable.mat');
XH{3} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WW\SOCAL_W_02_WW_xwavLookupTable.mat');
% single channel start/end
eSt = XH{1}.xwavTable.startTime(2);
eEd = XH{1}.xwavTable.startTime(end);
% 4 channels
sSt = XH{2}.xwavTable.startTime(1);
sEd = XH{2}.xwavTable.startTime(end);
wSt = XH{3}.xwavTable.startTime(2);
wEd = XH{3}.xwavTable.startTime(end);
% calculate duration
st = datetime(max([eSt sSt wSt]),'convertfrom','datenum');
ed = datetime(min([eEd sEd wEd]),'convertfrom','datenum');
w02dur = ed-st;

% W 03
XH{1} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WE\dep\SOCAL_W_03_WE_C4_xwavLookupTable.mat');
XH{2} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WS\dep\SOCAL_W_03_WS_C4_xwavLookupTable.mat');
XH{3} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WW\dep\SOCAL_W_03_WW_xwavLookupTable.mat');
% single channel start/end
eSt = XH{1}.xwavTable.startTime(2);
eEd = XH{1}.xwavTable.startTime(end);
% 4 channels
sSt = XH{2}.xwavTable.startTime(1);
sEd = XH{2}.xwavTable.startTime(end);
wSt = XH{3}.xwavTable.startTime(2);
wEd = XH{3}.xwavTable.startTime(end);
% calculate duration
st = datetime(max([eSt sSt wSt]),'convertfrom','datenum');
ed = datetime(min([eEd sEd wEd]),'convertfrom','datenum');
w03dur = ed-st;

% W 04
XH{1} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WE\dep\SOCAL_W_04_WE_C4_xwavLookupTable.mat');
XH{2} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WS\dep\SOCAL_W_04_WS_C4_xwavLookupTable.mat');
XH{3} = load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WW\dep\SOCAL_W_04_WW_xwavLookupTable.mat');
% single channel start/end
eSt = XH{1}.xwavTable.startTime(2);
eEd = XH{1}.xwavTable.startTime(end);
% 4 channels
sSt = XH{2}.xwavTable.startTime(1);
sEd = XH{2}.xwavTable.startTime(end);
wSt = XH{3}.xwavTable.startTime(2);
wEd = XH{3}.xwavTable.startTime(end);
% calculate duration
st = datetime(max([eSt sSt wSt]),'convertfrom','datenum');
ed = datetime(min([eEd sEd wEd]),'convertfrom','datenum');
ed = datetime('22-Oct-0022 21:00:00')
w04dur = ed-st;

siteWeffort = sum([w01dur w02dur w03dur w04dur]);

% site E
st = datetime('15-Mar-2018 06:00:00');
ed = datetime('05-Jul-2018 03:26:31');

Edur = ed-st;

% site N
st = datetime('27-May-2020 19:30:00');
ed = datetime('15-Oct-2020 19:37:30');
Ndur = ed-st;
