% Display All Channels
function displayAllChannelsSRC(subjectName,expDate,protocolName,folderSourceString,gridType,capType)

if ~exist('folderSourceString','var');   folderSourceString='E:';       end
if ~exist('gridType','var');             gridType='EEG';                end

% this is for running EEG datasets;For Microelectrode-this argument need not be passed
if ~exist('capType','var');              capType='actiCap64';           end

folderName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName);

% Get folders
folderExtract = fullfile(folderName,'extractedData');
folderSegment = fullfile(folderName,'segmentedData');

% for Impedance based filtering : for the topoplots-to mark the bad channels
folderImpedance=fullfile(folderSourceString,'data',subjectName,gridType,expDate);
HighImpedanceCutOff=2500;LowImpedanceCutOff=250;

folderLFP = fullfile(folderSegment,'LFP');
folderSpikes = fullfile(folderSegment,'Spikes');

% load LFP Information
[analogChannelsStored,timeVals] = loadlfpInfo(folderLFP);
[neuralChannelsStored,SourceUnitID] = loadspikeInfo(folderSpikes);

% Get Combinations
[parameterCombinations,cIndexValsUnique,tIndexValsUnique,eIndexValsUnique,...
    aIndexValsUnique,sIndexValsUnique] = loadParameterCombinations(folderExtract);

% Get properties of the Stimulus
stimResults = loadStimResults(folderExtract);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display main options
fontSizeSmall = 10; fontSizeMedium = 12; fontSizeLarge = 16;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display layout is modified to have the topoplots :
% the panel gets divided into two halves
panel_factor=0.5;
topoPanelWidth=0.20; topoStartPos=0.175;

% Make Panels
panelHeight = 0.25; panelStartHeight = 0.675;
staticPanelWidth = 0.60*panel_factor; staticStartPos = 0.025;
dynamicPanelWidth = 0.20; dynamicStartPos = 0.375;
timingPanelWidth = 0.20; timingStartPos = 0.575;
plotOptionsPanelWidth = 0.2; plotOptionsStartPos = 0.775;
backgroundColor = 'w';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Static Panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% staticTitle = [subjectName '_' expDate '_' protocolName];
% hStaticPanel = uipanel('Title','Information','fontSize', fontSizeLarge, ...
%    'Unit','Normalized','Position',[staticStartPos panelStartHeight staticPanelWidth panelHeight]);
%
% if isfield(stimResults,'orientation')
%     oriStr = num2str(stimResults.orientation);
% else
%     oriStr = [num2str(stimResults.baseOrientation0) ',' num2str(stimResults.baseOrientation1)];
% end
%
% staticText = [{ '   '};
%     {['Monkey Name: ' subjectName]}; ...
%     {['Date: ' expDate]}; ...
%     {['Protocol Name: ' protocolName]}; ...
%     {'   '}
%     {['Orientation  (Deg): ' oriStr]}; ...
%     {['Spatial Freq (CPD): ' num2str(stimResults.spatialFrequency)]}; ...
%     {['Azimuth      (Deg): ' num2str(stimResults.azimuth)]}; ...
%     {['Elevation    (Deg): ' num2str(stimResults.elevation)]}; ...
%     {['Sigma        (Deg): ' num2str(stimResults.sigma)]}; ...
%     {['Radius       (Deg): ' num2str(stimResults.radius)]}; ...
%     ];
%
% disp(staticText);
%
% uicontrol('Parent',hStaticPanel,'Unit','Normalized', ...
%     'Position',[0 0 1 1], 'Style','text','String',staticText,'FontSize',fontSizeSmall);

electrodeGridPos = [staticStartPos panelStartHeight staticPanelWidth/2 panelHeight];
hElectrodes = showElectrodeLocations(electrodeGridPos,[],[],[],1,0,gridType,subjectName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dynamic panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dynamicHeight = 0.11; dynamicGap=0.02; dynamicTextWidth = 0.6;
hDynamicPanel = uipanel('Title','Parameters','fontSize', fontSizeLarge, ...
    'Unit','Normalized','Position',[dynamicStartPos panelStartHeight dynamicPanelWidth panelHeight]);

% Contrast
contrastString = getContrastString(cIndexValsUnique,stimResults);
uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[0 1-(dynamicHeight+dynamicGap) dynamicTextWidth dynamicHeight],...
    'Style','text','String','Contrast (%)','FontSize',fontSizeSmall);
hContrast = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', ...
    [dynamicTextWidth 1-(dynamicHeight+dynamicGap) 1-dynamicTextWidth dynamicHeight], ...
    'Style','popup','String',contrastString,'FontSize',fontSizeSmall);

% Temporal Frequency
temporalFreqString = getTemporalFreqString(tIndexValsUnique,stimResults);
uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[0 1-2*(dynamicHeight+dynamicGap) dynamicTextWidth dynamicHeight], ...
    'Style','text','String','Temporal Freq (Hz)','FontSize',fontSizeSmall);
hTemporalFreq = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position',...
    [dynamicTextWidth 1-2*(dynamicHeight+dynamicGap) 1-dynamicTextWidth dynamicHeight], ...
    'Style','popup','String',temporalFreqString,'FontSize',fontSizeSmall);

% EOT Codes
EOTCodeString = getEOTCodeString(eIndexValsUnique);
uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[0 1-3*(dynamicHeight+dynamicGap) dynamicTextWidth dynamicHeight], ...
    'Style','text','String','EOT Code','FontSize',fontSizeSmall);
hEOTCode = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', ...
    [dynamicTextWidth 1-3*(dynamicHeight+dynamicGap) 1-dynamicTextWidth dynamicHeight], ...
    'Style','popup','String',EOTCodeString,'FontSize',fontSizeSmall);

% Attend Loc
attendLocString = getAttendLocString(aIndexValsUnique);
uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[0 1-4*(dynamicHeight+dynamicGap) dynamicTextWidth dynamicHeight], ...
    'Style','text','String','Attended Location','FontSize',fontSizeSmall);
hAttendLoc = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', ...
    [dynamicTextWidth 1-4*(dynamicHeight+dynamicGap) 1-dynamicTextWidth dynamicHeight], ...
    'Style','popup','String',attendLocString,'FontSize',fontSizeSmall);

% Stimulus Type
stimTypeString = getStimTypeString(sIndexValsUnique);
uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[0 1-5*(dynamicHeight+dynamicGap) dynamicTextWidth dynamicHeight], ...
    'Style','text','String','Stimulus Type','FontSize',fontSizeSmall);
hStimType = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', ...
    [dynamicTextWidth 1-5*(dynamicHeight+dynamicGap) 1-dynamicTextWidth dynamicHeight], ...
    'Style','popup','String',stimTypeString,'FontSize',fontSizeSmall);

% Analysis Type
analysisTypeString = 'ERP|Firing Rate|FFT|delta FFT';
uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[0 1-6*(dynamicHeight+dynamicGap) dynamicTextWidth dynamicHeight], ...
    'Style','text','String','Analysis Type','FontSize',fontSizeSmall);
hAnalysisType = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', ...
    [dynamicTextWidth 1-6*(dynamicHeight+dynamicGap) 1-dynamicTextWidth dynamicHeight], ...
    'Style','popup','String',analysisTypeString,'FontSize',fontSizeSmall);
% Baseline correction : to remove drifts in the data
BaselineTypeString = 'No|Yes';
uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[0 1-7*(dynamicHeight+dynamicGap) dynamicTextWidth dynamicHeight], ...
    'Style','text','String','baseline Correction','FontSize',fontSizeSmall);
hbaselineCorrection = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', ...
    [dynamicTextWidth 1-7*(dynamicHeight+dynamicGap) 1-dynamicTextWidth dynamicHeight], ...
    'Style','popup','String',BaselineTypeString,'FontSize',fontSizeSmall);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Timing panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timingHeight = 0.13; timingTextWidth = 0.5; timingBoxWidth = 0.25;
hTimingPanel = uipanel('Title','Timing','fontSize', fontSizeLarge, ...
    'Unit','Normalized','Position',[timingStartPos panelStartHeight timingPanelWidth panelHeight]);

signalRange = [timeVals(1) timeVals(end)];
fftRange = [0 250];
baseline = [-0.2 0];
stimPeriod = [0 0.2];

% Signal Range
uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[0 1-timingHeight timingTextWidth timingHeight], ...
    'Style','text','String','Parameter','FontSize',fontSizeMedium);

uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[timingTextWidth 1-timingHeight timingBoxWidth timingHeight], ...
    'Style','text','String','Min','FontSize',fontSizeMedium);

uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[timingTextWidth+timingBoxWidth 1-timingHeight timingBoxWidth timingHeight], ...
    'Style','text','String','Max','FontSize',fontSizeMedium);

% Stim Range
uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[0 1-2*timingHeight timingTextWidth timingHeight], ...
    'Style','text','String','Stim Range (s)','FontSize',fontSizeSmall);
