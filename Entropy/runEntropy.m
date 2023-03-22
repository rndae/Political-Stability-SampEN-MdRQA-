clear all, close all


%% Import data
data = importdata('dataElectionsProjectionsEntropy.csv');
dataMat = data.data;

[nRow,nCol] = size(dataMat);

display([nRow,nCol]);

%% Define parameters for data analysis
m = 1; %Makes sense for simple Likert survey data
r = .15; %Default in many entropy papers
dist_type = 'chebychev'; %Default


%% Data prep
timeline = linspace(1,40,40);
for i=1:nCol %Run each time series one at a time

    data = dataMat(:,i);
    
    figure(i);
    xlabel('Time','Interpreter','none', 'FontSize', 10);
    ylabel('Winner Party','Interpreter','none', 'FontSize', 10);
    plot(timeline, data);

    graphtitle = sprintf('Plot%.f',i);
    print(graphtitle,'-djpeg');

    %Online code
    results(i,1) = i;
    results(i,2) = sampen(data, m, r, dist_type);
    
end

%Export data regarding points of statistical significance
header1=('TimeSeriesNumber'); header2=('Electoral Projections Entropy'); %Define headers
outputfile = 'EntropyResults.csv'; %Name the output file, including extension.
fid = fopen(outputfile,'w'); %Open new output file
fprintf(fid,'%s,%s\n',header1,header2); %Add headers to output file
status = fclose(fid); %Close new output file and save for later data output
dlmwrite('EntropyResults.csv',results,'-append');