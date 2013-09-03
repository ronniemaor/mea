function varargout = browseLabels(varargin)
% GUI tool for browsing labeled burst/non-burst times.

% Edit the above text to modify the response to help browseLabels

% Last Modified by GUIDE v2.5 04-Sep-2013 15:30:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @browseLabels_OpeningFcn, ...
                   'gui_OutputFcn',  @browseLabels_OutputFcn, ...
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function browseLabels_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for browseLabels
    handles.output = hObject;
    
    % set parms from the input
    handles.parms = varargin{1};
    handles.parms.bDrawScore = take_from_struct(handles.parms,'bDrawScore',true);
    set(handles.checkboxShowScore, 'Value',handles.parms.bDrawScore);
    guidata(handles.figureBrowseLabels, handles);
    
    % load labels data
    sessionKey = handles.parms.data.sessionKey;
    fileSuffix = handles.parms.fileSuffix;
    [~,dataFileName] = fileparts(handles.parms.data.dataFile);
    set(handles.textSession,'String',sprintf('Session: %s (%s), Labels: %s', sessionKey, dataFileName, fileSuffix))
    labels = loadLabels(sessionKey, fileSuffix);
    setappdata(handles.figureBrowseLabels, 'labels', labels);
    setappdata(handles.figureBrowseLabels, 'isDirty', false);
    
    elements(1) = make_parms( ...
        'hAxes', handles.axesRasterBurst, ...
        'hPrev', handles.buttonPrevBurst, ...
        'hNext', handles.buttonNextBurst, ...
        'hLabel', handles.textBurstPosition, ...
        'pos', ternary(isempty(labels.yesTimes),NaN,1), ...
        'times', labels.yesTimes ...
    );
    elements(2) = make_parms( ...
        'hAxes', handles.axesRasterNonBurst, ...
        'hPrev', handles.buttonPrevNonBurst, ...
        'hNext', handles.buttonNextNonBurst, ...
        'hLabel', handles.textNonBurstPosition, ...
        'pos', ternary(isempty(labels.noTimes),NaN,1), ...
        'times', labels.noTimes ...
    );
        
    setappdata(handles.figureBrowseLabels, 'elements', elements);

    updateGUI(handles)
end

function varargout = browseLabels_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI Logic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function updateGUI(handles)
    labels = getappdata(handles.figureBrowseLabels, 'labels');
    elements = getappdata(handles.figureBrowseLabels, 'elements');
    
    for iElement = 1:2
        e = elements(iElement);

        % enable/disable buttons
        setEnabled(e.hPrev, e.pos > 1)
        setEnabled(e.hNext, e.pos < length(e.times))
        
        % set position label's text
        txt = ternary(isnan(e.pos), 'N/A', sprintf('%d/%d',e.pos,length(e.times)));
        set(e.hLabel,'String',txt)
        
        % update raster
        if ~isnan(e.pos)
            more_parms = add_parms(handles.parms, ...
                'T', labels.T, ...
                'contextSize', labels.contextSize, ...
                'burstStartTime', labels.burstStartTimes(e.pos), ...
                'burstEndTime', labels.burstEndTimes(e.pos) ...
            );
            drawRaster(e.hAxes, handles.parms.data, e.times(e.pos), more_parms)
        end
    end
    
    isDirty = getappdata(handles.figureBrowseLabels, 'isDirty');
    setEnabled(handles.pushbuttonSave, isDirty)
    
    % plotting removes these callbacks, so we must add them again each time we update the display
    if ~isnan(elements(iElement).pos)
        set(handles.axesRasterBurst,'buttondownfcn',@(hObject,eventdata) axesRasterBurst_ButtonDownFcn(hObject,eventdata,handles))
    end
end

function updatePosition(handles, isBurst, delta)
    iElement = ternary(isBurst,1,2);
    elements = getappdata(handles.figureBrowseLabels, 'elements');
    elements(iElement).pos = elements(iElement).pos + delta;
    setappdata(handles.figureBrowseLabels, 'elements', elements);
    updateGUI(handles)
end

function updateDrawScore(handles, bDrawScore)
    handles.parms.bDrawScore = bDrawScore;
    guidata(handles.figureBrowseLabels, handles);
    updateGUI(handles)
end

function updateBurstStartEnd(handles, time, isStart)
    labels = getappdata(handles.figureBrowseLabels, 'labels');
    elements = getappdata(handles.figureBrowseLabels, 'elements');
    pos = elements(1).pos;
    epsilon = 0.005;

    startTime = labels.burstStartTimes(pos);
    endTime = labels.burstEndTimes(pos);
    if isnan(time)
        startTime = NaN;
        endTime = NaN;
    elseif isStart
        startTime = findNearestSpikeTime(handles.parms.data,time,true) - epsilon;
        if isnan(endTime) || endTime < time
            endTime = startTime + 2*epsilon;
        end
    else % it's an end time
        if startTime < time
            endTime = findNearestSpikeTime(handles.parms.data,time,false) + epsilon;
        end
    end
    labels.burstStartTimes(pos) = startTime;
    labels.burstEndTimes(pos) = endTime;
    
    setappdata(handles.figureBrowseLabels, 'labels', labels);
    setappdata(handles.figureBrowseLabels, 'isDirty', true);
    updateGUI(handles)
end

function saveChanges(handles)
    sessionKey = handles.parms.data.sessionKey;
    suffix = handles.parms.fileSuffix;
    labels = getappdata(handles.figureBrowseLabels, 'labels');
    save(getLabelsFilename(sessionKey,suffix), '-struct', 'labels');
    setappdata(handles.figureBrowseLabels, 'isDirty', false)
    updateGUI(handles)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helpers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function t = findNearestSpikeTime(data,time,isBurstStart)
    spikeTimes = cell2mat(data.unitSpikeTimes');
    if isBurstStart
        t = min(spikeTimes(spikeTimes >= time));
    else
        t = max(spikeTimes(spikeTimes <= time));
    end
end

function setEnabled(h,bEnabled)
    if bEnabled
        set(h,'Enable','on')
    else
        set(h,'Enable','off')
    end
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI Callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function buttonPrevBurst_Callback(hObject, eventdata, handles)
    updatePosition(handles,true,-1);
end

function buttonNextBurst_Callback(hObject, eventdata, handles)
    updatePosition(handles,true,1);
end
    
function buttonPrevNonBurst_Callback(hObject, eventdata, handles)
    updatePosition(handles,false,-1);
end

function buttonNextNonBurst_Callback(hObject, eventdata, handles)
    updatePosition(handles,false,1);
end

function axesRasterBurst_ButtonDownFcn(hObject, eventdata, handles)
    cp = get(gca,'currentpoint');
    time = cp(1,1);
    selectionType = get(handles.figureBrowseLabels,'selectiontype'); % 'normal' (left) or 'alt' (right)
    isLeftButton = isequal(selectionType, 'normal');
    updateBurstStartEnd(handles, time, isLeftButton);
end

function figureBrowseLabels_WindowKeyPressFcn(hObject, eventdata, handles)
    if isequal(eventdata.Key,'delete')
        updateBurstStartEnd(handles, NaN, NaN);
    end
end

function pushbuttonSave_Callback(hObject, eventdata, handles)
    saveChanges(handles);
end

function checkboxShowScore_Callback(hObject, eventdata, handles)
    bChecked = get(handles.checkboxShowScore, 'Value');
    updateDrawScore(handles, bChecked);
end
