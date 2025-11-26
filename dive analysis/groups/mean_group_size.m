% mean_group_size
% calculate the mean group size!

deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75',...
        'SOCAL_E_63','SOCAL_N_68',...
        'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};

numWhales = [];

for j = 1:length(deps)

    myFile = load(['F:\Tracking\Erics_detector\',deps{j},'\group_size\cleanedTracksTable.mat']);
    numWhales = [numWhales;myFile.cleanedTracksTable.numWhales];

end

mean(numWhales)
std(numWhales)
median(numWhales)