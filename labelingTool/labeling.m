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
