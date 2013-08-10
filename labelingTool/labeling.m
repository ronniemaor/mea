function varargout = labeling(varargin)
% GUI tool for collecting labels for supervised learning of which 
% times in the data contain bursts.

% Edit the above text to modify the response to help labeling

% Last Modified by GUIDE v2.5 29-Jul-2013 15:24:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @labeling_OpeningFcn, ...
                   'gui_OutputFcn',  @labeling_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

function labeling_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for labeling
    handles.output = hObject;
    
    % set parms from the input
    handles.parms = varargin{1};
    handles.state = make_parms('yesTimes', [], 'noTimes', []);
    guidata(handles.figureLabeling, handles);

    % only update when the figure is created for the first time
    if strcmp(get(hObject,'Visible'),'off')
        drawNewTime(handles);
    end
end

function varargout = labeling_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;
end

function buttonYes_Callback(hObject, eventdata, handles)
    submitLabel(handles,1)
end

function buttonNo_Callback(hObject, eventdata, handles)
    submitLabel(handles,0)
end

function submitLabel(handles, bYes)
    if bYes
        handles.state.yesTimes = [handles.state.yesTimes handles.state.tStart];
    else
        handles.state.noTimes = [handles.state.noTimes handles.state.tStart];
    end
    guidata(handles.figureLabeling, handles);
    saveLabels(handles.parms,handles.state)
    drawNewTime(handles);
end

function drawNewTime(handles)
    chooser = getappdata(handles.figureLabeling, 'chooser');
    if isempty(chooser)
        chooser = constructChooser(handles.parms);
        setappdata(handles.figureLabeling, 'chooser', chooser);
    end
    tStart = chooser.drawItem();

    drawRaster(handles.axesRaster, handles.parms.data, tStart, handles.parms)
       
    numDone = length(handles.state.yesTimes) + length(handles.state.noTimes);
    set(handles.textSampleNumber, 'String', num2str(numDone))
    
    handles.state.tStart = tStart;
    guidata(handles.figureLabeling, handles);
end

function chooser = constructChooser(parms)
    %fprintf('Constructing chooser\n')
    data = parms.data;
    tHour = 20*60;
    nBins = floor(tHour/parms.T);
    nBuffer = ceil(parms.contextSize);
    nLegalBins = nBins - 2*nBuffer;
    bufferTime = nBuffer * parms.T;
    dt = parms.T * (0:nLegalBins-1);
    
    tMiniBin = 0.05;
    nMiniPerBin = round(parms.T / tMiniBin);
    tMiniBin = parms.T / nMiniPerBin; % make it a whole multiple

    nMiniBins = nLegalBins * nMiniPerBin;
    candidates = [];
    probs = [];
    for iHour = parms.fromHour:(parms.fromHour + parms.nHours - 1);
        tStart = (iHour-1)*tHour + bufferTime;
        tEnd = iHour*tHour - bufferTime;        

        hourCandidates = tStart + dt;
        candidates = [candidates hourCandidates];

        unitActiveMiniBins = zeros(data.nUnits,nMiniBins);
        for iUnit = 1:data.nUnits
            times = data.unitSpikeTimes{iUnit};
            times = times(times > tStart & times <= tEnd) - tStart;
            miniBins = unique(ceil(times/tMiniBin));
            miniBins = miniBins(miniBins <= nMiniBins);
            unitActiveMiniBins(iUnit,miniBins) = 1;
        end
        
        pActivePerMiniBin = sum(unitActiveMiniBins) / data.nUnits;
        maxActivePerBin = max(reshape(pActivePerMiniBin, nMiniPerBin, nLegalBins));
        hourProbs = maxActivePerBin;
        probs = [probs hourProbs];
    end
    fBias = @(p) p^2;
    nBuckets = 25;
    chooser = BiasedChooser(candidates, probs, make_parms('fBias', fBias, 'nBuckets', nBuckets));
end