hStimMin = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth 1-2*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(signalRange(1)),'FontSize',fontSizeSmall);
hStimMax = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth+timingBoxWidth 1-2*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(signalRange(2)),'FontSize',fontSizeSmall);

% FFT Range
uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[0 1-3*timingHeight timingTextWidth timingHeight], ...
    'Style','text','String','FFT Range (Hz)','FontSize',fontSizeSmall);
hFFTMin = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth 1-3*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(fftRange(1)),'FontSize',fontSizeSmall);
hFFTMax = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth+timingBoxWidth 1-3*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(fftRange(2)),'FontSize',fontSizeSmall);

% Baseline
uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[0 1-4*timingHeight timingTextWidth timingHeight], ...
    'Style','text','String','Basline (s)','FontSize',fontSizeSmall);
hBaselineMin = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth 1-4*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(baseline(1)),'FontSize',fontSizeSmall);
hBaselineMax = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth+timingBoxWidth 1-4*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(baseline(2)),'FontSize',fontSizeSmall);

% Stim Period
uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[0 1-5*timingHeight timingTextWidth timingHeight], ...
    'Style','text','String','Stim period (s)','FontSize',fontSizeSmall);
hStimPeriodMin = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth 1-5*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(stimPeriod(1)),'FontSize',fontSizeSmall);
hStimPeriodMax = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth+timingBoxWidth 1-5*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(stimPeriod(2)),'FontSize',fontSizeSmall);

% Y Range
uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[0 1-6*timingHeight timingTextWidth timingHeight], ...
    'Style','text','String','Y Range','FontSize',fontSizeSmall);
hYMin = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth 1-6*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String','0','FontSize',fontSizeSmall);
hYMax = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth+timingBoxWidth 1-6*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String','1','FontSize',fontSizeSmall);

% include a ERP computation range- to make ERP calculation independant of TF plots
% also to calculate ERP for very small time ranges
ERPPeriod=[0 0.25];
uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[0 1-7*timingHeight timingTextWidth timingHeight], ...
    'Style','text','String','ERP period (s)','FontSize',fontSizeSmall);
hERPPeriodMin = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth 1-7*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(ERPPeriod(1)),'FontSize',fontSizeSmall);
hERPPeriodMax = uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[timingTextWidth+timingBoxWidth 1-7*timingHeight timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(ERPPeriod(2)),'FontSize',fontSizeSmall);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot Options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotOptionsHeight = 0.13;
hPlotOptionsPanel = uipanel('Title','Plotting Options','fontSize', fontSizeLarge, ...
    'Unit','Normalized','Position',[plotOptionsStartPos panelStartHeight plotOptionsPanelWidth panelHeight]);

% Button for Plotting
[colorString, colorNames] = getColorString;
uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 1-plotOptionsHeight 0.6 plotOptionsHeight], ...
    'Style','text','String','Color','FontSize',fontSizeSmall);
hChooseColor = uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[0.6 1-plotOptionsHeight 0.4 plotOptionsHeight], ...
    'Style','popup','String',colorString,'FontSize',fontSizeSmall);
uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 1-2.5*plotOptionsHeight 0.6 plotOptionsHeight], ...
    'Style','text','String','Tapers for PSD','FontSize',fontSizeSmall);
hTapers = uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[0.6 1-2.5*plotOptionsHeight 0.4 plotOptionsHeight], ...
    'Style','edit','String',num2str(1),'FontSize',fontSizeSmall); % to be used by the mtspectrumc function

uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 4*plotOptionsHeight 1 plotOptionsHeight], ...
    'Style','pushbutton','String','cla','FontSize',fontSizeMedium, ...
    'Callback',{@cla_Callback});

hHoldOn = uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 3*plotOptionsHeight 1 plotOptionsHeight], ...
    'Style','togglebutton','String','hold on','FontSize',fontSizeMedium, ...
    'Callback',{@holdOn_Callback});

uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 2*plotOptionsHeight 1 plotOptionsHeight], ...
    'Style','pushbutton','String','rescale Y','FontSize',fontSizeMedium, ...
    'Callback',{@rescaleY_Callback});

uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 plotOptionsHeight 1 plotOptionsHeight], ...
    'Style','pushbutton','String','rescale X','FontSize',fontSizeMedium, ...
    'Callback',{@rescaleData_Callback});

uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 0 1 plotOptionsHeight], ...
    'Style','pushbutton','String','plot','FontSize',fontSizeMedium, ...
    'Callback',{@plotData_Callback});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Topoplot/Grid Plot Options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

topoHeight = 0.13; topoGap=0.02; topoTextWidth = 0.5;topoBoxWidth=0.25;
htopoPanel = uipanel('Title','Topo Plots','fontSize', fontSizeLarge, ...
    'Unit','Normalized','Position',[topoStartPos panelStartHeight topoPanelWidth panelHeight]);

%  To choose Channel for ERP and pooled ERP (if pooled elecs=0) and  TF Plots
analogChannelStringList = getStringFromValues(analogChannelsStored,1); % using the function used in displySingleChannelSRC
uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'Position',[0 1-(topoHeight+topoGap) topoTextWidth topoHeight],...
    'Style','text','String','Analog Channel','FontSize',fontSizeSmall);
hAnalogChannel = uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', ...
    [topoTextWidth 1-(topoHeight+topoGap) topoTextWidth/2 topoHeight], ...
    'Style','popup','String',analogChannelStringList,'FontSize',fontSizeSmall);

% clear button for the topoplots
uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'Position',[topoTextWidth+topoTextWidth/2 1-(topoHeight+topoGap) topoTextWidth/2 topoHeight],...
    'Style','pushbutton','String','Cla','FontSize',fontSizeSmall,'Callback',{@cla_Topoplots_Callback});

%Referencing- whether single,bipolar,average,with a specific
%channel-applies only for EEG Datasets
if strcmp(gridType,'EEG')
    uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
        'Position',[0 1-2*(topoHeight+topoGap) topoTextWidth topoHeight],...
        'Style','text','String','Ref Channel','FontSize',fontSizeSmall);
    hRefChannel = uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
        'BackgroundColor', backgroundColor, 'Position', ...
        [topoTextWidth 1-2*(topoHeight+topoGap) 1-topoTextWidth topoHeight], ...
        'Style','popup','String',(['Single Wire|Hemisphere|Average|Bipolar|' analogChannelStringList]),'FontSize',fontSizeSmall,'Callback',{@resetRef_Callback});
    uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
        'Position',[0 1-3.2*(topoHeight+topoGap) topoTextWidth topoHeight],...
        'Style','text','String','TopoPlot','FontSize',fontSizeSmall);
    % Topoplot options:
    uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
        'Position',[topoTextWidth 1-3.2*(topoHeight+topoGap) topoBoxWidth topoHeight],...
        'Style','pushbutton','String','Ref-ERP','FontSize',fontSizeSmall,'Callback',{@plotERP_ReRef_Callback});
    uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
        'Position',[topoTextWidth+topoBoxWidth 1-3.2*(topoHeight+topoGap) topoBoxWidth topoHeight],...
        'Style','pushbutton','String','dsPower','FontSize',fontSizeSmall,'Callback',{@plotSpectrumTopo_Callback});
    
else % for LFP/ECoG datasets topoplot is used only for TF plots
    % include a visual screening based on the impedance values if the file exists
    badChanString='Yes|No';
    uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
        'Position',[0 1-2.0*(topoHeight+topoGap) topoTextWidth topoHeight],...
        'Style','text','String','Mark BadChan','FontSize',fontSizeSmall);
    hMarkBadChan=uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
        'Position',[topoTextWidth 1-2.0*(topoHeight+topoGap) topoBoxWidth*2 topoHeight],...
        'Style','popup','String',badChanString,'FontSize',fontSizeSmall);
    uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
        'Position',[0 1-3.0*(topoHeight+topoGap) topoTextWidth topoHeight],...
        'Style','text','String','TopoPlot','FontSize',fontSizeSmall);
    uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
        'Position',[topoTextWidth 1-3.0*(topoHeight+topoGap) topoBoxWidth*2 topoHeight],...
        'Style','pushbutton','String','ChangeInPower','FontSize',fontSizeSmall,'Callback',{@plotSpectrumTopo_Callback});
end

% topolots for the entire scalp/grid -requires two inputs- the frequency % band & type of data (single/bipolar/average/hemisphere)
alphaRange=[8 13];
freqRange=[30 80];
uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'Position',[0 1-4.5*topoHeight topoTextWidth topoHeight], ...
    'Style','text','String','Alpha range (Hz)','FontSize',fontSizeSmall);
halphaRangeMin = uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[topoTextWidth 1-4.5*topoHeight timingBoxWidth topoHeight], ...
    'Style','edit','String',num2str(alphaRange(1)),'FontSize',fontSizeSmall);
halphaRangeMax = uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[topoTextWidth+timingBoxWidth 1-4.5*topoHeight timingBoxWidth topoHeight], ...
    'Style','edit','String',num2str(alphaRange(2)),'FontSize',fontSizeSmall);
uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'Position',[0 1-5.5*topoHeight topoTextWidth topoHeight], ...
    'Style','text','String','Freq range (Hz)','FontSize',fontSizeSmall);
hfreqRangeMin = uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[topoTextWidth 1-5.5*topoHeight timingBoxWidth topoHeight], ...
    'Style','edit','String',num2str(freqRange(1)),'FontSize',fontSizeSmall);
hfreqRangeMax = uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[topoTextWidth+timingBoxWidth 1-5.5*topoHeight timingBoxWidth topoHeight], ...
    'Style','edit','String',num2str(freqRange(2)),'FontSize',fontSizeSmall);

% Electrode list- for pooled analysis
uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'Position',[0 1-6.5*topoHeight topoTextWidth topoHeight], ...
    'Style','text','String','Elecs to Pool','FontSize',fontSizeSmall);
hERPElecPool = uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor,...
    'Position',[topoTextWidth 1-6.5*topoHeight topoTextWidth topoHeight],...
    'Style','edit','FontSize',fontSizeSmall);

% Type of analysis with the electrodes pooled
poolAnalysisString='ERP|TF'; poolOptionWidth=topoTextWidth/2;
uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'Position',[0 1-7.5*topoHeight topoTextWidth topoHeight],...
    'Style','text','String','Pool Analysis','FontSize',fontSizeSmall);
hPoolAnalysisType=uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'Position',[topoTextWidth 1-7.5*topoHeight poolOptionWidth topoHeight],...
    'Style','popup','String',poolAnalysisString,'FontSize',fontSizeSmall);

% plot button for the ERP/TF Plots
uicontrol('Parent',htopoPanel,'Unit','Normalized', ...
    'Position',[topoTextWidth+poolOptionWidth 1-7.5*topoHeight poolOptionWidth topoHeight],...
    'Style','pushbutton','String','Plot','FontSize',fontSizeSmall,'Callback',{@plotPoolElecs_Callback});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get main plot and message handles
% Panel gets divided into two to house the topoplots
if strcmpi(gridType,'ECoG')
    plotHandles = getPlotHandles(8,10,[0.05 0.05 0.95*panel_factor 0.570]);
elseif strcmpi(gridType,'EEG')
    plotHandles = getPlotHandles(9,11,[0.05 0.05 0.95*panel_factor 0.570]);
else
    plotHandles = getPlotHandles(10,10,[0.05 0.05 0.95*panel_factor 0.570]);
end

% additional variables- defining the topoplot/grid activity locations on the right side of the panel
capStartPos=0.535;
capStartHeight=0.05;
capBoxWidth=0.45;
capBoxHeight=0.50;
capGap = 0.04;
% topoplot locations -ERP plots
electrodeCapPosERP=[capStartPos capStartHeight+capBoxHeight/2+capGap capBoxWidth/2 capBoxHeight/2];
capERPHandle = subplot('Position',electrodeCapPosERP); axis off;
electrodeCapPosERPRef=[capStartPos+(capBoxWidth/2)+capGap capStartHeight+capBoxHeight/2+capGap capBoxWidth/2 capBoxHeight/2];
capERPRefHandle = subplot('Position',electrodeCapPosERPRef); axis off;
% topoplot locations -  change in power plots
electrodeCapPosTFalpha=[capStartPos capStartHeight capBoxWidth/2 capBoxHeight/2];
capAlphaPowerHandle=subplot('Position',electrodeCapPosTFalpha); axis off;
electrodeCapPosTF=[capStartPos+(capBoxWidth/2)+capGap capStartHeight capBoxWidth/2 capBoxHeight/2];
capGammaPowerHandle=subplot('Position',electrodeCapPosTF); axis off;

%additional trial rejection/electrode visibility options
badTrials=loadbadTrials(folderSegment); % get the bad trials file if present
impedanceValues=loadImpedanceValues(folderImpedance);% get the impedance file if present

%setting multi taper parameters for time frequency plots
% Set MT parameters
fMax=fftRange(2);
k=str2double(get(hTapers,'string'));
TW=ceil((k+1)/2);   % k<=2TW-1; TW-time bandwidth factor;k-no of tapers;
params.tapers   = [TW k];
params.pad      = -1;
params.Fs       = 1/abs(timeVals(1)-timeVals(2));
params.fpass    = [0 fMax];
params.trialave = 1;
movingWin = [0.25 0.025];

hMessage = uicontrol('Unit','Normalized','Position',[0 0.925 1 0.07],...
    'Style','text','String','DisplayAllChannelsSRC','FontSize',fontSizeMedium);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% functions
    function plotData_Callback(~,~)
        c=get(hContrast,'val');
        t=get(hTemporalFreq,'val');
        e=get(hEOTCode,'val');
        a=get(hAttendLoc,'val');
        s=get(hStimType,'val');
        analysisType = get(hAnalysisType,'val');
        blCorrection=get(hbaselineCorrection,'val');
        plotColor = colorNames(get(hChooseColor,'val'));
        
        blRange = [str2double(get(hBaselineMin,'String')) str2double(get(hBaselineMax,'String'))];
        stRange = [str2double(get(hStimPeriodMin,'String')) str2double(get(hStimPeriodMax,'String'))];
        
        goodPos = parameterCombinations{c,t,e,a,s};
        goodPos=setdiff(goodPos,badTrials);
        
        set(hMessage,'String',[num2str(length(goodPos)) ' stimuli found' ]);
        
        if ~isempty(goodPos)
            if analysisType == 2
                holdOnState = get(hHoldOn,'val');
                channelsStored = neuralChannelsStored;
                [baselineFiringRate,stimulusFiringRate] = plotSpikeData(plotHandles,channelsStored,goodPos,folderSpikes,...
                    timeVals,plotColor,SourceUnitID,holdOnState,blRange,stRange,gridType);
                
                responsiveElectrodes = (channelsStored(stimulusFiringRate>=5));
                rareElectrodes = setdiff((channelsStored(stimulusFiringRate>=2)),responsiveElectrodes);
                inhibitedElectrodes = (channelsStored(intersect(find(baselineFiringRate>stimulusFiringRate),find(baselineFiringRate>2))));
                disp(['rareUnits: ' num2str(rareElectrodes)]);
                disp(['responsive: ' num2str(responsiveElectrodes)]);
                disp(['inhibited : ' num2str(inhibitedElectrodes)]);
                
                showElectrodeLocations(electrodeGridPos,responsiveElectrodes,'b',hElectrodes,0,0,gridType,subjectName);
                showElectrodeLocations(electrodeGridPos,inhibitedElectrodes,'g',hElectrodes,1,0,gridType,subjectName);
            else
                channelsStored = analogChannelsStored;
                if analysisType==1 % for ERP Computation
                    % get the time range over which RMS erp has to be computed and plotted as topolot
                    % Topoplot location in the main figure is the additional argument passed to the function
                    erpRange = [str2double(get(hERPPeriodMin,'String')) str2double(get(hERPPeriodMax,'String'))];
                    
                    if strcmp(gridType,'EEG') %-additional arguments like capType whether active/passive
                        plotLFPData(plotHandles,channelsStored,goodPos,folderLFP,...
                            analysisType,timeVals,blCorrection,plotColor,blRange,stRange,gridType,subjectName,erpRange,[],capERPHandle,capType);
                    else    %for Microelectrodes/EcoG
                        %highlight the electrodes with bad impedance values
                        %in white-figure background color
                        MarkBadChanStatus=get(hMarkBadChan,'val');
                        if MarkBadChanStatus==1 % mark the channels with bad impedance;as of now the limits are hardcoded;could be inlcuded as options in the GUI as well
                            badElecsList1=find(impedanceValues>HighImpedanceCutOff);
                            badElecsList2=find(impedanceValues<LowImpedanceCutOff);
                            MarkBadChan=[badElecsList1 badElecsList2];
                        else
                            MarkBadChan=[];
                        end
                        plotLFPData(plotHandles,channelsStored,goodPos,folderLFP,...
                            analysisType,timeVals,blCorrection,plotColor,blRange,stRange,gridType,subjectName,erpRange,[],capERPHandle,[], MarkBadChanStatus,MarkBadChan);
                    end
                else % for FFT and delta FFT- pass the mtspectrum parameters like tapers,fs.
                    plotLFPData(plotHandles,channelsStored,goodPos,folderLFP,...
                        analysisType,timeVals,blCorrection,plotColor,blRange,stRange,gridType,subjectName,[],params);
                end
            end
            
            if analysisType<=2 % ERP or spikes
                xRange = [str2double(get(hStimMin,'String')) str2double(get(hStimMax,'String'))];
            else
                xRange = [str2double(get(hFFTMin,'String')) str2double(get(hFFTMax,'String'))];
            end
            
            yRange = getYLims(plotHandles,channelsStored,gridType,subjectName);
            rescaleData(plotHandles,channelsStored,[xRange yRange],gridType,subjectName);
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function rescaleY_Callback(~,~)
        
        analysisType = get(hAnalysisType,'val');
        
        if analysisType == 2
            channelsStored = neuralChannelsStored;
        else
            channelsStored = analogChannelsStored;
        end
        
        if analysisType<=2 % ERP or spikes
            xRange = [str2double(get(hStimMin,'String')) str2double(get(hStimMax,'String'))];
        else
            xRange = [str2double(get(hFFTMin,'String')) str2double(get(hFFTMax,'String'))];
        end
        
        yRange = [str2double(get(hYMin,'String')) str2double(get(hYMax,'String'))];
        rescaleData(plotHandles,channelsStored,[xRange yRange],gridType,subjectName);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function rescaleData_Callback(~,~)
        
        analysisType = get(hAnalysisType,'val');
        
        if analysisType == 2
            channelsStored = neuralChannelsStored;
        else
            channelsStored = analogChannelsStored;
        end
        
        if analysisType<=2 % ERP or spikes
            xRange = [str2double(get(hStimMin,'String')) str2double(get(hStimMax,'String'))];
        else
            xRange = [str2double(get(hFFTMin,'String')) str2double(get(hFFTMax,'String'))];
        end
        
        yRange = getYLims(plotHandles,channelsStored,gridType,subjectName);
        rescaleData(plotHandles,channelsStored,[xRange yRange],gridType,subjectName);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function holdOn_Callback(source,~)
        holdOnState = get(source,'Value');
        
        [numRow,numCol] = size(plotHandles);
        
        if holdOnState
            for i=1:numRow
                for j=1:numCol
                    set(plotHandles(i,j),'Nextplot','add');
                end
            end
        else
            for i=1:numRow
                for j=1:numCol
                    set(plotHandles(i,j),'Nextplot','replace');
                end
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function cla_Callback(~,~)
        [numRow,numCol] = size(plotHandles);
        for i=1:numRow
            for j=1:numCol
                cla(plotHandles(i,j));
            end
        end
        %clear the ERP topoplot
        subplot(capERPHandle);cla(gca,'reset');axis off;
    end
