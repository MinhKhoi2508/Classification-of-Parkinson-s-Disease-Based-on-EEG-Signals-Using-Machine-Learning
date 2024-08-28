clc
clear all
close all

cd 'C:\Users\DELL\Documents\MATLAB\Data and Code\Dataset\UNMDataset\UNMgoc\Cell-raw'
time_segment = 5;
% sub_ON = [801:1:811, 813:829]; %ID of ON session
% sub_OFF = [801:1:811, 813:829]; %ID of OFF session
% sub_CTL = [8010, 8060, 8070, 890:1:914]; %ID of CTL 

PDsx=[801,802,804:811,813:829]; 
CTLsx=[8070,8060,890:893,895:912,914]; 
ON_OFF_indicator=[
801	1 2;
802	2 1;
804	1 2;
805	1 2;
806	2 1;
807	2 1;
808	2 1;
809	1 2;
810	1 2;
811	1 2;
813	2 1;
814	1 2;
815	1 2;
816	2 1;
817	2 1;
818	1 2;
819	2 1;
820	2 1;
821	1 2;
822	1 2;
823	2 1;
824	2 1;
825	1 2;
826	1 2;
827	2 1;
828	2 1;
829	2 1;

];

name_labels = {'CTL', 'PD', 'PD'}; % 2 labels
name_labels = {'CTL', 'ON', 'OFF'}; % 3 labels
N = 1;

length_ON_OFF = length(PDsx);
% length_OFF = length(sub_OFF);
length_CTL = length(CTLsx);

%load CTL data
cd 'C:\Users\DELL\Documents\MATLAB\Data and Code\Dataset\UNMDataset\UNMgoc\Cell-raw'
load('Cell-raw\raw_data_downsample.mat');
count_CTL = 1;
count_ON = 1;
count_OFF = 1;

for class = 1:length_CTL
    data_tam = data_downsample{1,class};
    length_temp = length(data_tam);
%     fs = 250;
    fs = 500;
    time_temp = time_segment; % flexible segment time
    point_start = 1;
    point_len = fs * time_temp;
    point_end = point_start + point_len - 1;
    while point_end < length_temp
        my_field = strcat('CTL_',num2str(count_CTL));
        variable_CTL.(my_field) = data_tam(:,point_start:point_end);
        count_CTL = count_CTL + 1;
        point_start = point_end + 1;
        point_end = point_start + point_len - 1;
    end
    X = sprintf('Processing CTL file %d_%d', CTLsx(class),count_CTL);
    disp (X);
    my_field = strcat('CTL_',num2str(count_CTL));
    variable_CTL.(my_field) = data_tam(:,point_start:length_temp);
end


for class = 1:length(PDsx)
    data_tam = data_downsample{2,class};
    length_temp = length(data_tam);
%     fs = 250;
    fs = 500;
    time_temp = time_segment; % flexible segment time
    point_start = 1;
    point_len = fs * time_temp;
    point_end = point_start + point_len - 1;
    while point_end < length_temp
        X = sprintf('Processing ON file %d_%d', PDsx(class),count_ON);
        disp(X);
        my_field = strcat('ON_',num2str(count_ON));
        variable_ON.(my_field) = data_tam(:,point_start:point_end);
        count_ON = count_ON + 1;
        point_start = point_end + 1;
        point_end = point_start + point_len - 1;
    end
    X = sprintf('Processing ON file %d_%d', PDsx(class),count_ON);
    disp(X);
    my_field = strcat('ON_',num2str(count_ON));
    variable_ON.(my_field) = data_tam(:,point_start:length_temp);
end


for class = 1:length(PDsx)
    data_tam = data_downsample{3,class};
    length_temp = length(data_tam);
    fs = 500;
    time_temp = time_segment; % flexible segment time
    point_start = 1;
    point_len = fs * time_temp;
    point_end = point_start + point_len - 1;
    while point_end < length_temp
        X = sprintf('Processing OFF file %d_%d', PDsx(class),count_OFF);
        disp(X);
        my_field = strcat('OFF_',num2str(count_OFF));
        variable_OFF.(my_field) = data_tam(:,point_start:point_end);
        count_OFF = count_OFF + 1;
        point_start = point_end + 1;
        point_end = point_start + point_len - 1;
    end
    X = sprintf('Processing OFF file %d_%d', PDsx(class),count_OFF);
    disp(X);
    my_field = strcat('OFF_',num2str(count_OFF));
    variable_OFF.(my_field) = data_tam(:,point_start:length_temp);
end
sprintf('Count CTL = %d',count_CTL)
sprintf('Count ON = %d',count_ON)
sprintf('Count OFF = %d',count_OFF)

cd 'C:\Users\DELL\Documents\MATLAB\Data and Code\Dataset\UNMDataset\UNMgoc\Cell-raw'
save('raw_CTL_segment.mat', '-struct', 'variable_CTL');
save('raw_ON_OFF_segment.mat', '-struct', 'variable_ON');
save('raw_OFF_segment.mat', '-struct', 'variable_OFF');
    



