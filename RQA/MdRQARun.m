
clear all, close all


%% Import data
data = importdata('dataProtestsRQA.csv'); %Import as structure
dataMat = data.data; %Select data matrix from the structure

[nRow,nCol] = size(dataMat); %Number of rows and columns
PN = nCol/3; %3 time series per participant, PN = number of participants
rpLength = nRow; %Length of time series and dimensions of matrices


%% Parameters
DIM = 3; %3 columns for analysis
EMB = 1; %Default
DEL = 1; %Only use with phase space reconstruction
NORM = 'euc'; %Standard finds euclidian distance between time points
RAD = .001; %Appropriate for simple integer data like those in this example; Usually set so avg RR is between 2-5%
ZSCORE = 0; %Better for MdRQA with multiple time series or complex time series vs simple integers or categorical

%% MdRQA
for i=1:PN %Run each participant one at a time

    %Parse apart 3 columns for each of the two participants
    %d = data fed into MDRQA script
    if i == 1
        d = dataMat(:,1:3);
    else 
        d = dataMat(:,4:6);
    end

    %Run MdRQA
    [RPnoRotate, RP, MdRQARESULTS, PARAMETERS, b] = MDRQA(d,DIM,EMB,DEL,NORM,RAD,ZSCORE);
    
    %Store MdRQA data for file
    MdRQAResults(i,1) = i; MdRQAResults(i,2:7) = MdRQARESULTS(1,1:6); %Matrix size
    
%% MdRQA figure
    scrsz = get(0,'ScreenSize');
    figure('Position',[scrsz(3)/4 scrsz(4)/4 scrsz(3)/3 scrsz(4)/2]);
    h = axes('Position', [0 0 1 1], 'Visible', 'off');

    axes('Position',[.09 .45 .48 .5], 'FontSize', 8) 
    im2bw(RP*25);  
    %imagesc(RP*25);

    xlabel('X(t)','Interpreter','none', 'FontSize', 10);
    ylabel('X(t)','Interpreter','none', 'FontSize', 10);
    set(gca,'XTick',[ ]);
    set(gca,'YTick',[ ]);

    axes('Position',[.09 .35 .75 .05], 'FontSize', 8) 
    plot(1:rpLength, d(:,1), 'k-'); 
    xlim([1 rpLength]);

    axes('Position',[.09 .25 .75 .05], 'FontSize', 8) 
    plot(1:rpLength, d(:,2), 'k-'); 
    xlim([1 rpLength]);

    axes('Position',[.09 .15 .75 .05], 'FontSize', 8) 
    plot(1:rpLength, d(:,3), 'k-'); 
    xlim([1 rpLength]);

    set(gcf, 'CurrentAxes', h);
    str(1) = {['%REC = ', sprintf('%.2f',MdRQARESULTS(1,2))]};
    text(.65, 0.80, str, 'FontSize', 10, 'Color', 'k'); 
    str(1) = {['%DET = ', sprintf('%.2f',MdRQARESULTS(1,3))]};
    text(.65, .75, str, 'FontSize', 10, 'Color', 'k'); 
    str(1) = {['MAXLINE = ', sprintf('%.0f',MdRQARESULTS(1,5))]};
    text(.65, .70, str, 'FontSize', 10, 'Color', 'k'); 
    str(1) = {['MEANLINE = ', sprintf('%.0f',MdRQARESULTS(1,4))]};
    text(.65, .65, str, 'FontSize', 10, 'Color', 'k'); 
    str(1) = {['ENTROPY = ', sprintf('%.2f',MdRQARESULTS(1,6))]};
    text(.65, .60, str, 'FontSize', 10, 'Color', 'k'); 

    %Save each plot 
    graphtitle = sprintf('MdRQA_PN%.f',i);
    print(graphtitle,'-djpeg');

    
end

%Export data to csv file
header1=('CountryNumber'); header2=('DataLength'); header3=('RecurrenceRate'); header4=('PercentDeterminism'); header5=('MeanLine'); header6=('MaxLine'); header7=('EntropyOfLines'); %Define headers
outputfile = 'MdRQA_Results.csv'; %Name the output file, including extension.
fid = fopen(outputfile,'w'); %Open new output file
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s\n',header1,header2,header3,header4,header5,header6,header7); %Add headers to output file
status = fclose(fid); %Close new output file and save for later data output
dlmwrite('MdRQA_Results.csv',MdRQAResults,'-append');