%__________________________EEG/topoplot Specific functions__________________________

%this function plots the ERP topoplots for any reference scheme-if chosen-applicable only to EEG datasets
    function plotERP_ReRef_Callback(~,~)
        refChanIndex = get(hRefChannel,'val');
        % only if the reference scheme is anything other than single reference
        if refChanIndex ~= 1
            % Intitialise
            c=get(hContrast,'val');
            t=get(hTemporalFreq,'val');
            e=get(hEOTCode,'val');
            a=get(hAttendLoc,'val');
            s=get(hStimType,'val');
            ERPRange = [str2double(get(hERPPeriodMin,'String')) str2double(get(hERPPeriodMax,'String'))];
            blRange =  [str2double(get(hBaselineMin,'String')) str2double(get(hBaselineMax,'String'))];
            blCorrection=get(hbaselineCorrection,'val');
            goodPos = setdiff(parameterCombinations{c,t,e,a,s},badTrials);
            
            % Get Data based on ref scheme-data from all electrodes
            Data = getElecDataSRC(goodPos,timeVals,analogChannelsStored,folderLFP);
            [ReRef_Data,chanlocs] = bipolarRef(refChanIndex,Data);
            
            %get the values for topoplot
            [erpTopoRef,~] = getERPDataRef(ReRef_Data,timeVals,blRange,blCorrection,ERPRange);
            subplot(capERPRefHandle);cla(gca,'reset'); axis off;
            topoplot(erpTopoRef,chanlocs,'electrodes','numbers','style','both','drawaxis','off','maplimits','maxmin');
            colorbar; colormap('jet');
            refType=getRefschemeName(refChanIndex);
            title(refType);
        else
            disp('Rereferencing was not chosen;Use Plot button in plottingOptions panel to see the single reference ERP');
        end
    end

% function for Plotting TF topoplot- alpha and specified freq band
    function plotSpectrumTopo_Callback(~,~)
        % Intitialise
        a=get(hAttendLoc,'val');
        e=get(hEOTCode,'val');
        s=get(hStimType,'val');
        c=get(hContrast,'val');
        t=get(hTemporalFreq,'val');
        if strcmp(gridType,'EEG')
            refChanIndex = get(hRefChannel,'val');
        end
        goodPos = setdiff(parameterCombinations{c,t,e,a,s},badTrials);
        
        %get the baseline and stimulus epoch ranges
        blRange =[str2double(get(hBaselineMin,'string')) str2double(get(hBaselineMax,'string'))];
        stRange=[str2double(get(hStimPeriodMin,'string')) str2double(get(hStimPeriodMax,'string'))];
        blCorrection=get(hbaselineCorrection,'val');
        
        %get the ranges for the frequency bands
        alphaRange=[str2double(get(halphaRangeMin,'string')) str2double(get(halphaRangeMax,'string'))];
        freqRange =[str2double(get(hfreqRangeMin,'string'))  str2double(get(hfreqRangeMax,'string'))];
        
        % remove the power line related frequencies
        if strcmp(subjectName,'abu') || strcmp(subjectName,'rafiki') % power line is 60hz;
            badFreqPosType=1;
        else % 50 hz and its harmonics
            badFreqPosType=2;
        end
        
        %get the data
        if strcmp(gridType,'EEG')
            if refChanIndex~=1 % re -referncing of any sort-get data from all channels
                % Get Data
                DataAllElec = getElecDataSRC(goodPos,timeVals,analogChannelsStored,folderLFP,blCorrection,blRange);
                % status of the reference scheme for EEG:
                [Data,chanlocs] = bipolarRef(refChanIndex,DataAllElec);
                [gammaPower,alphaPower]=getChangeInPowerTopoData_ReRef(Data,params,timeVals,blRange,stRange,alphaRange,freqRange,blCorrection,badFreqPosType);
            else % for single reference EEG
                chanlocs=loadChanLocs(capType,refChanIndex);
                [gammaPower,alphaPower]=getChangeInPowerData(goodPos,analogChannelsStored,folderLFP,timeVals,blCorrection,blRange,stRange,alphaRange,freqRange,params,badFreqPosType);
            end
        else  % for Microelectrode/ECoG data
            [~,~,electrodeGridPos]=electrodePositionOnGrid(1,gridType,subjectName);
            chanlocs=electrodeGridPos;
            [gammaPower,alphaPower]=getChangeInPowerData(goodPos,analogChannelsStored,folderLFP,timeVals,blCorrection,blRange,stRange,alphaRange,freqRange,params,badFreqPosType);
            
            %impedance based visual screening-if chosen
            MarkBadChanStatus=get(hMarkBadChan,'val');
            if MarkBadChanStatus==1 % mark the channels with bad impedance;as of now the limits are hardcoded;could be inlcuded as options in the GUI as well
                badElecsList1=find(impedanceValues>HighImpedanceCutOff);
                badElecsList2=find(impedanceValues<LowImpedanceCutOff);
                MarkBadChan=[badElecsList1 badElecsList2];
                disp(['Marking bad channels:' num2str(MarkBadChan), ' in White']);
                for bCh=1:length(MarkBadChan)
                    [row,coloumn]=find(chanlocs==(MarkBadChan(bCh))); % if the chanlocs are zero,they take the color of the figure background
                    chanlocs(row,coloumn)=0;
                    clear row;clear coloumn;
                end
            end
        end
        
        %Plotting the topoplots:
        % change in alpha power
        subplot(capAlphaPowerHandle);cla(gca,'reset');axis off;
        if strcmp(gridType,'EEG')
            [refType]=getRefschemeName(refChanIndex);
            text(1.4,0.01,refType,'parent',capAlphaPowerHandle,'unit','normalized');
            topoplot(10*alphaPower,chanlocs,'electrodes','numbers','style','both','drawaxis','off','maplimits','maxmin');
        else % for LFP/ECoG Datasets
            topoplot(10*alphaPower,[],'plotgrid',chanlocs,'electrodes','numbers','style','both','maplimits','maxmin');
        end
        colorbar; title('Change in alpha power');
        
        %change in gamma/any specified frequency band power
        subplot(capGammaPowerHandle);cla(gca,'reset');axis off;
        if strcmp(gridType,'EEG')
            topoplot(10*gammaPower,chanlocs,'electrodes','numbers','style','both','drawaxis','off','maplimits','maxmin');
        else
            topoplot(10*gammaPower,[],'plotgrid',chanlocs,'electrodes','numbers','style','both','maplimits','maxmin');
        end
        colorbar; title('Change in  chosen band power');
    end

