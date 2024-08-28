clc
close all
clear all

%% load data
cd 'C:\Users\DELL\Documents\MATLAB\Data and Code\Dataset\UNMDataset\UNMgoc\Cell-raw'
load('Cell-raw\raw_data_downsample.mat');

disp('Loading CTL segment ...');
load('raw_CTL_segment.mat');
disp('Loading ON segment ...');
load('raw_ON_OFF_segment.mat');
disp('Loading OFF segment ...');
load('raw_OFF_segment.mat');

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
for temp = 1:length(CTLsx)
    X = sprintf('Work on CTL ID = %d ', temp);
    disp (X);
    for count = 1:545
        raw_data_downsample{1,count} = eval(strcat('CTL_',num2str(count)));
        count = count + 1;
    end
end

for temp = 1:length(PDsx)
    X = sprintf('Work on ON ID = %d ', temp);
    disp (X);
    for count = 1:570
        raw_data_downsample{2,count} = eval(strcat('ON_',num2str(count)));
        count = count + 1;

    end
end

for temp = 1:length(PDsx)
    X = sprintf('Work on ON ID = %d ', temp);
    disp (X);
    for count = 1:548
        raw_data_downsample{3,count} = eval(strcat('OFF_',num2str(count)));
        count = count + 1;

    end
end


% size_cell = size(segment_data,2);
size_cell = size(raw_data_downsample,2);
power_delta = 0;
power_theta = 0;
power_alpha = 0;
power_beta = 0;
power_gamma = 0;

N = 1;
for class = 1:3
    sprintf('Working on class = %d',class)
%        for temp_length = 1:size_cell %2911 is the longest length of CTL - ON - OFF
         for temp_length = 1:size_cell  % 563 is the longest length of CTL - ON - OFF
        S = raw_data_downsample{class,temp_length};
        check = isempty(S);
        switch check
            case 0
                S_normal = zscore(S);
                wavelet='db4';
                level = 6;
                for channels = 1:64
                    [C,L] = wavedec(S_normal(channels,:),level,wavelet);
                    %approximate at 6 equivalent delta coef
                    delta{N,channels} = appcoef(C,L,'db4',6);
                    %details at 6 equivalent theta coef
                    theta{N,channels} = detcoef(C,L,6);
                    %details at 5 equivalent alpha coef
                    alpha{N,channels} = detcoef(C,L,5);
                    %details at 4 equivalent beta coef
                    beta{N,channels} = detcoef(C,L,4);
                    %details at 3 equivalent gamma coef
                    gamma{N,channels} = detcoef(C,L,3);
                    %total power of delta band of each channel
                    [Ea, Ed] = wenergy(C,L);
                    power_delta = power_delta + Ea;
                    total_delta(N,:) = power_delta;
                    %total power of theta band of each channel
                    power_theta = power_theta + Ed(1);
                    total_theta(N,:) = power_theta;
                    %total power of alpha band of each channel
                    power_alpha = power_alpha + Ed(2);
                    total_alpha(N,:) = power_alpha;
                    %total power of beta band of each channel
                    power_beta = power_beta + Ed(3);
                    total_beta(N,:) = power_beta;
                    %total power of gamma band of each channel
                    power_gamma = power_gamma + Ed(4);
                    total_gamma(N,:) = power_gamma;

                end
                power_delta = 0;
                power_theta = 0;
                power_alpha = 0;
                power_beta = 0;
                power_gamma = 0;
                N = N + 1;
            case 1
                break;

            end
    end
    class = class +1;
