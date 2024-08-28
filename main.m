clc 
clear all
close all
PDsx=[801,802,804:811,813:829]; 
CTLsx=[8070,8060,890:893,894,895:912,913,914];
data = cell(3,27);
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
for a=1:length(CTLsx) 
        b=sprintf('%d_1_PD_REST',CTLsx(a));
        load(b);
        data{1,a}=EEG.data;
end


for c=1:length(PDsx)
    for f=1:2
        d=sprintf('%d_%d_PD_REST',PDsx(c),f);
        load(d)  
        if ((PDsx(c)==ON_OFF_indicator(c,1)) && (f== ON_OFF_indicator(c,2)))
             data{2,c}=EEG.data;
        end  
    end
end
for c=1:length(PDsx)
    for f=1:2
        d=sprintf('%d_%d_PD_REST',PDsx(c),f);
        load(d)
        if ((PDsx(c)==ON_OFF_indicator(c,1)) && (f==ON_OFF_indicator(c,3)))
            data{3,c}=EEG.data;
        else
            continue
        end
        
    end
end       
for d=1:1
    for e=1:27
        temp=data{d,e};
          for v=1:64
            temp1 = temp(v,:);
            temp1 = downsample(temp1,2);
            download_data(v,:) = temp1;
          end
          data_downsample{d,e} = download_data
          clear download_data;
      end
end

for d=2:3
    for e=1:27
        temp=data{d,e};
          for v=1:64
            temp1 = temp(v,:);
            temp1 = downsample(temp1,2);
            download_data(v,:) = temp1;
          end
          data_downsample{d,e} = download_data
          clear download_data;
      end
end