% function for plotting ERP waveforms from pooled electrodes
    function plotPoolElecs_Callback(~,~)
        a=get(hAttendLoc,'val');
        e=get(hEOTCode,'val');
        s=get(hStimType,'val');
        c=get(hContrast,'val');
        t=get(hTemporalFreq,'val');
        
        if strcmp(gridType,'EEG')
            refChanIndex = get(hRefChannel,'val');
            [refType]=getRefschemeName(refChanIndex);
        end
        analysisType=get(hPoolAnalysisType,'val');
        
        % get  electrodes list and ERP time ranges
        blRange =  [str2double(get(hBaselineMin,'String')) str2double(get(hBaselineMax,'String'))];
        blCorrection=get(hbaselineCorrection,'val');
        goodPos = setdiff(parameterCombinations{c,t,e,a,s},badTrials);
        ERPPoolElecs = str2double(get(hERPElecPool,'string'));
        
        if isempty(ERPPoolElecs)
            disp('Electrodes to pool not specified...');
            ERPPoolElecs = get(hAnalogChannel,'val');
        else
            disp(['Computing pooled ERP for electrodes : ',num2str(ERPPoolElecs)]);
        end
        
        try % to catch the exception where the entered electrode no exceeds the list/is not in the rereferenced list
            % Get Data
            if (strcmp(gridType,'EEG') && refChanIndex==1) || strcmp(gridType,'Microelectrode') || strcmp(gridType,'ECoG')
                [plotData] = getElecDataSRC(goodPos,timeVals,ERPPoolElecs,folderLFP);
                Data=plotData;
            else % re-reference chosen
                % Get Data for all the electrodes : this is to ensure the
                % re-ref options have data from all channels
                [plotData] = getElecDataSRC(goodPos,timeVals,analogChannelsStored,folderLFP);
                [Data]=bipolarRef(refChanIndex,plotData);
            end
            
            %Initialise the size of variables
            if analysisType==1 % for ERP
                meanERPelec=zeros(length(ERPPoolElecs),length(timeVals));
            else   % For Time Frequency plots
                allElecData=zeros(length(ERPPoolElecs),length(goodPos),length(timeVals));
            end
            
            % pick out the data for the set of electrodes to be pooled
            for iP = 1:length(ERPPoolElecs)
                if (strcmp(gridType,'EEG') && refChanIndex==1) || strcmp(gridType,'Microelectrode') ||strcmp(gridType,'ECoG')
                    elecData = squeeze(Data(iP,:,:));
                else
                    elecData = squeeze(Data(ERPPoolElecs(iP),:,:));
                end
                if analysisType==1 % pool ERP analysis
                    meanERPelec(iP,:)=mean(elecData,1);
                    clear elecData;
                else % pool TF
                    allElecData(iP,:,:) = elecData;
                end
            end
            if analysisType==1 % pool ERP analysis
                allElecData=mean(meanERPelec,1);
                
                % get the mean ERP trace for the electrodes pooled/single
                if blCorrection == 2 % apply baseline correction
                    blPos = find(timeVals>=blRange(1),1)+ (1:diff(blRange)*params.Fs);
                    meanERP = allElecData-mean(allElecData(:,blPos)); % mean baseline factor subtracted from the ERP signal
                else
                    meanERP = allElecData;
                end
                
                % pooled ERP for the specified electrodes-plots in a new figure
                figure('name','Pooled ERP plot');
                plot(timeVals,meanERP);
                text(0.1,0.9,['ERP; n = ' num2str(size(allElecData,1))],'unit','normalized','fontsize',9);
                text(0.3,0.9,['Electrodes pooled: ' num2str(ERPPoolElecs)],'unit','normalized','fontsize',9);
                if strcmp(gridType,'EEG')
                    text(0.6,0.9,['Reference Scheme: ',refType],'unit','normalized','fontsize',9);
                end
            else % Time Frequency plot for the electrode
                %get the spectral estimate; by default dc baseline correction is
                %not applied to the electrode wise data for TF Plots
                [dsPower,time,freq]=getTFData(Data,params,movingWin,timeVals,blRange);
                
                %plotting the TF freq plot for that electrode/pooled electrode
                figure('name',['TF plot for electrode :',num2str(ERPPoolElecs)]);
                pcolor(time,freq,10*dsPower');
                colormap('jet');ylim([0 100]);colorbar;
                shading('interp');
                text(0.1,0.7,['n = ' num2str(size(allElecData,1))],'fontsize',9);
                text(0.3,1.1,['Electrodes pooled: ' num2str(ERPPoolElecs)],'fontsize',9);
                if strcmp(gridType,'EEG')
                    title(refType);
                end
            end
        catch
            disp('Electrode Index out of bounds; Check the electrode no entered');
        end
    end


% data rereference function- gets the scheme for referencing and changing
% the list of channels accordingly.
    function resetRef_Callback(~,~)
        refChanIndex = get(hRefChannel,'val');
        if refChanIndex == 4 % if the scheme is bipolar , form the bipolar sets
            chanloc = loadChanLocs(capType,refChanIndex);
            no_of_elec=1:size(chanloc,2);
            analogChannelStringList = getStringFromValues(no_of_elec,1);
        else
            analogChannelStringList = getStringFromValues(analogChannelsStored,1);
        end
        set(hAnalogChannel,'String',analogChannelStringList);
    end

% function for clearing the EEG related plots
    function cla_Topoplots_Callback(~,~)
        subplot(capERPRefHandle); cla(gca,'reset'); axis off; % clears the re-ref topoplot
        subplot(capAlphaPowerHandle);cla(gca,'reset');axis off;
        subplot(capGammaPowerHandle);cla(gca,'reset');axis off;
    end

% this function returns the electrode wise data according to the reference
% option chosen; right now common bad trials are used.
    function [Data,chanlocs] = bipolarRef(refChanIndex,plotData)
        
        if refChanIndex == 1 % Single wire referencing
            disp(' working on single wire reference data..');
            chanlocs = loadChanLocs(capType,refChanIndex);%load the channel locations based on the captype
            Data=plotData;
        elseif refChanIndex == 2 % hemisphere referencing
            [chanlocs,hemBipolarLocs] = loadChanLocs(capType,refChanIndex);
            disp(' working on hemisphere referenced data..');
            Data=zeros(size(plotData,1),size(plotData,2),size(plotData,3));
            for iH = 1:size(plotData,1)
                Data(iH,:,:) = plotData(hemBipolarLocs(iH,1),:,:) - plotData(hemBipolarLocs(iH,2),:,:);
            end
            
        elseif refChanIndex == 3 % average referencing
            chanlocs = loadChanLocs(capType,refChanIndex);
            disp(' working on average referenced data..');
            aveData = mean(plotData,1);
            Data=zeros(size(plotData,1),size(plotData,2),size(plotData,3));
            for iH = 1:size(plotData,1)
                Data(iH,:,:) = plotData(iH,:,:) - aveData;
            end
        elseif refChanIndex == 4 % bipolar referencing
            [chanlocs,~,bipolarLocs] = loadChanLocs(capType,refChanIndex);
            disp(' working on bipolar referenced data..');
            maxChanKnown = 96; % default set by MD while creating bipolar montage; this might be different for different montages!!
            Data=zeros(size(bipolarLocs,1),size(plotData,2),size(plotData,3));
            for iH = 1:size(bipolarLocs,1)
                chan1 = bipolarLocs(iH,1);
                chan2 = bipolarLocs(iH,2);
                if chan1<(maxChanKnown+1)
                    unipolarChan1 = plotData(chan1,:,:);
                else
                    unipolarChan1 = Data(chan1,:,:);
                end
                if chan2<(maxChanKnown+1)
                    unipolarChan2 = plotData(chan2,:,:);
                else
                    unipolarChan2 = Data(chan2,:,:);
                end
                Data(iH,:,:) = unipolarChan1 - unipolarChan2;
            end
        else
            refChanIndex = refChanIndex-4;
            chanlocs = loadChanLocs(capType,refChanIndex);
            disp(['Rereferencing data wrto electrode :' num2str(refChanIndex)]);
            Data=zeros(size(plotData,1),size(plotData,2),size(plotData,3));
            for iR = 1:size(plotData,1)
                Data(iR,:,:) = plotData(iR,:,:) - plotData(refChanIndex,:,:);
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main function that plots the data
function plotLFPData(plotHandles,channelsStored,goodPos, ...
    folderData,analysisType,timeVals,blCorrection,plotColor,blRange,stRange,gridType,subjectName,ERPRange,params,capERPHandle,capType,MarkBadChanStatus,MarkBadChan)

if isempty(goodPos)
    disp('No entries for this combination..')
else
    Fs = round(1/(timeVals(2)-timeVals(1)));
    blPos = find(timeVals>=blRange(1),1)+ (1:diff(blRange)*Fs);
    stPos = find(timeVals>=stRange(1),1)+ (1:diff(stRange)*Fs);
    
    if analysisType==1 % only for ERP computation
        erpTopo=zeros(length(channelsStored),1);
    end
    
    for i=1:length(channelsStored)
        disp(i)
        channelNum = channelsStored(i);
        
        % get position
        [row,column] = electrodePositionOnGrid(channelNum,gridType,subjectName);
        
        % get Data
        clear data
        data = load(fullfile(folderData ,['elec' num2str(channelNum)]));
        analogData = data.analogData;
        
        %check whether baseline correction has to be done or not
        if blCorrection == 2 % baseline correction
            analogData = analogData - repmat(mean(analogData(:,blPos),2),1,size(analogData,2));
        end
        
        if analysisType == 1        % compute ERP
            erp = mean(analogData(goodPos,:),1); %#ok<*NODEF>
            %  plot the topolots in addition to the single channel ERP's-
            % get the RMS value for the ERP for each channel
            erpPos = find(timeVals>=ERPRange(1),1)+ (1:diff(ERPRange)*Fs);
            % in some datasets the no of channels for which the data is available is
            %less than the total number of channels.To pass this information to
            %topoplot which needs data dimension to be the same as total channels
            if length(channelsStored) ~= max(channelsStored)
                erpTopo(channelNum)=rms(erp(:,erpPos));
            else
                erpTopo(i)=rms(erp(:,erpPos));
            end
            plot(plotHandles(row,column),timeVals,erp,'color',plotColor);
            
        elseif analysisType == 2    % compute Firing rates
            disp('Use plotSpikeData instead of plotLFPData...');
        else
            % For FFT
            
            [FFTBL,xsBL] =mtspectrumc(analogData(goodPos,blPos)',params);
            logMeanFFTBL= log10(mean(FFTBL,2));
            [FFTST,xsST] =mtspectrumc(analogData(goodPos,stPos)',params);
            logMeanFFTST = log10(mean(FFTST,2));
            
            if blCorrection == 2 % baseline correction
                logMeanFFTBL(1)=logMeanFFTBL(2); % amplitude at 0 Hz is zero (or nearly zero) because of subtraction
            end
            
            if analysisType == 3
                plot(plotHandles(row,column),xsBL,logMeanFFTBL,'g');
                hold(plotHandles(row,column),'on');
                plot(plotHandles(row,column),xsST,logMeanFFTST,plotColor);
            end
            
            if analysisType == 4
                if xsBL == xsST %#ok<BDSCI>
                    plot(plotHandles(row,column),xsBL,logMeanFFTST-logMeanFFTBL,'color',plotColor);
                else
                    disp('Choose same baseline and stimulus periods..');
                end
            end
        end
    end
    if analysisType==1 % plot the topolot : default-single reference for EEG and for LFP
        if strcmp(gridType,'EEG')
            if strcmp(capType,'actiCap64')
                load('actiCap64.mat');
            else
                load('brainCap64.mat');
            end
        else
            [~,~,electrodeGridPos]=electrodePositionOnGrid(1,gridType,subjectName);
            chanlocs=electrodeGridPos;
        end
        subplot(capERPHandle);cla(gca,'reset');axis off;colormap(jet);
        if strcmp(gridType,'EEG')
            topoplot(erpTopo,chanlocs,'electrodes','numbers','style','both','drawaxis','off','maplimits','maxmin');
            title(['RMS ERP: ' num2str(ERPRange(1)) ' to ' num2str(ERPRange(2)) ' s' ' (SingleWire)']);
        else %Microelectrode/ECoG
            if MarkBadChanStatus==1 % mark the channels with bad impedance
                disp(['Marking bad channels:' num2str(MarkBadChan), ' in White']);
                for bCh=1:length(MarkBadChan)
                    [row,coloumn]=find(chanlocs==(MarkBadChan(bCh))); % if the chanlocs are zero,they take the color of the figure background
                    chanlocs(row,coloumn)=0;
                    clear row;clear coloumn;
                end
            end
            topoplot(erpTopo,chanlocs,'plotgrid',chanlocs,'electrodes','numbers','style','both','maplimits','maxmin');
        end
        title(['RMS ERP: ' num2str(ERPRange(1)) ' to ' num2str(ERPRange(2)) ' s']); colorbar;
    end
end
end

function [baselineFiringRate,stimulusFiringRate] = plotSpikeData(plotHandles,channelsStored,goodPos, ...
    folderData, timeVals, plotColor, SourceUnitID,holdOnState,blRange,stRange,gridType)

unitColors = ['r','m','y','c','g'];
binWidthMS = 10;

if isempty(goodPos)
    disp('No entries for this combination..')
else
    numChannels = length(channelsStored);
    baselineFiringRate = zeros(1,numChannels);
    stimulusFiringRate = zeros(1,numChannels);
    
    for i=1:numChannels
        %disp(i)
        channelNum = channelsStored(i);
        
        % get position
        [row,column] = electrodePositionOnGrid(channelNum,gridType,subjectName);
        
        clear neuralInfo spikeData
        load([folderData 'elec' num2str(channelNum) '_SID' num2str(SourceUnitID(i))]);
        [psthVals,xs] = psth_SR(spikeData(goodPos),binWidthMS,timeVals(1),timeVals(end));
        
        % Compute the mean firing rates
        blPos = find(xs>=blRange(1),1)+ (1:(diff(blRange))/(binWidthMS/1000));
        stPos = find(xs>=stRange(1),1)+ (1:(diff(stRange))/(binWidthMS/1000));
        
        baselineFiringRate(i) = mean(psthVals(blPos));
        stimulusFiringRate(i) = mean(psthVals(stPos));
        
        if SourceUnitID(i)==0
            plot(plotHandles(row,column),xs,psthVals,'color',plotColor);
        elseif SourceUnitID(i)> 5
            disp('Only plotting upto 6 single units per electrode...')
        else
            plot(plotHandles(row,column),xs,smooth(psthVals),'color',unitColors(SourceUnitID(i)));
        end
        
        if (i<length(channelsStored))
            if channelsStored(i) == channelsStored(i+1)
                disp('hold on...')
                set(plotHandles(row,column),'Nextplot','add');
            else
                if ~holdOnState
                    set(plotHandles(row,column),'Nextplot','replace');
                end
            end
        end
    end
end
end
function yRange = getYLims(plotHandles,channelsStored,gridType,subjectName)

% Initialize
yMin = inf;
yMax = -inf;

for i=1:length(channelsStored)
    channelNum = channelsStored(i);
    % get position
    [row,column] = electrodePositionOnGrid(channelNum,gridType,subjectName);
    
    axis(plotHandles(row,column),'tight');
    tmpAxisVals = axis(plotHandles(row,column));
    if tmpAxisVals(3) < yMin
        yMin = tmpAxisVals(3);
    end
    if tmpAxisVals(4) > yMax
        yMax = tmpAxisVals(4);
    end
end
yRange = [yMin yMax];
end
function rescaleData(plotHandles,channelsStored,axisLims,gridType,subjectName)

[numRows,numCols] = size(plotHandles);
labelSize=12;
for i=1:length(channelsStored)
    channelNum = channelsStored(i);
    % get position
    [row,column] = electrodePositionOnGrid(channelNum,gridType,subjectName);
    
    axis(plotHandles(row,column),axisLims);
    if (row==numRows && rem(column,2)==1)
        if column~=1
            set(plotHandles(row,column),'YTickLabel',[],'fontSize',labelSize);
        end
    elseif (rem(row,2)==0 && column==1)
        set(plotHandles(row,column),'XTickLabel',[],'fontSize',labelSize);
    else
        set(plotHandles(row,column),'XTickLabel',[],'YTickLabel',[],'fontSize',labelSize);
    end
end

% Remove Labels on the four corners
set(plotHandles(1,1),'XTickLabel',[],'YTickLabel',[]);
set(plotHandles(1,numCols),'XTickLabel',[],'YTickLabel',[]);
set(plotHandles(numRows,1),'XTickLabel',[],'YTickLabel',[]);
set(plotHandles(numRows,numCols),'XTickLabel',[],'YTickLabel',[]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function contrastString = getContrastString(cIndexValsUnique,stimResults)
if isfield(stimResults,'contrast0PC')
    [cVals0Unique,cVals1Unique] = getValsFromIndex(cIndexValsUnique,stimResults,'contrast');
    if length(cVals0Unique)==1
        contrastString = [num2str(cVals0Unique) ',' num2str(cVals1Unique)];
    else
        contrastString = '';
        for i=1:length(cVals0Unique)
            contrastString = cat(2,contrastString,[num2str(cVals0Unique(i)) ',' num2str(cVals1Unique(i)) '|']);
        end
        contrastString = [contrastString 'all'];
    end
    
else % Work with indices
    if length(cIndexValsUnique)==1
        if cIndexValsUnique ==0
            contrastString = '0';
        else
            contrastString = num2str(100/2^(7-cIndexValsUnique));
        end
        
    else
        contrastString = '';
        for i=1:length(cIndexValsUnique)
            if cIndexValsUnique(i) == 0
                contrastString = cat(2,contrastString,[ '0|']); %#ok<*NBRAK>
            else
                contrastString = cat(2,contrastString,[num2str(100/2^(7-cIndexValsUnique(i))) '|']);
            end
        end
        contrastString = [contrastString 'all'];
    end
end
end
function temporalFreqString = getTemporalFreqString(tIndexValsUnique,stimResults)

if isfield(stimResults,'temporalFreq0Hz')
    [tVals0Unique,tVals1Unique] = getValsFromIndex(tIndexValsUnique,stimResults,'temporalFreq');
    if length(tIndexValsUnique)==1
        temporalFreqString = [num2str(tVals0Unique) ',' num2str(tVals1Unique)];
    else
        temporalFreqString = '';
        for i=1:length(tIndexValsUnique)
            temporalFreqString = cat(2,temporalFreqString,[num2str(tVals0Unique(i)) ',' num2str(tVals1Unique(i)) '|']);
        end
        temporalFreqString = [temporalFreqString 'all'];
    end
else
    if length(tIndexValsUnique)==1
        if tIndexValsUnique ==0
            temporalFreqString = '0';
        else
            temporalFreqString = num2str(min(50,80/2^(7-tIndexValsUnique)));
        end
        
    else
        temporalFreqString = '';
        for i=1:length(tIndexValsUnique)
            if tIndexValsUnique(i) == 0
                temporalFreqString = cat(2,temporalFreqString,[ '0|']);
            else
                temporalFreqString = cat(2,temporalFreqString,[num2str(min(50,80/2^(7-tIndexValsUnique(i)))) '|']);
            end
        end
        temporalFreqString = [temporalFreqString 'all'];
    end
end
end
function EOTCodeString = getEOTCodeString(eIndexValsUnique)

if length(eIndexValsUnique)==1
    if eIndexValsUnique == 0
        EOTCodeString = 'Correct';
    elseif eIndexValsUnique == 1
        EOTCodeString = 'Wrong';
    elseif eIndexValsUnique == 2
        EOTCodeString = 'Failed';
    elseif eIndexValsUnique == 3
        EOTCodeString = 'Broke';
    elseif eIndexValsUnique == 4
        EOTCodeString = 'Ignored';
    elseif eIndexValsUnique == 5
        EOTCodeString = 'False Alarm';
    elseif eIndexValsUnique == 6
        EOTCodeString = 'Distracted';
    elseif eIndexValsUnique == 7
        EOTCodeString = 'Force Quit';
    else
        disp('Unknown EOT Code');
    end
else
    EOTCodeString = '';
    for i=1:length(eIndexValsUnique)
        if eIndexValsUnique(i) == 0
            EOTCodeString = cat(2,EOTCodeString,[ 'Correct|']);
        elseif eIndexValsUnique(i) == 1
            EOTCodeString = cat(2,EOTCodeString,[ 'Wrong|']);
        elseif eIndexValsUnique(i) == 2
            EOTCodeString = cat(2,EOTCodeString,[ 'Failed|']);
        elseif eIndexValsUnique(i) == 3
            EOTCodeString = cat(2,EOTCodeString,[ 'Broke|']);
        elseif eIndexValsUnique(i) == 4
            EOTCodeString = cat(2,EOTCodeString,[ 'Ignored|']);
        elseif eIndexValsUnique(i) == 5
            EOTCodeString = cat(2,EOTCodeString,[ 'False Alarm|']);
        elseif eIndexValsUnique(i) == 6
            EOTCodeString = cat(2,EOTCodeString,[ 'Distracted|']);
        elseif eIndexValsUnique(i) == 7
            EOTCodeString = cat(2,EOTCodeString,[ 'Force Quit|']);
        else
            disp('Unknown EOT Code');
        end
    end
    EOTCodeString = [EOTCodeString 'all'];
end
end
function attendLocString = getAttendLocString(aIndexValsUnique)

if length(aIndexValsUnique)==1
    if aIndexValsUnique == 0
        attendLocString = '0 (right)';
    elseif aIndexValsUnique == 1
        attendLocString = '1 (left)';
    else
        disp('Unknown attended location');
    end
else
    attendLocString = '';
    for i=1:length(aIndexValsUnique)
        if aIndexValsUnique(i) == 0
            attendLocString = cat(2,attendLocString,[ '0 (right)|']);
        elseif aIndexValsUnique(i) == 1
            attendLocString = cat(2,attendLocString,[ '1 (left)|']);
        else
            disp('Unknown attended location');
        end
    end
    attendLocString = [attendLocString 'Both'];
end
end
function stimTypeString = getStimTypeString(sIndexValsUnique)

if length(sIndexValsUnique)==1
    if sIndexValsUnique == 0
        stimTypeString = 'Null';
    elseif sIndexValsUnique == 1
        stimTypeString = 'Correct';
    elseif sIndexValsUnique == 2
        stimTypeString = 'Target';
    elseif sIndexValsUnique == 3
        stimTypeString = 'FrontPad';
    elseif sIndexValsUnique == 4
        stimTypeString = 'BackPad';
    else
        disp('Unknown Stimulus Type');
    end
else
    stimTypeString = '';
    for i=1:length(sIndexValsUnique)
        if sIndexValsUnique(i) == 0
            stimTypeString = cat(2,stimTypeString,['Null|']);
        elseif sIndexValsUnique(i) == 1
            stimTypeString = cat(2,stimTypeString,['Correct|']);
        elseif sIndexValsUnique(i) == 2
            stimTypeString = cat(2,stimTypeString,['Target|']);
        elseif sIndexValsUnique(i) == 3
            stimTypeString = cat(2,stimTypeString,['FrontPad|']);
        elseif sIndexValsUnique(i) == 4
            stimTypeString = cat(2,stimTypeString,['BackPad|']);
        else
            disp('Unknown Stimulus Type');
        end
    end
    stimTypeString = [stimTypeString 'all'];
end

end
function [colorString, colorNames] = getColorString

colorNames = 'brkgcmy';
colorString = 'blue|red|black|green|cyan|magenta|yellow';

end
function [valList0Unique,valList1Unique] = getValsFromIndex(indexListUnique,stimResults,fieldName)
if isfield(stimResults,[fieldName 'Index'])
    
    indexList = getfield(stimResults,[fieldName 'Index']); %#ok<*GFLD>
    if strcmpi(fieldName,'contrast')
        valList0 = getfield(stimResults,[fieldName '0PC']);
        valList1 = getfield(stimResults,[fieldName '1PC']);
    else
        valList0 = getfield(stimResults,[fieldName '0Hz']);
        valList1 = getfield(stimResults,[fieldName '1Hz']);
    end
    
    numList = length(indexListUnique);
    valList0Unique = zeros(1,numList);
    valList1Unique = zeros(1,numList);
    for i=1:numList
        valList0Unique(i) = unique(valList0(indexListUnique(i)==indexList));
        valList1Unique(i) = unique(valList1(indexListUnique(i)==indexList));
    end
else
    valList0Unique = indexListUnique;
    valList1Unique = indexListUnique;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load Data
function [analogChannelsStored,timeVals,goodStimPos] = loadlfpInfo(folderLFP) %#ok<*STOUT>
load(fullfile(folderLFP,'lfpInfo.mat'));
end
function [neuralChannelsStored,SourceUnitID] = loadspikeInfo(folderSpikes)
fileName = fullfile(folderSpikes,'spikeInfo.mat');
if exist(fileName,'file')
    load(fileName);
else
    neuralChannelsStored=[];
    SourceUnitID=[];
end
end
function [parameterCombinations,cValsUnique,tValsUnique,eValsUnique,...
    aValsUnique,sValsUnique] = loadParameterCombinations(folderExtract)

load(fullfile(folderExtract,'parameterCombinations.mat'));
end
function stimResults = loadStimResults(folderExtract)
load (fullfile(folderExtract,'stimResults'));
end
function badTrials = loadbadTrials(folderSegment)
try
    load (fullfile(folderSegment,'badTrials.mat'));
catch
    badTrials=[];
end
end
function impedanceValues = loadImpedanceValues(folderImpedance)
try
    load (fullfile(folderImpedance,'impedanceValues.mat'));
catch
    impedanceValues=[];
end
end
% added associate functions- for EEG analysis
% same function as used in displaySingleChannelSRC- To get list of  electrodes
function outString = getStringFromValues(valsUnique,decimationFactor)

if length(valsUnique)==1
    outString = convertNumToStr(valsUnique(1),decimationFactor);
else
    outString='';
    for i=1:length(valsUnique)
        outString = cat(2,outString,[convertNumToStr(valsUnique(i),decimationFactor) '|']);
    end
    outString = [outString 'all'];
end

    function str = convertNumToStr(num,f)
        if num > 16384
            num=num-32768;
        end
        str = num2str(num/f);
    end
end

% to get data from all/specified electrodes for the chosen condition- for the  re referenced topolots
function DataAllElec=getElecDataSRC(goodPos,timeVals,analogChannelsStored,folderLFP,blCorrection,blRange)


% If baseline correction argument is not passed-by default assign it to
% one : getting data to compute pooled ERP where baseline correction is appplied to the pooled electrode data
if ~exist('blCorrection','var')
    blCorrection=1;
end

% Extraction- get the data on all the electrodes first
DataAllElec=zeros(size(analogChannelsStored,2),length(goodPos),length(timeVals));
for iC = 1:size(analogChannelsStored,2)
    analogData = load(fullfile(folderLFP,['elec' num2str(analogChannelsStored(iC)) '.mat']));
    analogData=analogData.analogData;
    if blCorrection==2
        Fs = round(1/(timeVals(2)-timeVals(1)));
        blPos = find(timeVals>=blRange(1),1)+ (1:diff(blRange)*Fs);
        analogData = analogData - repmat(mean(analogData(:,blPos),2),1,size(analogData,2));
    end
    DataAllElec(iC,:,:)=analogData(goodPos,:);
    clear analogData
end
end

% this function returns the Mean ERP value over the chosen time period for every electrode
% specific to EEG; Input data is a re-referenced data
function [erpTopoRef,meanERP] = getERPDataRef(Data,timeVals,blRange,blCorrection,ERPRange)

erpTopoRef=zeros(size(Data,1),1);
meanERP=zeros(1,length(timeVals));
Fs = round(1/(timeVals(2)-timeVals(1)));

for i=1:size(Data,1) %no of channels
    erp = squeeze(mean(Data(i,:,:),2))'; % across the trials
    %check whether baseline correction has to be done or not
    if blCorrection ==2 % baseline correction
        blPos = find(timeVals>=blRange(1),1)+ (1:diff(blRange)*Fs);
        erp=erp-mean(erp(:,blPos));
    end
    %compute the rms of the ERP in the specified range
    erpPos = find(timeVals>=ERPRange(1),1)+ (1:diff(ERPRange)*Fs);
    erpTopoRef(i)=rms(erp(:,erpPos));
end
end


% this function loads the channel location files to be passed to
% topoplots;these locs files are stored in a folder called montages;
% the montages folder is currently stored in the folderSourceString
function [chanlocs,hemBipolarLocs,bipolarLocs] = loadChanLocs(capType,refType)

if nargin<2;    refType = 1; end

if strcmp(capType,'actiCap64')
    if (refType == 4) %bipolar
        load('bipolarChanlocsActiCap64.mat');
        chanlocs = eloc;
    else
        load('actiCap64.mat');
    end
    load('hemBipChInfoActiCap_64.mat');
    load('bipChInfoActiCap64.mat');
    
else % passive cap
    if (refType == 4)
        % have to generate the bipolar montage file for passive cap
        disp('Channel location file for passive cap has not been generated. Using the actiCap configuration instead');
        load('bipolarChanlocsActiCap64.mat');
        chanlocs = eloc;
    else
        load('brainCap64.mat');
    end
end
end

%computing change in power for LFP/ECoG and single reference EEG datasets
function [gammaPower,alphaPower]=getChangeInPowerData(goodPos,analogChannelsStored,folderData,timeVals,blCorrection,blRange,stRange,alphaRange,freqRange,params,badFreqPosType)

gammaPower=zeros(length(analogChannelsStored),1);
alphaPower=zeros(length(analogChannelsStored),1);
Fs = params.Fs;
blPos = find(timeVals>=blRange(1),1)+ (1:diff(blRange)*Fs);
stPos=find(timeVals>=stRange(1),1)+ (1:diff(stRange)*Fs);

if length(blPos) ~= length(stPos)
    disp('Choose same baseline and stimulus periods..');
end

for i=1:length(analogChannelsStored)
    disp(i)
    channelNum = analogChannelsStored(i);
    
    % get Data
    clear data
    data = load(fullfile(folderData ,['elec' num2str(channelNum)]));
    analogData = data.analogData;
    
    %check whether baseline correction has to be done or not
    if blCorrection == 2 % baseline correction
        analogData = analogData - repmat(mean(analogData(:,blPos),2),1,size(analogData,2));
    end
    
    % For FFT
    if i==1
        [FFTBL,freq] =mtspectrumc(analogData(goodPos,blPos)',params);
        badFreqPos=getBadFreqPos(freq,badFreqPosType);
        freqPos= setdiff(intersect((find(freq>=freqRange(1))),find((freq<=freqRange(2)))),badFreqPos);
        alphaPos=intersect((find(freq>=alphaRange(1))),find((freq<=alphaRange(2))));
    else
        [FFTBL,~] =mtspectrumc(analogData(goodPos,blPos)',params);
    end
    blPower= log10(mean(FFTBL,2));
    FFTST =mtspectrumc(analogData(goodPos,stPos)',params);
    stPower = log10(mean(FFTST,2));
    
    if blCorrection == 2 % baseline correction
        blPower(1)=blPower(2); % amplitude at 0 Hz is zero because of subtraction
    end
    % Change in power-
    dsPower=stPower- blPower;
    
    % for any specified frequency band : averaging across the band of frequencies
    if length(analogChannelsStored) ~= max(analogChannelsStored) % to address the cases where the data is avaiable only for few good electrodes : Eg; Abu's ECoG Data
        gammaPower(analogChannelsStored(i))=mean(dsPower(freqPos));
        alphaPower(analogChannelsStored(i)) = mean(dsPower(alphaPos));
    else
        gammaPower(i) = mean(dsPower(freqPos));
        alphaPower(i) = mean(dsPower(alphaPos));
    end
end
end

% change in power in the specified bands - for referenced datasets
% specific to EEG datasets;
function [gammaPower,alphaPower]=getChangeInPowerTopoData_ReRef(Data,params,timeVals,blRange,stRange,alphaRange,freqRange,blCorrection,badFreqPosType)

gammaPower=zeros(size(Data,1),1);
alphaPower=zeros(size(Data,1),1);
Fs = params.Fs;
blPos = find(timeVals>=blRange(1),1)+ (1:diff(blRange)*Fs);
stPos=find(timeVals>=stRange(1),1)+ (1:diff(stRange)*Fs);
if length(blPos) ~= length(stPos)
    disp('Choose same baseline and stimulus periods..');
end
[~,freq]=mtspectrumc((squeeze(Data(1,:,stPos)))',params); % getting the freq axis. Assuming that baseline and stimulus period is the same;
badFreqPos=getBadFreqPos(freq,badFreqPosType);
freqPos= setdiff(intersect((find(freq>=freqRange(1))),find((freq<=freqRange(2)))),badFreqPos);
alphaPos=intersect((find(freq>=alphaRange(1))),find((freq<=alphaRange(2))));

for i=1:size(Data,1) % for each electrode
    dataElec=squeeze(Data(i,:,:));
    [stPower,~]=mtspectrumc((dataElec(:,stPos))',params);
    [blPower,~]=mtspectrumc((dataElec(:,blPos))',params);
    if blCorrection==2
        blPower(1)=blPower(2);
    end
    dsPower=log10(stPower)- log10(blPower); % Change in power-
    % for any specified frequency band : averaging across the band of frequencies
    % assuming data is available for all electrodes
    gammaPower(i) = mean(dsPower(freqPos),1);
    % for alpha band
    alphaPower(i) = mean(dsPower(alphaPos),2);
    disp(i)
end
end

% TF data for single/pooled electrode
function [dsPower,timeValsTF,freq]=  getTFData(Data,params,movingWin,timeVals,blRange)

% Intialising the size of the spectral variables
[~,timeValsTF0,freq]=mtspecgramc(squeeze(Data(1,:,:))',movingWin,params);
timeValsTF = timeValsTF0 + timeVals(1);
blPosTF = intersect(find(timeValsTF>=blRange(1)),find(timeValsTF<blRange(2)));
dsPower=zeros(size(Data,1),length(timeValsTF),length(freq));

for i=1:size(Data,1) % for each electrode
    dataElec=squeeze(Data(i,:,:));
    [SRaw,~,~]=mtspecgramc(dataElec',movingWin,params);
    logBLPower=mean(log10(SRaw(blPosTF,:)),1); % Baseline power in each frequency averaged across time
    dsPower(i,:,:)=log10(SRaw(:,:)) - repmat(logBLPower,size(SRaw,1),1);
end

% mean log spectrum across the pooled electrode for pooled/Single TF analysis
if size(Data,1)==1
    dsPower=squeeze(dsPower);
else
    dsPower=squeeze(mean(dsPower,1));
end
end

% to get titles for the figures- reference type used
function [refType]=getRefschemeName(refChanIndex)
switch(refChanIndex)
    case 1
        refType='Single wire';
    case 2
        refType='Hemisphere';
    case 3
        refType='Average';
    case 4
        refType='Bipolar';
    otherwise
        refType=strcat('Referenced to Electrode- ',num2str(refChanIndex-4));
end
end

% used to remove 50hz/60 hz mains power while computing the change in power
% in a particular band
function badFreqPos = getBadFreqPos(freqVals,badFreqPosType)
if badFreqPosType==1 % 60 hz noise
    badFreqs = 60:60:max(freqVals);
else
    badFreqs = 50:50:max(freqVals); % 50 hz noise
end
deltaF = 1;
badFreqPos = [];
for i=1:length(badFreqs)
    badFreqPos = cat(2,badFreqPos,intersect(find(freqVals>=badFreqs(i)-deltaF),find(freqVals<=badFreqs(i)+deltaF)));
end
end