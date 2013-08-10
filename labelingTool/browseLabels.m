function varargout = browseLabels(varargin)
% GUI tool for browsing labeled burst/non-burst times.

% Edit the above text to modify the response to help browseLabels

% Last Modified by GUIDE v2.5 11-Aug-2013 10:37:31

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

function browseLabels_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for browseLabels
    handles.output = hObject;
    
    % set parms from the input
    handles.parms = varargin{1};
    guidata(handles.figureBrowseLabels, handles);
    
    % load labels data
    fname = getLabelsFilename(handles.parms.data.sessionKey, handles.parms.fileSuffix);
    labels = load(fname);
    setappdata(handles.figureBrowseLabels, 'labels', labels);
    
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
            drawRaster(e.hAxes, handles.parms.data, e.times(e.pos), labels)
        end
    end    
end

function setEnabled(h,bEnabled)
    if bEnabled
        set(h,'Enable','on')
    else
        set(h,'Enable','off')
    end
end    

function updatePosition(handles, isBurst, delta)
    iElement = ternary(isBurst,1,2);
    elements = getappdata(handles.figureBrowseLabels, 'elements');
    elements(iElement).pos = elements(iElement).pos + delta;
    setappdata(handles.figureBrowseLabels, 'elements', elements);
    updateGUI(handles)
end

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