end
length_file = size(delta,1);
for size = 1:length_file
    sprintf('Extract feature num %d',size)
    for channel = 1:64
        %delta
        temp_delta = delta{size, channel};
        mean_temp_delta(size,:) = mean(temp_delta);
        kurtosis_temp_delta(size,:) = kurtosis(temp_delta);
        skewness_temp_delta(size,:) = skewness(temp_delta);
        var_temp_delta(size,:) = var(temp_delta);
        rms_temp_delta(size,:) = rms(temp_delta);
        energy_temp_delta(size,:) = sum(abs(temp_delta.^2));
       
        %theta
        temp_theta = theta{size, channel};
        mean_temp_theta(size,:) = mean(temp_theta);
        kurtosis_temp_theta(size,:) = kurtosis(temp_theta);
        skewness_temp_theta(size,:) = skewness(temp_theta);
        var_temp_theta(size,:) = var(temp_theta);
        rms_temp_theta(size,:) = rms(temp_theta);
        energy_temp_theta(size,:) = sum(abs(temp_theta.^2));
       
        %alpha
        temp_alpha = alpha{size, channel};
        mean_temp_alpha(size,:) = mean(temp_alpha);
        kurtosis_temp_alpha(size,:) = kurtosis(temp_alpha);
        skewness_temp_alpha(size,:) = skewness(temp_alpha);
        var_temp_alpha(size,:) = var(temp_alpha);
        rms_temp_alpha(size,:) = rms(temp_alpha);
        energy_temp_alpha(size,:) = sum(abs(temp_alpha.^2));
       
        %beta
        temp_beta = beta{size, channel};
        mean_temp_beta(size,:) = mean(temp_beta);
        kurtosis_temp_beta(size,:) = kurtosis(temp_beta);
        skewness_temp_beta(size,:) = skewness(temp_beta);
        var_temp_beta(size,:) = var(temp_beta);
        rms_temp_beta(size,:) = rms(temp_beta);
        energy_temp_beta(size,:) = sum(abs(temp_beta.^2));
        
    
        %gamma
        temp_gamma = gamma{size, channel};
        mean_temp_gamma(size,:) = mean(temp_gamma);
        kurtosis_temp_gamma(size,:) = kurtosis(temp_gamma);
        skewness_temp_gamma(size,:) = skewness(temp_gamma);
        var_temp_gamma(size,:) = var(temp_gamma);
        rms_temp_gamma(size,:) = rms(temp_gamma);
        energy_temp_gamma(size,:) = sum(abs(temp_gamma.^2));
       
    end
end

sb = ["delta" "theta" "alpha" "beta" "gamma"];
for i = 1:5
    mean_temp_all_band(:,i) = eval(strcat('mean_temp_', sb(i)));
    kurtosis_temp_all_band(:,i) = eval(strcat('kurtosis_temp_', sb(i)));
    skewness_temp_all_band(:,i) = eval(strcat('skewness_temp_', sb(i)));
    var_temp_all_band(:,i) = eval(strcat('var_temp_', sb(i)));
    rms_temp_all_band(:,i) = eval(strcat('rms_temp_', sb(i)));
    energy_temp_all_band(:,i) = eval(strcat('energy_temp_', sb(i)));
    power_DWT_all_band(:,i) = eval(strcat('total_',sb(i)));

end 
%class
    name_2_labels = {'CTL', 'PD'};
    class = cell(1,1622);
    for i = 1:545
    class(i) = name_2_labels(1);
    end
    for i = 546:1663
    class(i) = name_2_labels(2);
    end

raw_feature_2_labels.mean = mean_temp_all_band;
raw_feature_2_labels.kur = kurtosis_temp_all_band;
raw_feature_2_labels.skewnes = skewness_temp_all_band;
raw_feature_2_labels.var = var_temp_all_band;
raw_feature_2_labels.rms = rms_temp_all_band;
raw_feature_2_labels.energy = energy_temp_all_band;
raw_feature_2_labels.power_DWT = power_DWT_all_band;
raw_feature_2_labels.class = class';
raw_feature_2_labels = struct2table(raw_feature_2_labels);


raw_feature_3_labels = raw_feature_2_labels(:,1:7);
name_3_labels = {'CTL', 'ON','OFF'};
class_3 = cell(1,1663);
for i = 1:545
    class_3(i) = name_3_labels(1);
end
for i = 546:1115
    class_3(i) = name_3_labels(2);
end

for i = 1116:1663
    class_3(i) = name_3_labels(3);
end
raw_feature_3_labels.class = class_3';
cd 'C:\Users\DELL\Documents\MATLAB\Data and Code\Dataset\UNMDataset\UNMgoc\Cell-raw';
save('raw_feature_2_label_5s.mat','raw_feature_2_labels');
cd 'C:\Users\DELL\Documents\MATLAB\Data and Code\Dataset\UNMDataset\UNMgoc\Cell-raw'
save('raw_feature_3_label_5s.mat','raw_feature_3_labels');