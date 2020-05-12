classdef main_v2_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ExperimentcontrolpanelUIFigure  matlab.ui.Figure
        RunButton                       matlab.ui.control.Button
        SaveSwitchLabel                 matlab.ui.control.Label
        SaveSwitch                      matlab.ui.control.Switch
        VIScameraSwitchLabel            matlab.ui.control.Label
        VIScameraSwitch                 matlab.ui.control.Switch
        Lamp                            matlab.ui.control.Lamp
        Lamp_3                          matlab.ui.control.Lamp
        PlayvideosSwitchLabel           matlab.ui.control.Label
        PlayvideosSwitch                matlab.ui.control.Switch
        VideofilesfolderEditFieldLabel  matlab.ui.control.Label
        VideofilesfolderEditField       matlab.ui.control.EditField
        TitleEditFieldLabel             matlab.ui.control.Label
        TitleEditField                  matlab.ui.control.EditField
        FramerateDropDownLabel          matlab.ui.control.Label
        FramerateDropDown               matlab.ui.control.DropDown
        Lamp_4                          matlab.ui.control.Lamp
        LiveviewSwitchLabel             matlab.ui.control.Label
        LiveviewSwitch                  matlab.ui.control.Switch
        InitialblackscreenEditFieldLabel  matlab.ui.control.Label
        InitialblackscreenEditField     matlab.ui.control.NumericEditField
        PausetimeEditFieldLabel         matlab.ui.control.Label
        PausetimeEditField              matlab.ui.control.NumericEditField
        LastblackscreenEditFieldLabel   matlab.ui.control.Label
        LastblackscreenEditField        matlab.ui.control.NumericEditField
        Lamp_5                          matlab.ui.control.Lamp
        ExitButton                      matlab.ui.control.Button
        VerifyVLCfullscreenCheckBox     matlab.ui.control.CheckBox
        SavetimestampCheckBox           matlab.ui.control.CheckBox
        Button_dir                      matlab.ui.control.Button
        ExperimentcontrolpanelLabel     matlab.ui.control.Label
        WrittenbyShaulShvimmerElectroOpticalengineeringMScstudentLabel  matlab.ui.control.Label
        PlaytimeDropDownLabel           matlab.ui.control.Label
        PlaytimeDropDown                matlab.ui.control.DropDown
        IRcameraSwitchLabel             matlab.ui.control.Label
        IRcameraSwitch                  matlab.ui.control.Switch
        Lamp_6                          matlab.ui.control.Lamp
        StopButton                      matlab.ui.control.Button
        PopuppositionEditFieldLabel     matlab.ui.control.Label
        PopuppositionEditField          matlab.ui.control.EditField
        QuestionsPopupCheckBox          matlab.ui.control.CheckBox
        VIScameraLabel                  matlab.ui.control.Label
        VIScameraDropDown               matlab.ui.control.DropDown
        CheckButton                     matlab.ui.control.Button
        VIScameraresolutionLabel        matlab.ui.control.Label
        VIScameraresolutionDropDown     matlab.ui.control.DropDown
        VIScameraRefresh                matlab.ui.control.Button
        Button_crop                     matlab.ui.control.Button
        CroppingcoordinatesEditFieldLabel  matlab.ui.control.Label
        CroppingcoordinatesEditField    matlab.ui.control.EditField
        CropCheckBox                    matlab.ui.control.CheckBox
        StatusLabel                     matlab.ui.control.Label
        Status1                         matlab.ui.control.TextArea
        RGB2grayCheckBox                matlab.ui.control.CheckBox
        TimeLabel_2                     matlab.ui.control.Label
        Status2                         matlab.ui.control.Label
        FolderListBoxLabel              matlab.ui.control.Label
        FolderListBox                   matlab.ui.control.ListBox
        SecLabel                        matlab.ui.control.Label
        PlayerListBoxLabel              matlab.ui.control.Label
        PlayerListBox                   matlab.ui.control.ListBox
        Button_right                    matlab.ui.control.Button
        Button_left                     matlab.ui.control.Button
        Button_refresh_list             matlab.ui.control.Button
        StopafterCheckBox               matlab.ui.control.CheckBox
        EditField_stop                  matlab.ui.control.NumericEditField
        ButtonGroup                     matlab.ui.container.ButtonGroup
        SecondsButton_stop              matlab.ui.control.RadioButton
        FramesButton_stop               matlab.ui.control.RadioButton
        Label                           matlab.ui.control.Label
        WarmupCheckBox                  matlab.ui.control.CheckBox
        EditField_start                 matlab.ui.control.NumericEditField
        ButtonGroup_2                   matlab.ui.container.ButtonGroup
        SecondsButton_start             matlab.ui.control.RadioButton
        FramesButton_start              matlab.ui.control.RadioButton
        Label_2                         matlab.ui.control.Label
        IRcameraasButtonGroup           matlab.ui.container.ButtonGroup
        TemperatureButton               matlab.ui.control.RadioButton
        ColorButton                     matlab.ui.control.RadioButton
        SavewhileblackscreenCheckBoxave  matlab.ui.control.CheckBox
        Button_right_2                  matlab.ui.control.Button
        SetButton                       matlab.ui.control.Button
        DonotrecordonblackscreenCheckBox  matlab.ui.control.CheckBox
        MemoryallocationEditFieldLabel  matlab.ui.control.Label
        MemoryallocationEditField       matlab.ui.control.EditField
        MemoryallocationEditFieldLabel_2  matlab.ui.control.Label
        FramerateLabel                  matlab.ui.control.Label
        FPS_status                      matlab.ui.control.Label
        FPSLabel                        matlab.ui.control.Label
        MemoryallocationEditFieldLabel_3  matlab.ui.control.Label
        MemoryallocationEditFieldLabel_4  matlab.ui.control.Label
        MemoryallocationEditFieldLabel_5  matlab.ui.control.Label
        MemoryallocationEditFieldLabel_6  matlab.ui.control.Label
        RemarksEditFieldLabel           matlab.ui.control.Label
        RemarksEditField                matlab.ui.control.EditField
        ButtonGroup_3                   matlab.ui.container.ButtonGroup
        OrderButton                     matlab.ui.control.RadioButton
        FilenameButton                  matlab.ui.control.RadioButton
        SavevideodatabyLabel            matlab.ui.control.Label
        FlagIRcameraonblackscreenCheckBox  matlab.ui.control.CheckBox
    end

    
    properties (Access = private)
        Property;
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
          %{
            load('lastrunvar','app');
            
            app.TitleEditField.Value = app.Property.title; % file name to be saved
            app.PausetimeEditField.Value = app.Property.pauseTime; % black screen time between videos
            app.LastblackscreenEditField.Value = app.Property.lastBlackScreen; % last black screen duration
            app.VideofilesfolderEditField.Value = app.Property.location;
            app.InitialblackscreenEditField.Value = app.Property.initialBlackScreen; % first black screen duration
            
            app.PlaytimeDropDown.Value = num2str(app.Property.playTime);
            app.FramerateDropDown.Value = num2str(app.Property.constantFrameRate);
            app.SaveSwitch.Value = app.Property.save_data;
            app.VIScameraSwitch.Value = app.Property.VIS_camera;
            app.Property.live_view = app.LiveviewSwitch.Value;
            app.PlayvideosSwitch.Value = app.Property.playVideofiles;
            app.VerifyVLCfullscreenCheckBox.Value = app.Property.verifyFullscreen;
            app.SavetimestampCheckBox.Value = app.Property.timeStamp4savedFile;
            app.DisplayFPSgraphCheckBox.Value = app.Property.dispCWstatus;
            %}
            
            %app.Property.app = app;
            
            app.VIScameraDropDown.Items = webcamlist;

            USB_found = strfind(app.VIScameraDropDown.Items,'USB Capture HDMI');
            
            if find([USB_found{:}] == 1) == 1
                app.VIScameraDropDown.Value = 'USB Capture HDMI';
            end

            value = app.VIScameraDropDown.Value;
            try
                cam = webcam(value);
                res = cam.AvailableResolutions;
                app.VIScameraresolutionDropDown.Items = res;
                clear('cam');
            catch
                app.Status1.FontColor = [0.78,0.09,0.21]; % dark red
                app.Status1.Value = sprintf('%s', 'Error connecting to camera, or no camera connected to your system.');
            end
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            
            if strcmp(app.VIScameraSwitch.Value, 'Off') && strcmp(app.IRcameraSwitch.Value, 'Off')
                
                status(app, 'No camera was selected at all, please select at least one camera.', 'r', 1, 0);
                
                app.Lamp_3.Color = 'g';
                app.Lamp_6.Color = 'g';
                pause(0.125);
                app.Lamp_3.Color = 'r';
                app.Lamp_6.Color = 'r';
                pause(0.125)
                app.Lamp_3.Color = 'g';
                app.Lamp_6.Color = 'g';
                pause(0.125);
                app.Lamp_3.Color = 'r';
                app.Lamp_6.Color = 'r';
                
            elseif strcmp(app.SaveSwitch.Value, 'Off') && strcmp(app.LiveviewSwitch.Value, 'Off')
                
                status(app, 'No live view was selected, or data to be saved, please choose one.', 'r', 1, 0);
                
                app.Lamp.Color = 'g';
                app.Lamp_4.Color = 'g';
                pause(0.125);
                app.Lamp.Color = 'r';
                app.Lamp_4.Color = 'r';
                pause(0.125);
                app.Lamp.Color = 'g';
                app.Lamp_4.Color = 'g';
                pause(0.125);
                app.Lamp.Color = 'r';
                app.Lamp_4.Color = 'r';
                
            elseif isempty(app.CroppingcoordinatesEditField.Value) && app.CropCheckBox.Value == 1
                
                status(app, 'No cropping cordinates provided, please provide.', 'r', 1, 0);
                
                app.CroppingcoordinatesEditField.BackgroundColor = 'r';
                pause(0.125);
                app.CroppingcoordinatesEditField.BackgroundColor = 'w';
                pause(0.125);
                app.CroppingcoordinatesEditField.BackgroundColor = 'r';
                pause(0.125);
                app.CroppingcoordinatesEditField.BackgroundColor = 'w';
                
            elseif strcmp(app.VIScameraDropDown.Value, 'PI IMAGER') && strcmp(app.VIScameraSwitch.Value, 'On')
                
                status(app, 'Cannot choose PI IMAGER as VIS camera, since it is the IR camera.', 'r', 1, 0);
                
                app.VIScameraDropDown.BackgroundColor = 'r';
                pause(0.125);
                app.VIScameraDropDown.BackgroundColor = 'w';
                pause(0.125);
                app.VIScameraDropDown.BackgroundColor = 'r';
                pause(0.125);
                app.VIScameraDropDown.BackgroundColor = 'w';
                
            elseif strcmp(app.PlayvideosSwitch.Value, 'On') && isempty(app.PlayerListBox.Items)
                
                status(app, 'No videos to be played was selected, please add video files to the list.', 'r', 1, 0);
                
                app.PlayerListBox.BackgroundColor = 'r';
                pause(0.125);
                app.PlayerListBox.BackgroundColor = 'w';
                pause(0.125);
                app.PlayerListBox.BackgroundColor = 'r';
                pause(0.125);
                app.PlayerListBox.BackgroundColor = 'w';
                
            else % case everythings OK, prepare to run recorder function
                
                app.RunButton.Enable = 0;
                app.StopButton.Enable = 1;
                app.Status1.Value = ' ';
                app.Status2.Text = ' ';
                
                app.InitialblackscreenEditField.Enable = 0;
                app.InitialblackscreenEditFieldLabel.Enable = 0;
                app.PlaytimeDropDown.Enable = 0;
                app.PlaytimeDropDownLabel.Enable = 0;
                app.PausetimeEditField.Enable = 0;
                app.PausetimeEditFieldLabel.Enable = 0;
                app.LastblackscreenEditField.Enable = 0;
                app.LastblackscreenEditFieldLabel.Enable = 0;
                app.VideofilesfolderEditField.Enable = 0;
                app.VideofilesfolderEditFieldLabel.Enable = 0;
                app.VerifyVLCfullscreenCheckBox.Enable = 0;
                app.Button_dir.Enable = 0;
                app.TitleEditField.Enable = 0;
                app.TitleEditFieldLabel.Enable = 0;
                app.SavetimestampCheckBox.Enable = 0;
                app.MemoryallocationEditField.Enable = 0;
                app.MemoryallocationEditFieldLabel_2.Enable = 0;
                app.MemoryallocationEditFieldLabel.Enable = 0;
                app.RemarksEditField.Enable = 0;
                app.RemarksEditFieldLabel.Enable = 0;
                app.FramerateDropDown.Enable = 0;
                app.FramerateDropDownLabel.Enable = 0;
                app.SaveSwitch.Enable = 0;
                app.PlayvideosSwitch.Enable = 0;
                app.VIScameraSwitch.Enable = 0;
                app.IRcameraSwitch.Enable = 0;
                app.LiveviewSwitch.Enable = 0;
                app.QuestionsPopupCheckBox.Enable = 0;
                app.PopuppositionEditField.Enable = 0;
                app.PopuppositionEditFieldLabel.Enable = 0;
                app.CheckButton.Enable = 0;
                app.SetButton.Enable = 0;
                app.VIScameraDropDown.Enable = 0;
                app.VIScameraLabel.Enable = 0;
                app.VIScameraresolutionDropDown.Enable = 0;
                app.VIScameraresolutionLabel.Enable = 0;
                app.VIScameraRefresh.Enable = 0;
                app.CropCheckBox.Enable = 0;
                app.Button_crop.Enable = 0;
                app.CroppingcoordinatesEditField.Enable = 0;
                app.CroppingcoordinatesEditFieldLabel.Enable = 0;
                app.RGB2grayCheckBox.Enable = 0;
                app.FolderListBox.Enable = 0;
                app.FolderListBoxLabel.Enable = 0;
                app.PlayerListBox.Enable = 0;
                app.PlayerListBoxLabel.Enable = 0;
                app.Button_right.Enable = 0;
                app.Button_right_2.Enable = 0;
                app.Button_left.Enable = 0;
                app.Button_refresh_list.Enable = 0;
                app.StopafterCheckBox.Enable = 0;
                app.EditField_stop.Enable = 0;
                app.SecondsButton_stop.Enable = 0;
                app.FramesButton_stop.Enable = 0;
                app.Label.Enable = 0;
                app.WarmupCheckBox.Enable = 0;
                app.EditField_start.Enable = 0;
                app.SecondsButton_start.Enable = 0;
                app.FramesButton_start.Enable = 0;
                app.Label_2.Enable = 0;
                app.TemperatureButton.Enable = 0;
                app.ColorButton.Enable = 0;
                app.SavewhileblackscreenCheckBoxave.Enable = 0;
                app.OrderButton.Enable = 0;
                app.FilenameButton.Enable = 0;
                app.SavevideodatabyLabel.Enable = 0;
                app.DonotrecordonblackscreenCheckBox.Enable = 0;
                app.MemoryallocationEditFieldLabel_3.Enable = 0;
                app.MemoryallocationEditFieldLabel_4.Enable = 0;
                app.MemoryallocationEditFieldLabel_5.Enable = 0;
                app.MemoryallocationEditFieldLabel_6.Enable = 0;
                app.FlagIRcameraonblackscreenCheckBox.Enable = 0;
                
                app.Property.title = app.TitleEditField.Value; % file name to be saved
                app.Property.pauseTime = app.PausetimeEditField.Value; % black screen time between videos
                app.Property.lastBlackScreen = app.LastblackscreenEditField.Value; % last black screen duration
                app.Property.location = app.VideofilesfolderEditField.Value; % video files location on drive
                app.Property.initialBlackScreen = app.InitialblackscreenEditField.Value; % first black screen duration
                app.Property.camera2connect = app.VIScameraDropDown.Value; % choose VIS camera
                app.Property.exp_remarks = app.RemarksEditField.Value; % get the experiment remarks text
                % Boolean options:
                app.Property.tempORcolor = app.TemperatureButton.Value;
                app.Property.verifyFullscreen = app.VerifyVLCfullscreenCheckBox.Value; 
                app.Property.timeStamp4savedFile = app.SavetimestampCheckBox.Value;
                app.Property.allocation = app.MemoryallocationEditField.Value;
                app.Property.gray = app.RGB2grayCheckBox.Value;
                app.Property.saveONblack = app.SavewhileblackscreenCheckBoxave.Value;
                app.Property.do_not_record_on_black.Value = app.DonotrecordonblackscreenCheckBox.Value;
                app.Property.warm_up = app.WarmupCheckBox.Value;
                app.Property.warm_up_duration = app.EditField_start.Value;
                app.Property.warm_up_unit_sec = app.SecondsButton_start.Value;
                app.Property.stop_after_unit_sec = app.SecondsButton_stop.Value;
                app.Property.stop_after_duration = app.EditField_stop.Value;
                app.Property.stop_after = app.StopafterCheckBox.Value;
                app.Property.questions_popup = app.QuestionsPopupCheckBox.Value;
                app.Property.memory_allocation = app.MemoryallocationEditField.Value;
                app.Property.crop = app.CropCheckBox.Value;
                app.Property.flag_IR_camera_on_black = app.FlagIRcameraonblackscreenCheckBox.Value;

                res_A = str2double(extractAfter(app.VIScameraresolutionDropDown.Value,"x"));
                res_B = str2double(extractBefore(app.VIScameraresolutionDropDown.Value,"x"));
                app.Property.VIS_resolution = [res_A, res_B];
                
                if app.OrderButton.Value == 1
                    app.Property.save_vid_by_order = 1;
                else
                    app.Property.save_vid_by_order = 0;
                end
                
                if app.CropCheckBox.Value == 1
                    app.Property.crop_cor = app.CroppingcoordinatesEditField.Value;
                else
                    app.Property.crop_cor = 0;
                end
                
                if app.WarmupCheckBox.Value == 1
                    app.Property.warm_up = 1;
                    app.Property.warm_up_period = app.EditField_start.Value;
                    if app.SecondsButton_start.Value == 1
                        app.Property.warm_up_seconds = 1;
                    else
                        app.Property.warm_up_seconds = 0;
                    end
                else
                    app.Property.warm_up = 0;
                end
                
                if app.StopafterCheckBox.Value == 1
                    app.Property.force_end = 1;
                    app.Property.force_end_period = app.EditField_stop.Value;
                    if app.SecondsButton_stop.Value == 1
                        app.Property.force_end_seconds = 1;
                    else
                        app.Property.force_end_seconds = 0;
                    end
                else
                    app.Property.force_end = 0;
                end
                
                if strcmp(app.PlaytimeDropDown.Value, 'Auto')
                    app.Property.playTime = 0; % 0 for automatic mode, else enter a value
                else
                    app.Property.playTime = str2double(app.PlaytimeDropDown.Value);
                end
                
                if strcmp(app.FramerateDropDown.Value, 'Max')
                    app.Property.constantFrameRate = 0; % 0 = max recording frame rate possible. else, enter any other positive number
                else
                    app.Property.constantFrameRate = str2double(app.FramerateDropDown.Value); % 0 = max recording frame rate possible. else, enter any other positive number
                end
                
                if strcmp(app.SaveSwitch.Value, 'On')
                    app.Property.save_data = 1; % 1 = yes, 0 = no
                    app.StopButton.Text = 'Save & Stop';
                    app.ExitButton.Text = 'Save & Exit';
                else
                    app.Property.save_data = 0; % 1 = yes, 0 = no
                    app.StopButton.Text = 'Stop';
                    app.ExitButton.Text = 'Exit';
                end
                
                if strcmp(app.VIScameraSwitch.Value, 'On')
                    app.Property.VIS_camera = 1; % 1 = yes, 0 = no
                else
                    app.Property.VIS_camera = 0; % 1 = yes, 0 = no
                end
                
                if strcmp(app.IRcameraSwitch.Value, 'On')
                    app.Property.IR_camera = 1; % 1 = yes, 0 = no
                else
                    app.Property.IR_camera = 0; % 1 = yes, 0 = no
                end
                
                if strcmp(app.LiveviewSwitch.Value, 'On')
                    app.Property.live_view = 1; % 1 = yes, 0 = no
                else
                    app.Property.live_view = 0; % 1 = yes, 0 = no
                end
                
                if strcmp(app.PlayvideosSwitch.Value, 'On')
                    app.Property.playVideofiles = 1; % 1 = yes, 0 = no
                else
                    app.Property.playVideofiles = 0; % 1 = yes, 0 = no
                end

                if app.QuestionsPopupCheckBox.Value == 1
                    app.Property.popup = 1;
                    app.Property.pos = app.PopuppositionEditField.Value; % send popup position
                else
                    app.Property.popup = 0;
                end
                
                % save('lastrunvar','-v7.3','app'); % saves configuration status
                
                recorder(app, app.Property); % calls the recorder function

            end
        end

        % Button pushed function: ExitButton
        function ExitButtonPushed(app, event)
            
            global viewer_is_running;
            viewer_is_running = 0;
            
            closereq
        end

        % Value changed function: SaveSwitch
        function SaveSwitchValueChanged(app, event)
            value = app.SaveSwitch.Value;
            
            if strcmp(value, 'On')
                app.Lamp.Color = 'g';
                app.TitleEditField.Enable = 1;
                app.TitleEditFieldLabel.Enable = 1;
                app.SavetimestampCheckBox.Enable = 1;
                app.MemoryallocationEditField.Enable = 1;
                app.MemoryallocationEditFieldLabel_2.Enable = 1;
                app.MemoryallocationEditFieldLabel.Enable = 1;
                app.RemarksEditField.Enable = 1;
                app.RemarksEditFieldLabel.Enable = 1;
                
                if strcmp(app.PlayvideosSwitch.Value, 'On')
                    
                    if app.DonotrecordonblackscreenCheckBox.Value == 1
                        app.SavewhileblackscreenCheckBoxave.Enable = 1;
                        app.OrderButton.Enable = 1;
                        app.FilenameButton.Enable = 1;
                        app.SavevideodatabyLabel.Enable = 1;
                    end
                    
                    if app.DonotrecordonblackscreenCheckBox.Value == 1 && strcmp(app.IRcameraSwitch.Value, 'On')
                        app.FlagIRcameraonblackscreenCheckBox.Enable = 1;
                    end
                    
                    app.DonotrecordonblackscreenCheckBox.Enable = 1;
                    
                end
                

                
            else
                app.Lamp.Color = 'r';
                app.TitleEditField.Enable = 0;
                app.TitleEditFieldLabel.Enable = 0;
                app.SavetimestampCheckBox.Enable = 0;
                app.MemoryallocationEditField.Enable = 0;
                app.MemoryallocationEditFieldLabel_2.Enable = 0;
                app.MemoryallocationEditFieldLabel.Enable = 0;
                app.SavewhileblackscreenCheckBoxave.Enable = 0;
                app.OrderButton.Enable = 0;
                app.FilenameButton.Enable = 0;
                app.SavevideodatabyLabel.Enable = 0;
                app.DonotrecordonblackscreenCheckBox.Enable = 0;
                app.RemarksEditField.Enable = 0;
                app.RemarksEditFieldLabel.Enable = 0;
                app.FlagIRcameraonblackscreenCheckBox.Enable = 0;
            end
            
        end

        % Callback function
        function SavetimestampSwitchValueChanged(app, event)
            
        end

        % Value changed function: VIScameraSwitch
        function VIScameraSwitchValueChanged(app, event)
            value = app.VIScameraSwitch.Value;
            
            if strcmp(value, 'On')
                app.Lamp_3.Color = 'g';
                app.VIScameraDropDown.Enable = 1;
                app.VIScameraRefresh.Enable = 1;
                app.VIScameraLabel.Enable = 1;
                app.VIScameraresolutionDropDown.Enable = 1;
                app.VIScameraresolutionLabel.Enable = 1;
                app.CropCheckBox.Enable = 1;
                app.RGB2grayCheckBox.Enable = 1;
                
                if app.CropCheckBox.Value == 1
                    app.Button_crop.Enable = 1;
                    app.CroppingcoordinatesEditField.Enable = 1;
                    app.CroppingcoordinatesEditFieldLabel.Enable = 1;
                end
                
            else
                app.Lamp_3.Color = 'r';
                app.VIScameraDropDown.Enable = 0;
                app.VIScameraRefresh.Enable = 0;
                app.VIScameraLabel.Enable = 0;
                app.VIScameraresolutionDropDown.Enable = 0;
                app.VIScameraresolutionLabel.Enable = 0;
                app.CropCheckBox.Enable = 0;
                app.Button_crop.Enable = 0;
                app.CroppingcoordinatesEditField.Enable = 0;
                app.CroppingcoordinatesEditFieldLabel.Enable = 0;
                app.RGB2grayCheckBox.Enable = 0;
            end
            

        end

        % Value changed function: LiveviewSwitch
        function LiveviewSwitchValueChanged(app, event)
            value = app.LiveviewSwitch.Value;
            
            if strcmp(value, 'On')
                app.Lamp_4.Color = 'g';
            else
                app.Lamp_4.Color = 'r';
            end
        end

        % Value changed function: PlayvideosSwitch
        function PlayvideosSwitchValueChanged(app, event)
            value = app.PlayvideosSwitch.Value;
            
            if strcmp(value, 'On')
                app.Lamp_5.Color = 'g';
                app.InitialblackscreenEditField.Enable = 1;
                app.InitialblackscreenEditFieldLabel.Enable = 1;
                app.PlaytimeDropDown.Enable = 1;
                app.PlaytimeDropDownLabel.Enable = 1;
                app.PausetimeEditField.Enable = 1;
                app.PausetimeEditFieldLabel.Enable = 1;
                app.LastblackscreenEditField.Enable = 1;
                app.LastblackscreenEditFieldLabel.Enable = 1;
                app.VideofilesfolderEditField.Enable = 1;
                app.VideofilesfolderEditFieldLabel.Enable = 1;
                app.VerifyVLCfullscreenCheckBox.Enable = 1;
                app.Button_dir.Enable = 1;
                app.QuestionsPopupCheckBox.Enable = 1;
                app.FolderListBox.Enable = 1;
                app.FolderListBoxLabel.Enable = 1;
                app.PlayerListBox.Enable = 1;
                app.PlayerListBoxLabel.Enable = 1;
                app.Button_right.Enable = 1;
                app.Button_right_2.Enable = 1;
                app.Button_left.Enable = 1;
                app.Button_refresh_list.Enable = 1;
                app.MemoryallocationEditFieldLabel_3.Enable = 1;
                app.MemoryallocationEditFieldLabel_4.Enable = 1;
                app.MemoryallocationEditFieldLabel_5.Enable = 1;
                app.MemoryallocationEditFieldLabel_6.Enable = 1;
                
                if app.QuestionsPopupCheckBox.Value == 1
                    app.PopuppositionEditField.Enable = 1;
                    app.PopuppositionEditFieldLabel.Enable = 1;
                    app.CheckButton.Enable = 1;
                    app.SetButton.Enable = 1;
                else
                    app.PopuppositionEditField.Enable = 0;
                    app.PopuppositionEditFieldLabel.Enable = 0;
                    app.CheckButton.Enable = 0;
                    app.SetButton.Enable = 0;
                end
                
                
                if strcmp(app.SaveSwitch.Value, 'On')
                    
                    if app.DonotrecordonblackscreenCheckBox.Value == 1
                        app.SavewhileblackscreenCheckBoxave.Enable = 1;
                        app.OrderButton.Enable = 1;
                        app.FilenameButton.Enable = 1;
                        app.SavevideodatabyLabel.Enable = 1;
                    end
                    
                    if app.DonotrecordonblackscreenCheckBox.Value == 1 && strcmp(app.IRcameraSwitch.Value, 'On')
                        app.FlagIRcameraonblackscreenCheckBox.Enable = 1;
                    end
                    
                    app.DonotrecordonblackscreenCheckBox.Enable = 1;
                    
                end
                
                
            else
                app.Lamp_5.Color = 'r';
                app.InitialblackscreenEditField.Enable = 0;
                app.InitialblackscreenEditFieldLabel.Enable = 0;
                app.PlaytimeDropDown.Enable = 0;
                app.PlaytimeDropDownLabel.Enable = 0;
                app.PausetimeEditField.Enable = 0;
                app.PausetimeEditFieldLabel.Enable = 0;
                app.LastblackscreenEditField.Enable = 0;
                app.LastblackscreenEditFieldLabel.Enable = 0;
                app.VideofilesfolderEditField.Enable = 0;
                app.VideofilesfolderEditFieldLabel.Enable = 0;
                app.VerifyVLCfullscreenCheckBox.Enable = 0;
                app.Button_dir.Enable = 0;
                app.QuestionsPopupCheckBox.Enable = 0;
                app.PopuppositionEditField.Enable = 0;
                app.PopuppositionEditFieldLabel.Enable = 0;
                app.CheckButton.Enable = 0;
                app.SetButton.Enable = 0;
                app.FolderListBox.Enable = 0;
                app.FolderListBoxLabel.Enable = 0;
                app.PlayerListBox.Enable = 0;
                app.PlayerListBoxLabel.Enable = 0;
                app.Button_right.Enable = 0;
                app.Button_right_2.Enable = 0;
                app.Button_left.Enable = 0;
                app.Button_refresh_list.Enable = 0;
                app.SavewhileblackscreenCheckBoxave.Enable = 0;
                app.OrderButton.Enable = 0;
                app.FilenameButton.Enable = 0;
                app.SavevideodatabyLabel.Enable = 0;
                app.DonotrecordonblackscreenCheckBox.Enable = 0;
                app.MemoryallocationEditFieldLabel_3.Enable = 0;
                app.MemoryallocationEditFieldLabel_4.Enable = 0;
                app.MemoryallocationEditFieldLabel_5.Enable = 0;
                app.MemoryallocationEditFieldLabel_6.Enable = 0;
                app.FlagIRcameraonblackscreenCheckBox.Enable = 0;
                
            end
        end

        % Button pushed function: Button_dir
        function Button_dirPushed(app, event)
            try
                
                dname = uigetdir('C:\Users\saul6\Documents\Electrooptical Eng\Thesis\Matlab\Video Recorder\video files\','Select a folder with the video files to be played');
                figure(app.ExperimentcontrolpanelUIFigure); % gets the focus back to the UI window
                app.VideofilesfolderEditField.Value = dname;
            catch
                status(app, 'Error selecting this folder.', 'r', 1, 0);
            end
        end

        % Callback function
        function LoadlastrunButtonPushed(app, event)
           
           
        end

        % Value changed function: IRcameraSwitch
        function IRcameraSwitchValueChanged(app, event)
            value = app.IRcameraSwitch.Value;
            
            if strcmp(value, 'On')
                app.Lamp_6.Color = 'g';
                %app.IRcameraasButtonGroup.Visible
                app.TemperatureButton.Enable = 1;
                app.ColorButton.Enable = 1;

                if strcmp(app.PlayvideosSwitch.Value, 'On') && strcmp(app.SaveSwitch.Value, 'On')
                    app.FlagIRcameraonblackscreenCheckBox.Enable = 1;
                end
                
            else
                app.Lamp_6.Color = 'r';
                app.TemperatureButton.Enable = 0;
                app.ColorButton.Enable = 0;
                app.FlagIRcameraonblackscreenCheckBox.Enable = 0;
            end
        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
            
            app.ExitButton.Text = 'Exit';
            
            app.RunButton.Enable = 1;
            app.StopButton.Enable = 0;
            
            app.FramerateDropDown.Enable = 1;
            app.FramerateDropDownLabel.Enable = 1;
            app.SaveSwitch.Enable = 1;
            app.PlayvideosSwitch.Enable = 1;
            app.VIScameraSwitch.Enable = 1;
            app.IRcameraSwitch.Enable = 1;
            app.LiveviewSwitch.Enable = 1;
            app.StopafterCheckBox.Enable = 1;
            app.WarmupCheckBox.Enable = 1;
            
            if strcmp(app.PlayvideosSwitch.Value, 'On')
                app.InitialblackscreenEditField.Enable = 1;
                app.InitialblackscreenEditFieldLabel.Enable = 1;
                app.PlaytimeDropDown.Enable = 1;
                app.PlaytimeDropDownLabel.Enable = 1;
                app.PausetimeEditField.Enable = 1;
                app.PausetimeEditFieldLabel.Enable = 1;
                app.LastblackscreenEditField.Enable = 1;
                app.LastblackscreenEditFieldLabel.Enable = 1;
                app.VideofilesfolderEditField.Enable = 1;
                app.VideofilesfolderEditFieldLabel.Enable = 1;
                app.VerifyVLCfullscreenCheckBox.Enable = 1;
                app.Button_dir.Enable = 1;
                app.QuestionsPopupCheckBox.Enable = 1;
                app.FolderListBox.Enable = 1;
                app.FolderListBoxLabel.Enable = 1;
                app.PlayerListBox.Enable = 1;
                app.PlayerListBoxLabel.Enable = 1;
                app.Button_right.Enable = 1;
                app.Button_right_2.Enable = 1;
                app.Button_left.Enable = 1;
                app.Button_refresh_list.Enable = 1;
                app.MemoryallocationEditFieldLabel_3.Enable = 1;
                app.MemoryallocationEditFieldLabel_4.Enable = 1;
                app.MemoryallocationEditFieldLabel_5.Enable = 1;
                app.MemoryallocationEditFieldLabel_6.Enable = 1;
                
                if app.QuestionsPopupCheckBox.Value == 1
                    app.PopuppositionEditField.Enable = 1;
                    app.PopuppositionEditFieldLabel.Enable = 1;
                    app.CheckButton.Enable = 1;
                    app.SetButton.Enable = 1;
                end
                
                if strcmp(app.SaveSwitch.Value, 'On')
                    
                    if app.DonotrecordonblackscreenCheckBox.Value == 1
                        app.SavewhileblackscreenCheckBoxave.Enable = 1;
                        app.OrderButton.Enable = 1;
                        app.FilenameButton.Enable = 1;
                        app.SavevideodatabyLabel.Enable = 1;
                    end
                    
                    if app.DonotrecordonblackscreenCheckBox.Value == 1 && strcmp(app.IRcameraSwitch.Value, 'On')
                        app.FlagIRcameraonblackscreenCheckBox.Enable = 1;
                    end
                    
                    app.DonotrecordonblackscreenCheckBox.Enable = 1;
                    
                end
                
            end
            
            if strcmp(app.VIScameraSwitch.Value, 'On')
                app.RGB2grayCheckBox.Enable = 1;
                app.VIScameraDropDown.Enable = 1;
                app.VIScameraLabel.Enable = 1;
                app.VIScameraresolutionDropDown.Enable = 1;
                app.VIScameraresolutionLabel.Enable = 1;
                app.VIScameraRefresh.Enable = 1;
                app.CropCheckBox.Enable = 1;
                
                if app.CropCheckBox.Value == 1
                    app.Button_crop.Enable = 1;
                    app.CroppingcoordinatesEditField.Enable = 1;
                    app.CroppingcoordinatesEditFieldLabel.Enable = 1;
                end
                
            end
            
            if strcmp(app.SaveSwitch.Value, 'On')
                app.TitleEditField.Enable = 1;
                app.TitleEditFieldLabel.Enable = 1;
                app.SavetimestampCheckBox.Enable = 1;
                app.MemoryallocationEditField.Enable = 1;
                app.MemoryallocationEditFieldLabel_2.Enable = 1;
                app.MemoryallocationEditFieldLabel.Enable = 1;
                app.RemarksEditField.Enable = 1;
                app.RemarksEditFieldLabel.Enable = 1;
            end
            
            if strcmp(app.IRcameraSwitch.Value, 'On')
                app.TemperatureButton.Enable = 1;
                app.ColorButton.Enable = 1;
            end
            
            if app.StopafterCheckBox.Value == 1
                app.EditField_stop.Enable = 1;
                app.SecondsButton_stop.Enable = 1;
                app.FramesButton_stop.Enable = 1;
                app.Label.Enable = 1;
            end
            
            if app.WarmupCheckBox.Value == 1
                app.EditField_start.Enable = 1;
                app.SecondsButton_start.Enable = 1;
                app.FramesButton_start.Enable = 1;
                app.Label_2.Enable = 1;
            end
            
            global viewer_is_running;
            viewer_is_running = 0;
            
        end

        % Value changed function: VerifyVLCfullscreenCheckBox
        function VerifyVLCfullscreenCheckBoxValueChanged(app, event)
            
        end

        % Value changed function: QuestionsPopupCheckBox
        function QuestionsPopupCheckBoxValueChanged(app, event)
            value = app.QuestionsPopupCheckBox.Value;
            if value == 1
                app.PopuppositionEditField.Enable = 1;
                app.PopuppositionEditFieldLabel.Enable = 1;
                app.CheckButton.Enable = 1;
                app.SetButton.Enable = 1;
            else
                app.PopuppositionEditField.Enable = 0;
                app.PopuppositionEditFieldLabel.Enable = 0;
                app.CheckButton.Enable = 0;
                app.SetButton.Enable = 0;
            end
        end

        % Button pushed function: CheckButton
        function CheckButtonPushed(app, event)
                       
            if isfield(app.Property,'popup_fig') == 0
                
                app.Property.popup_fig = popup_fig_finder(app, false); % open pop window
                app.Property.popup_fig.Position = str2num(app.PopuppositionEditField.Value); % locate it where it should be
                
            else
                if isfield(app.Property.popup_fig,'Popup_questionsUIFigure') == 0
                    app.Property.popup_fig = popup_fig_finder(app, false); 
                    app.Property.popup_fig.Position = str2num(app.PopuppositionEditField.Value);
                else
                    app.Property.popup_fig.Position = str2num(app.PopuppositionEditField.Value);
                end
                
            end
            
        end

        % Button pushed function: VIScameraRefresh
        function VIScameraRefreshPushed(app, event)
            app.VIScameraDropDown.Items = webcamlist;
        end

        % Value changed function: VIScameraDropDown
        function VIScameraDropDownValueChanged(app, event)
            value = app.VIScameraDropDown.Value;
            try
                cam = webcam(value);
                app.VIScameraresolutionDropDown.Items = cam.AvailableResolutions;
                clear('cam');
            catch
                app.Status1.FontColor = [0.78,0.09,0.21]; % dark red
                app.Status1.Value = sprintf('%s', ['Error connecting to ' value]);
            end
            
        end

        % Button pushed function: Button_crop
        function Button_cropPushed(app, event)
            
            try
                cam = webcam(app.VIScameraDropDown.Value);
                cam.Resolution = app.VIScameraresolutionDropDown.Value;
                frame = snapshot(cam); % get imgage from VIS camera
            catch
                status(app, 'Error connecting to VIS camera.', 'r', 1, 0);
            end
            
            crop_cor = ROIcrop(app, frame);
            app.CroppingcoordinatesEditField.Value = num2str(crop_cor);
        end

        % Value changed function: CropCheckBox
        function CropCheckBoxValueChanged(app, event)
            value = app.CropCheckBox.Value;
            
            if value == 1
               app.Button_crop.Enable = 1;
               app.CroppingcoordinatesEditField.Enable = 1;
               app.CroppingcoordinatesEditFieldLabel.Enable = 1;
            else
               app.Button_crop.Enable = 0;
               app.CroppingcoordinatesEditField.Enable = 0;
               app.CroppingcoordinatesEditFieldLabel.Enable = 0;
            end
            
        end

        % Value changed function: VideofilesfolderEditField
        function VideofilesfolderEditFieldValueChanged(app, event)

            
            
        end

        % Button pushed function: Button_refresh_list
        function Button_refresh_listPushed(app, event)
            try
                app.Property = rmfield(app.Property,'list_name');
                app.Property = rmfield(app.Property,'list_idx');
                app.Property = rmfield(app.Property,'playlist_name');
                app.Property = rmfield(app.Property,'playlist_idx');
            catch
            end
            
            app.FolderListBox.Items = cellstr(' ');
            app.PlayerListBox.Items = cellstr(' ');
            
            value = app.VideofilesfolderEditField.Value; % value is directory location
            app.Property.list = folder2list(app, value); % calling playlist function
            
            [r, c] = size(app.Property.list);
            
            if r == 1 && c == 1 && app.Property.list(1,1) == 0
                app.FolderListBox.Items = cellstr(' ');
                status(app, 'Error loading video files from folder.', 'r', 1, 0);
            else
                
                for i=1:r
                    app.Property.list_name(i) = cellstr(app.Property.list(i).name);
                    app.Property.list_idx(i) = app.Property.list(i).idx;
                end
                
                app.FolderListBox.Items = app.Property.list_name; % name vector
                len = length(app.FolderListBox.Items);
                app.FolderListBox.ItemsData = linspace(1,len,len); % idx vector
                
                status(app, 'Video files folder content loaded successfully.', 'g', 1, 0);
            end
            
            %catch
            %end
            
        end

        % Button pushed function: Button_right
        function Button_rightPushed(app, event)
            value = app.FolderListBox.Value;
            try
                
                if isfield(app.Property,'playlist_name') == 0
                    app.Property.playlist_name = cellstr(app.Property.list_name(value)); % create the vector for the first time
                    app.Property.playlist_idx = app.Property.list_idx(value);
                else
                    len = length(app.Property.playlist_name);
                    app.Property.playlist_name(len + 1) = cellstr(app.Property.list_name(value)); % add item to the vector
                    app.Property.playlist_idx(len + 1) = app.Property.list_idx(value);
                end
                
                app.PlayerListBox.Items = app.Property.playlist_name;% update list
                len = length(app.PlayerListBox.Items);
                app.PlayerListBox.ItemsData = linspace(1,len,len);
                                
            catch
            end
            
        end

        % Button pushed function: Button_left
        function Button_leftPushed(app, event)
            value = app.PlayerListBox.Value;

            try
                
                if isempty(app.Property.playlist_name) == 0
                    len = length(app.Property.playlist_name);
                    
                    for i=0:len-value-1
                        app.Property.playlist_name(value + i) = app.Property.playlist_name(value + 1 + i); % move items up one by one
                        app.Property.playlist_idx(value + i) = app.Property.playlist_idx(value + 1 + i);
                    end
                    
                    app.Property.playlist_name(len) = []; % remove last item
                    app.Property.playlist_idx(len) = [];
                    
                end
                
                app.PlayerListBox.Items = app.Property.playlist_name; % update list
                len = length(app.PlayerListBox.Items);
                app.PlayerListBox.ItemsData = linspace(1,len,len);
                
            catch
            end
            
        end

        % Value changed function: StopafterCheckBox
        function StopafterCheckBoxValueChanged(app, event)
            value = app.StopafterCheckBox.Value;
            
            if value == 1
                app.EditField_stop.Enable = 1;
                app.SecondsButton_stop.Enable = 1;
                app.FramesButton_stop.Enable = 1;
                app.Label.Enable = 1;
            else
                app.EditField_stop.Enable = 0;
                app.SecondsButton_stop.Enable = 0;
                app.FramesButton_stop.Enable = 0;
                app.Label.Enable = 0;
            end
            
        end

        % Value changed function: WarmupCheckBox
        function WarmupCheckBoxValueChanged(app, event)
            value = app.WarmupCheckBox.Value;
                        
            if value == 1
                app.EditField_start.Enable = 1;
                app.SecondsButton_start.Enable = 1;
                app.FramesButton_start.Enable = 1;
                app.Label_2.Enable = 1;
            else
                app.EditField_start.Enable = 0;
                app.SecondsButton_start.Enable = 0;
                app.FramesButton_start.Enable = 0;
                app.Label_2.Enable = 0;
            end
        end

        % Button pushed function: Button_right_2
        function Button_right_2Pushed(app, event)

            try
                
                if isfield(app.Property,'playlist_name') == 0
                    app.Property.playlist_name = cellstr(app.Property.list_name); % create the vector for the first time
                    app.Property.playlist_idx = app.Property.list_idx;
                else
                    len = length(app.Property.playlist_name);
                    len2 = length(app.Property.list_name);
                    
                    app.Property.playlist_name(len + 1:len + len2) = cellstr(app.Property.list_name); % add item to the vector
                    app.Property.playlist_idx(len + 1:len + len2) = app.Property.list_idx;
                end
                
                app.PlayerListBox.Items = app.Property.playlist_name; % update list
                len = length(app.PlayerListBox.Items);
                app.PlayerListBox.ItemsData = linspace(1,len,len);
                                
            catch
            end
            
            
        end

        % Button pushed function: SetButton
        function SetButtonPushed(app, event)
            
            app.PopuppositionEditField.Value = join(string(app.Property.popup_fig.Position));
            close(app.Property.popup_fig);
            app.Property = rmfield(app.Property,'popup_fig');

        end

        % Value changed function: DonotrecordonblackscreenCheckBox
        function DonotrecordonblackscreenCheckBoxValueChanged(app, event)
            value = app.DonotrecordonblackscreenCheckBox.Value;
            
            if value == 1
                app.SavewhileblackscreenCheckBoxave.Enable = 1;
                app.OrderButton.Enable = 1;
                app.FilenameButton.Enable = 1;
                app.SavevideodatabyLabel.Enable = 1;
                
                if strcmp(app.IRcameraSwitch.Value, 'On')
                    app.FlagIRcameraonblackscreenCheckBox.Enable = 1;
                end
                
            else
                app.SavewhileblackscreenCheckBoxave.Enable = 0;
                app.OrderButton.Enable = 0;
                app.FilenameButton.Enable = 0;
                app.SavevideodatabyLabel.Enable = 0;
                app.FlagIRcameraonblackscreenCheckBox.Enable = 0;
            end
        end

        % Value changed function: FlagIRcameraonblackscreenCheckBox
        function FlagIRcameraonblackscreenCheckBoxValueChanged(app, event)
    
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ExperimentcontrolpanelUIFigure and hide until all components are created
            app.ExperimentcontrolpanelUIFigure = uifigure('Visible', 'off');
            app.ExperimentcontrolpanelUIFigure.Position = [600 100 779 752];
            app.ExperimentcontrolpanelUIFigure.Name = 'Experiment control panel';
            app.ExperimentcontrolpanelUIFigure.Scrollable = 'on';

            % Create RunButton
            app.RunButton = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.Position = [130 39 100 33];
            app.RunButton.Text = 'Run';

            % Create SaveSwitchLabel
            app.SaveSwitchLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.SaveSwitchLabel.HorizontalAlignment = 'center';
            app.SaveSwitchLabel.Position = [67 699 33 22];
            app.SaveSwitchLabel.Text = 'Save';

            % Create SaveSwitch
            app.SaveSwitch = uiswitch(app.ExperimentcontrolpanelUIFigure, 'slider');
            app.SaveSwitch.ValueChangedFcn = createCallbackFcn(app, @SaveSwitchValueChanged, true);
            app.SaveSwitch.Position = [143 701 45 20];

            % Create VIScameraSwitchLabel
            app.VIScameraSwitchLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.VIScameraSwitchLabel.HorizontalAlignment = 'center';
            app.VIScameraSwitchLabel.Position = [26 664 68 22];
            app.VIScameraSwitchLabel.Text = 'VIS camera';

            % Create VIScameraSwitch
            app.VIScameraSwitch = uiswitch(app.ExperimentcontrolpanelUIFigure, 'slider');
            app.VIScameraSwitch.ValueChangedFcn = createCallbackFcn(app, @VIScameraSwitchValueChanged, true);
            app.VIScameraSwitch.Position = [141 667 45 20];
            app.VIScameraSwitch.Value = 'On';

            % Create Lamp
            app.Lamp = uilamp(app.ExperimentcontrolpanelUIFigure);
            app.Lamp.Position = [221 704 20 20];
            app.Lamp.Color = [1 0 0];

            % Create Lamp_3
            app.Lamp_3 = uilamp(app.ExperimentcontrolpanelUIFigure);
            app.Lamp_3.Position = [221 670 20 20];

            % Create PlayvideosSwitchLabel
            app.PlayvideosSwitchLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.PlayvideosSwitchLabel.HorizontalAlignment = 'center';
            app.PlayvideosSwitchLabel.Position = [33 556 67 22];
            app.PlayvideosSwitchLabel.Text = 'Play videos';

            % Create PlayvideosSwitch
            app.PlayvideosSwitch = uiswitch(app.ExperimentcontrolpanelUIFigure, 'slider');
            app.PlayvideosSwitch.ValueChangedFcn = createCallbackFcn(app, @PlayvideosSwitchValueChanged, true);
            app.PlayvideosSwitch.Position = [141 560 45 20];

            % Create VideofilesfolderEditFieldLabel
            app.VideofilesfolderEditFieldLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.VideofilesfolderEditFieldLabel.HorizontalAlignment = 'right';
            app.VideofilesfolderEditFieldLabel.Enable = 'off';
            app.VideofilesfolderEditFieldLabel.Position = [33 376 97 22];
            app.VideofilesfolderEditFieldLabel.Text = 'Video files folder:';

            % Create VideofilesfolderEditField
            app.VideofilesfolderEditField = uieditfield(app.ExperimentcontrolpanelUIFigure, 'text');
            app.VideofilesfolderEditField.ValueChangedFcn = createCallbackFcn(app, @VideofilesfolderEditFieldValueChanged, true);
            app.VideofilesfolderEditField.Enable = 'off';
            app.VideofilesfolderEditField.Position = [143 376 564 22];
            app.VideofilesfolderEditField.Value = 'C:\Users\saul6\Documents\Electrooptical Eng\Thesis\Matlab\Record and Analayze\video files';

            % Create TitleEditFieldLabel
            app.TitleEditFieldLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.TitleEditFieldLabel.HorizontalAlignment = 'right';
            app.TitleEditFieldLabel.Enable = 'off';
            app.TitleEditFieldLabel.Position = [262 695 31 22];
            app.TitleEditFieldLabel.Text = 'Title:';

            % Create TitleEditField
            app.TitleEditField = uieditfield(app.ExperimentcontrolpanelUIFigure, 'text');
            app.TitleEditField.Enable = 'off';
            app.TitleEditField.Position = [345 695 211 22];
            app.TitleEditField.Value = 'Experiment name goes here';

            % Create FramerateDropDownLabel
            app.FramerateDropDownLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.FramerateDropDownLabel.HorizontalAlignment = 'right';
            app.FramerateDropDownLabel.Position = [625 653 68 22];
            app.FramerateDropDownLabel.Text = 'Frame rate:';

            % Create FramerateDropDown
            app.FramerateDropDown = uidropdown(app.ExperimentcontrolpanelUIFigure);
            app.FramerateDropDown.Items = {'Max', ''};
            app.FramerateDropDown.Editable = 'on';
            app.FramerateDropDown.BackgroundColor = [1 1 1];
            app.FramerateDropDown.Position = [697 653 66 22];
            app.FramerateDropDown.Value = 'Max';

            % Create Lamp_4
            app.Lamp_4 = uilamp(app.ExperimentcontrolpanelUIFigure);
            app.Lamp_4.Position = [221 600 20 20];

            % Create LiveviewSwitchLabel
            app.LiveviewSwitchLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.LiveviewSwitchLabel.HorizontalAlignment = 'center';
            app.LiveviewSwitchLabel.Position = [39 594 55 22];
            app.LiveviewSwitchLabel.Text = 'Live view';

            % Create LiveviewSwitch
            app.LiveviewSwitch = uiswitch(app.ExperimentcontrolpanelUIFigure, 'slider');
            app.LiveviewSwitch.ValueChangedFcn = createCallbackFcn(app, @LiveviewSwitchValueChanged, true);
            app.LiveviewSwitch.Position = [141 595 45 20];
            app.LiveviewSwitch.Value = 'On';

            % Create InitialblackscreenEditFieldLabel
            app.InitialblackscreenEditFieldLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.InitialblackscreenEditFieldLabel.HorizontalAlignment = 'right';
            app.InitialblackscreenEditFieldLabel.Enable = 'off';
            app.InitialblackscreenEditFieldLabel.Position = [54 291 108 22];
            app.InitialblackscreenEditFieldLabel.Text = 'Initial black screen:';

            % Create InitialblackscreenEditField
            app.InitialblackscreenEditField = uieditfield(app.ExperimentcontrolpanelUIFigure, 'numeric');
            app.InitialblackscreenEditField.HorizontalAlignment = 'left';
            app.InitialblackscreenEditField.Enable = 'off';
            app.InitialblackscreenEditField.Position = [170 291 68 22];

            % Create PausetimeEditFieldLabel
            app.PausetimeEditFieldLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.PausetimeEditFieldLabel.HorizontalAlignment = 'right';
            app.PausetimeEditFieldLabel.Enable = 'off';
            app.PausetimeEditFieldLabel.Position = [55 226 69 22];
            app.PausetimeEditFieldLabel.Text = 'Pause time:';

            % Create PausetimeEditField
            app.PausetimeEditField = uieditfield(app.ExperimentcontrolpanelUIFigure, 'numeric');
            app.PausetimeEditField.HorizontalAlignment = 'left';
            app.PausetimeEditField.Enable = 'off';
            app.PausetimeEditField.Position = [170 226 68 22];

            % Create LastblackscreenEditFieldLabel
            app.LastblackscreenEditFieldLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.LastblackscreenEditFieldLabel.HorizontalAlignment = 'right';
            app.LastblackscreenEditFieldLabel.Enable = 'off';
            app.LastblackscreenEditFieldLabel.Position = [55 195 99 22];
            app.LastblackscreenEditFieldLabel.Text = 'Last black screen';

            % Create LastblackscreenEditField
            app.LastblackscreenEditField = uieditfield(app.ExperimentcontrolpanelUIFigure, 'numeric');
            app.LastblackscreenEditField.HorizontalAlignment = 'left';
            app.LastblackscreenEditField.Enable = 'off';
            app.LastblackscreenEditField.Position = [170 195 68 22];

            % Create Lamp_5
            app.Lamp_5 = uilamp(app.ExperimentcontrolpanelUIFigure);
            app.Lamp_5.Position = [221 564 20 20];
            app.Lamp_5.Color = [1 0 0];

            % Create ExitButton
            app.ExitButton = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.ExitButton.ButtonPushedFcn = createCallbackFcn(app, @ExitButtonPushed, true);
            app.ExitButton.Position = [535 39 100 33];
            app.ExitButton.Text = 'Exit';

            % Create VerifyVLCfullscreenCheckBox
            app.VerifyVLCfullscreenCheckBox = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.VerifyVLCfullscreenCheckBox.ValueChangedFcn = createCallbackFcn(app, @VerifyVLCfullscreenCheckBoxValueChanged, true);
            app.VerifyVLCfullscreenCheckBox.Enable = 'off';
            app.VerifyVLCfullscreenCheckBox.Text = 'Verify VLC full screen';
            app.VerifyVLCfullscreenCheckBox.Position = [620 449 137 22];

            % Create SavetimestampCheckBox
            app.SavetimestampCheckBox = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.SavetimestampCheckBox.Enable = 'off';
            app.SavetimestampCheckBox.Text = 'Save time stamp';
            app.SavetimestampCheckBox.Position = [587 695 111 22];

            % Create Button_dir
            app.Button_dir = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.Button_dir.ButtonPushedFcn = createCallbackFcn(app, @Button_dirPushed, true);
            app.Button_dir.Icon = 'foldericon.png';
            app.Button_dir.Enable = 'off';
            app.Button_dir.Position = [723 376 34 22];
            app.Button_dir.Text = '';

            % Create ExperimentcontrolpanelLabel
            app.ExperimentcontrolpanelLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.ExperimentcontrolpanelLabel.FontSize = 14;
            app.ExperimentcontrolpanelLabel.FontWeight = 'bold';
            app.ExperimentcontrolpanelLabel.Position = [296 728 174 22];
            app.ExperimentcontrolpanelLabel.Text = 'Experiment control panel';

            % Create WrittenbyShaulShvimmerElectroOpticalengineeringMScstudentLabel
            app.WrittenbyShaulShvimmerElectroOpticalengineeringMScstudentLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.WrittenbyShaulShvimmerElectroOpticalengineeringMScstudentLabel.HorizontalAlignment = 'center';
            app.WrittenbyShaulShvimmerElectroOpticalengineeringMScstudentLabel.FontColor = [0.651 0.651 0.651];
            app.WrittenbyShaulShvimmerElectroOpticalengineeringMScstudentLabel.Position = [19 7 706 22];
            app.WrittenbyShaulShvimmerElectroOpticalengineeringMScstudentLabel.Text = 'Written in MATLAB 2019b by Shaul Shvimmer, Electro-Optical engineering M.Sc student, saulsh@post.bgu.ac.il';

            % Create PlaytimeDropDownLabel
            app.PlaytimeDropDownLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.PlaytimeDropDownLabel.HorizontalAlignment = 'right';
            app.PlaytimeDropDownLabel.Enable = 'off';
            app.PlaytimeDropDownLabel.Position = [55 259 55 22];
            app.PlaytimeDropDownLabel.Text = 'Play time';

            % Create PlaytimeDropDown
            app.PlaytimeDropDown = uidropdown(app.ExperimentcontrolpanelUIFigure);
            app.PlaytimeDropDown.Items = {'Auto'};
            app.PlaytimeDropDown.Editable = 'on';
            app.PlaytimeDropDown.Enable = 'off';
            app.PlaytimeDropDown.BackgroundColor = [1 1 1];
            app.PlaytimeDropDown.Position = [170 259 68 22];
            app.PlaytimeDropDown.Value = 'Auto';

            % Create IRcameraSwitchLabel
            app.IRcameraSwitchLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.IRcameraSwitchLabel.HorizontalAlignment = 'center';
            app.IRcameraSwitchLabel.Position = [30 629 61 22];
            app.IRcameraSwitchLabel.Text = 'IR camera';

            % Create IRcameraSwitch
            app.IRcameraSwitch = uiswitch(app.ExperimentcontrolpanelUIFigure, 'slider');
            app.IRcameraSwitch.ValueChangedFcn = createCallbackFcn(app, @IRcameraSwitchValueChanged, true);
            app.IRcameraSwitch.Position = [141 632 45 20];
            app.IRcameraSwitch.Value = 'On';

            % Create Lamp_6
            app.Lamp_6 = uilamp(app.ExperimentcontrolpanelUIFigure);
            app.Lamp_6.Position = [221 635 20 20];

            % Create StopButton
            app.StopButton = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.Enable = 'off';
            app.StopButton.Position = [333 39 100 33];
            app.StopButton.Text = 'Stop';

            % Create PopuppositionEditFieldLabel
            app.PopuppositionEditFieldLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.PopuppositionEditFieldLabel.HorizontalAlignment = 'right';
            app.PopuppositionEditFieldLabel.Enable = 'off';
            app.PopuppositionEditFieldLabel.Position = [450 411 92 22];
            app.PopuppositionEditFieldLabel.Text = 'Pop-up position:';

            % Create PopuppositionEditField
            app.PopuppositionEditField = uieditfield(app.ExperimentcontrolpanelUIFigure, 'text');
            app.PopuppositionEditField.Enable = 'off';
            app.PopuppositionEditField.Position = [549 411 106 22];
            app.PopuppositionEditField.Value = '100,460,860,325';

            % Create QuestionsPopupCheckBox
            app.QuestionsPopupCheckBox = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.QuestionsPopupCheckBox.ValueChangedFcn = createCallbackFcn(app, @QuestionsPopupCheckBoxValueChanged, true);
            app.QuestionsPopupCheckBox.Enable = 'off';
            app.QuestionsPopupCheckBox.Text = 'Questions Pop-up';
            app.QuestionsPopupCheckBox.Position = [323 411 117 22];

            % Create VIScameraLabel
            app.VIScameraLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.VIScameraLabel.HorizontalAlignment = 'right';
            app.VIScameraLabel.Position = [258 653 72 22];
            app.VIScameraLabel.Text = 'VIS camera:';

            % Create VIScameraDropDown
            app.VIScameraDropDown = uidropdown(app.ExperimentcontrolpanelUIFigure);
            app.VIScameraDropDown.Items = {};
            app.VIScameraDropDown.ValueChangedFcn = createCallbackFcn(app, @VIScameraDropDownValueChanged, true);
            app.VIScameraDropDown.Position = [345 653 211 22];
            app.VIScameraDropDown.Value = {};

            % Create CheckButton
            app.CheckButton = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.CheckButton.ButtonPushedFcn = createCallbackFcn(app, @CheckButtonPushed, true);
            app.CheckButton.Enable = 'off';
            app.CheckButton.Position = [666 411 44 22];
            app.CheckButton.Text = 'Check';

            % Create VIScameraresolutionLabel
            app.VIScameraresolutionLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.VIScameraresolutionLabel.HorizontalAlignment = 'right';
            app.VIScameraresolutionLabel.Position = [259 612 127 22];
            app.VIScameraresolutionLabel.Text = 'VIS camera resolution:';

            % Create VIScameraresolutionDropDown
            app.VIScameraresolutionDropDown = uidropdown(app.ExperimentcontrolpanelUIFigure);
            app.VIScameraresolutionDropDown.Items = {};
            app.VIScameraresolutionDropDown.Position = [402 612 154 22];
            app.VIScameraresolutionDropDown.Value = {};

            % Create VIScameraRefresh
            app.VIScameraRefresh = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.VIScameraRefresh.ButtonPushedFcn = createCallbackFcn(app, @VIScameraRefreshPushed, true);
            app.VIScameraRefresh.Icon = 'refreshicon.png';
            app.VIScameraRefresh.Position = [565 653 34 22];
            app.VIScameraRefresh.Text = '';

            % Create Button_crop
            app.Button_crop = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.Button_crop.ButtonPushedFcn = createCallbackFcn(app, @Button_cropPushed, true);
            app.Button_crop.Icon = 'cropicon.png';
            app.Button_crop.Enable = 'off';
            app.Button_crop.Position = [606 574 34 21];
            app.Button_crop.Text = '';

            % Create CroppingcoordinatesEditFieldLabel
            app.CroppingcoordinatesEditFieldLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.CroppingcoordinatesEditFieldLabel.HorizontalAlignment = 'right';
            app.CroppingcoordinatesEditFieldLabel.Enable = 'off';
            app.CroppingcoordinatesEditFieldLabel.Position = [324 573 120 22];
            app.CroppingcoordinatesEditFieldLabel.Text = 'Cropping coordinates';

            % Create CroppingcoordinatesEditField
            app.CroppingcoordinatesEditField = uieditfield(app.ExperimentcontrolpanelUIFigure, 'text');
            app.CroppingcoordinatesEditField.Enable = 'off';
            app.CroppingcoordinatesEditField.Position = [459 573 138 22];

            % Create CropCheckBox
            app.CropCheckBox = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.CropCheckBox.ValueChangedFcn = createCallbackFcn(app, @CropCheckBoxValueChanged, true);
            app.CropCheckBox.Text = 'Crop';
            app.CropCheckBox.Position = [269 573 48 22];

            % Create StatusLabel
            app.StatusLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.StatusLabel.HorizontalAlignment = 'right';
            app.StatusLabel.Position = [170 119 43 22];
            app.StatusLabel.Text = 'Status:';

            % Create Status1
            app.Status1 = uitextarea(app.ExperimentcontrolpanelUIFigure);
            app.Status1.FontSize = 14;
            app.Status1.FontWeight = 'bold';
            app.Status1.Position = [220 118 520 24];

            % Create RGB2grayCheckBox
            app.RGB2grayCheckBox = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.RGB2grayCheckBox.Text = 'RGB2gray';
            app.RGB2grayCheckBox.Position = [572 612 78 22];

            % Create TimeLabel_2
            app.TimeLabel_2 = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.TimeLabel_2.Position = [50 119 35 22];
            app.TimeLabel_2.Text = 'Time:';

            % Create Status2
            app.Status2 = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.Status2.HorizontalAlignment = 'center';
            app.Status2.FontSize = 14;
            app.Status2.FontWeight = 'bold';
            app.Status2.Position = [87 119 32 22];
            app.Status2.Text = '';

            % Create FolderListBoxLabel
            app.FolderListBoxLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.FolderListBoxLabel.Enable = 'off';
            app.FolderListBoxLabel.Position = [329 339 70 22];
            app.FolderListBoxLabel.Text = 'Folder:';

            % Create FolderListBox
            app.FolderListBox = uilistbox(app.ExperimentcontrolpanelUIFigure);
            app.FolderListBox.Items = {};
            app.FolderListBox.Enable = 'off';
            app.FolderListBox.Position = [329 197 164 142];
            app.FolderListBox.Value = {};

            % Create SecLabel
            app.SecLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.SecLabel.Position = [131 119 36 22];
            app.SecLabel.Text = '[Sec].';

            % Create PlayerListBoxLabel
            app.PlayerListBoxLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.PlayerListBoxLabel.Enable = 'off';
            app.PlayerListBoxLabel.Position = [581 339 70 22];
            app.PlayerListBoxLabel.Text = 'Player:';

            % Create PlayerListBox
            app.PlayerListBox = uilistbox(app.ExperimentcontrolpanelUIFigure);
            app.PlayerListBox.Items = {};
            app.PlayerListBox.Enable = 'off';
            app.PlayerListBox.Position = [572 197 164 142];
            app.PlayerListBox.Value = {};

            % Create Button_right
            app.Button_right = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.Button_right.ButtonPushedFcn = createCallbackFcn(app, @Button_rightPushed, true);
            app.Button_right.Icon = 'right-arrow-icon.png';
            app.Button_right.Enable = 'off';
            app.Button_right.Position = [512 275 39 25];
            app.Button_right.Text = '';

            % Create Button_left
            app.Button_left = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.Button_left.ButtonPushedFcn = createCallbackFcn(app, @Button_leftPushed, true);
            app.Button_left.Icon = 'left-arrow-icon.png';
            app.Button_left.Enable = 'off';
            app.Button_left.Position = [513 238 38 26];
            app.Button_left.Text = '';

            % Create Button_refresh_list
            app.Button_refresh_list = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.Button_refresh_list.ButtonPushedFcn = createCallbackFcn(app, @Button_refresh_listPushed, true);
            app.Button_refresh_list.Icon = 'refreshicon.png';
            app.Button_refresh_list.Enable = 'off';
            app.Button_refresh_list.Position = [513 314 39 27];
            app.Button_refresh_list.Text = '';

            % Create StopafterCheckBox
            app.StopafterCheckBox = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.StopafterCheckBox.ValueChangedFcn = createCallbackFcn(app, @StopafterCheckBoxValueChanged, true);
            app.StopafterCheckBox.Text = 'Stop after:';
            app.StopafterCheckBox.Position = [416 483 77 22];

            % Create EditField_stop
            app.EditField_stop = uieditfield(app.ExperimentcontrolpanelUIFigure, 'numeric');
            app.EditField_stop.HorizontalAlignment = 'center';
            app.EditField_stop.Enable = 'off';
            app.EditField_stop.Position = [496 483 73 22];

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.ExperimentcontrolpanelUIFigure);
            app.ButtonGroup.Position = [579 479 180 30];

            % Create SecondsButton_stop
            app.SecondsButton_stop = uiradiobutton(app.ButtonGroup);
            app.SecondsButton_stop.Enable = 'off';
            app.SecondsButton_stop.Text = 'Seconds';
            app.SecondsButton_stop.Position = [11 3 69 22];
            app.SecondsButton_stop.Value = true;

            % Create FramesButton_stop
            app.FramesButton_stop = uiradiobutton(app.ButtonGroup);
            app.FramesButton_stop.Enable = 'off';
            app.FramesButton_stop.Text = 'Frames';
            app.FramesButton_stop.Position = [109 3 65 22];

            % Create Label
            app.Label = uilabel(app.ButtonGroup);
            app.Label.Enable = 'off';
            app.Label.Position = [89 3 10 22];
            app.Label.Text = '/';

            % Create WarmupCheckBox
            app.WarmupCheckBox = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.WarmupCheckBox.ValueChangedFcn = createCallbackFcn(app, @WarmupCheckBoxValueChanged, true);
            app.WarmupCheckBox.Text = 'Warm up:';
            app.WarmupCheckBox.Position = [30 484 74 22];

            % Create EditField_start
            app.EditField_start = uieditfield(app.ExperimentcontrolpanelUIFigure, 'numeric');
            app.EditField_start.HorizontalAlignment = 'center';
            app.EditField_start.Enable = 'off';
            app.EditField_start.Position = [110 484 73 22];
            app.EditField_start.Value = 30;

            % Create ButtonGroup_2
            app.ButtonGroup_2 = uibuttongroup(app.ExperimentcontrolpanelUIFigure);
            app.ButtonGroup_2.Position = [193 480 180 30];

            % Create SecondsButton_start
            app.SecondsButton_start = uiradiobutton(app.ButtonGroup_2);
            app.SecondsButton_start.Enable = 'off';
            app.SecondsButton_start.Text = 'Seconds';
            app.SecondsButton_start.Position = [11 3 69 22];
            app.SecondsButton_start.Value = true;

            % Create FramesButton_start
            app.FramesButton_start = uiradiobutton(app.ButtonGroup_2);
            app.FramesButton_start.Enable = 'off';
            app.FramesButton_start.Text = 'Frames';
            app.FramesButton_start.Position = [109 3 65 22];

            % Create Label_2
            app.Label_2 = uilabel(app.ButtonGroup_2);
            app.Label_2.Enable = 'off';
            app.Label_2.Position = [89 3 10 22];
            app.Label_2.Text = '/';

            % Create IRcameraasButtonGroup
            app.IRcameraasButtonGroup = uibuttongroup(app.ExperimentcontrolpanelUIFigure);
            app.IRcameraasButtonGroup.TitlePosition = 'centertop';
            app.IRcameraasButtonGroup.Title = 'IR camera as:';
            app.IRcameraasButtonGroup.Position = [665 573 100 72];

            % Create TemperatureButton
            app.TemperatureButton = uiradiobutton(app.IRcameraasButtonGroup);
            app.TemperatureButton.Text = 'Temperature';
            app.TemperatureButton.Position = [7 26 89 22];
            app.TemperatureButton.Value = true;

            % Create ColorButton
            app.ColorButton = uiradiobutton(app.IRcameraasButtonGroup);
            app.ColorButton.Text = 'Color';
            app.ColorButton.Position = [7 4 51 22];

            % Create SavewhileblackscreenCheckBoxave
            app.SavewhileblackscreenCheckBoxave = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.SavewhileblackscreenCheckBoxave.Enable = 'off';
            app.SavewhileblackscreenCheckBoxave.Text = 'Clear RAM while black screen';
            app.SavewhileblackscreenCheckBoxave.Position = [221 449 182 22];
            app.SavewhileblackscreenCheckBoxave.Value = true;

            % Create Button_right_2
            app.Button_right_2 = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.Button_right_2.ButtonPushedFcn = createCallbackFcn(app, @Button_right_2Pushed, true);
            app.Button_right_2.Icon = 'two-right-arrows-icon.png';
            app.Button_right_2.Enable = 'off';
            app.Button_right_2.Position = [512 197 39 25];
            app.Button_right_2.Text = '';

            % Create SetButton
            app.SetButton = uibutton(app.ExperimentcontrolpanelUIFigure, 'push');
            app.SetButton.ButtonPushedFcn = createCallbackFcn(app, @SetButtonPushed, true);
            app.SetButton.Enable = 'off';
            app.SetButton.Position = [719 411 44 22];
            app.SetButton.Text = 'Set';

            % Create DonotrecordonblackscreenCheckBox
            app.DonotrecordonblackscreenCheckBox = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.DonotrecordonblackscreenCheckBox.ValueChangedFcn = createCallbackFcn(app, @DonotrecordonblackscreenCheckBoxValueChanged, true);
            app.DonotrecordonblackscreenCheckBox.Enable = 'off';
            app.DonotrecordonblackscreenCheckBox.Text = 'Do not record on black screen';
            app.DonotrecordonblackscreenCheckBox.Position = [23 449 182 22];
            app.DonotrecordonblackscreenCheckBox.Value = true;

            % Create MemoryallocationEditFieldLabel
            app.MemoryallocationEditFieldLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.MemoryallocationEditFieldLabel.HorizontalAlignment = 'right';
            app.MemoryallocationEditFieldLabel.Enable = 'off';
            app.MemoryallocationEditFieldLabel.Position = [55 322 106 22];
            app.MemoryallocationEditFieldLabel.Text = 'Memory allocation:';

            % Create MemoryallocationEditField
            app.MemoryallocationEditField = uieditfield(app.ExperimentcontrolpanelUIFigure, 'text');
            app.MemoryallocationEditField.Enable = 'off';
            app.MemoryallocationEditField.Position = [170 322 67 22];
            app.MemoryallocationEditField.Value = '1000';

            % Create MemoryallocationEditFieldLabel_2
            app.MemoryallocationEditFieldLabel_2 = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.MemoryallocationEditFieldLabel_2.HorizontalAlignment = 'right';
            app.MemoryallocationEditFieldLabel_2.Enable = 'off';
            app.MemoryallocationEditFieldLabel_2.Position = [247 322 46 22];
            app.MemoryallocationEditFieldLabel_2.Text = 'Frames';

            % Create FramerateLabel
            app.FramerateLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.FramerateLabel.Position = [17 90 68 22];
            app.FramerateLabel.Text = 'Frame rate:';

            % Create FPS_status
            app.FPS_status = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.FPS_status.HorizontalAlignment = 'center';
            app.FPS_status.FontSize = 14;
            app.FPS_status.FontWeight = 'bold';
            app.FPS_status.Position = [87 90 32 22];
            app.FPS_status.Text = '';

            % Create FPSLabel
            app.FPSLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.FPSLabel.Position = [131 90 39 22];
            app.FPSLabel.Text = '[FPS].';

            % Create MemoryallocationEditFieldLabel_3
            app.MemoryallocationEditFieldLabel_3 = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.MemoryallocationEditFieldLabel_3.HorizontalAlignment = 'right';
            app.MemoryallocationEditFieldLabel_3.Enable = 'off';
            app.MemoryallocationEditFieldLabel_3.Position = [248 291 26 22];
            app.MemoryallocationEditFieldLabel_3.Text = 'Sec';

            % Create MemoryallocationEditFieldLabel_4
            app.MemoryallocationEditFieldLabel_4 = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.MemoryallocationEditFieldLabel_4.HorizontalAlignment = 'right';
            app.MemoryallocationEditFieldLabel_4.Enable = 'off';
            app.MemoryallocationEditFieldLabel_4.Position = [248 259 26 22];
            app.MemoryallocationEditFieldLabel_4.Text = 'Sec';

            % Create MemoryallocationEditFieldLabel_5
            app.MemoryallocationEditFieldLabel_5 = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.MemoryallocationEditFieldLabel_5.HorizontalAlignment = 'right';
            app.MemoryallocationEditFieldLabel_5.Enable = 'off';
            app.MemoryallocationEditFieldLabel_5.Position = [247 226 26 22];
            app.MemoryallocationEditFieldLabel_5.Text = 'Sec';

            % Create MemoryallocationEditFieldLabel_6
            app.MemoryallocationEditFieldLabel_6 = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.MemoryallocationEditFieldLabel_6.HorizontalAlignment = 'right';
            app.MemoryallocationEditFieldLabel_6.Enable = 'off';
            app.MemoryallocationEditFieldLabel_6.Position = [249 195 26 22];
            app.MemoryallocationEditFieldLabel_6.Text = 'Sec';

            % Create RemarksEditFieldLabel
            app.RemarksEditFieldLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.RemarksEditFieldLabel.HorizontalAlignment = 'right';
            app.RemarksEditFieldLabel.Enable = 'off';
            app.RemarksEditFieldLabel.Position = [31 522 57 22];
            app.RemarksEditFieldLabel.Text = 'Remarks:';

            % Create RemarksEditField
            app.RemarksEditField = uieditfield(app.ExperimentcontrolpanelUIFigure, 'text');
            app.RemarksEditField.Enable = 'off';
            app.RemarksEditField.Position = [134 522 589 22];

            % Create ButtonGroup_3
            app.ButtonGroup_3 = uibuttongroup(app.ExperimentcontrolpanelUIFigure);
            app.ButtonGroup_3.Position = [143 407 155 30];

            % Create OrderButton
            app.OrderButton = uiradiobutton(app.ButtonGroup_3);
            app.OrderButton.Enable = 'off';
            app.OrderButton.Text = 'Order';
            app.OrderButton.Position = [11 3 58 22];
            app.OrderButton.Value = true;

            % Create FilenameButton
            app.FilenameButton = uiradiobutton(app.ButtonGroup_3);
            app.FilenameButton.Enable = 'off';
            app.FilenameButton.Text = 'File name';
            app.FilenameButton.Position = [77 3 75 22];

            % Create SavevideodatabyLabel
            app.SavevideodatabyLabel = uilabel(app.ExperimentcontrolpanelUIFigure);
            app.SavevideodatabyLabel.Enable = 'off';
            app.SavevideodatabyLabel.Position = [30 410 111 22];
            app.SavevideodatabyLabel.Text = 'Save video data by:';

            % Create FlagIRcameraonblackscreenCheckBox
            app.FlagIRcameraonblackscreenCheckBox = uicheckbox(app.ExperimentcontrolpanelUIFigure);
            app.FlagIRcameraonblackscreenCheckBox.ValueChangedFcn = createCallbackFcn(app, @FlagIRcameraonblackscreenCheckBoxValueChanged, true);
            app.FlagIRcameraonblackscreenCheckBox.Enable = 'off';
            app.FlagIRcameraonblackscreenCheckBox.Text = 'Flag IR camera on black screen';
            app.FlagIRcameraonblackscreenCheckBox.Position = [416 449 192 22];

            % Show the figure after all components are created
            app.ExperimentcontrolpanelUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = main_v2_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.ExperimentcontrolpanelUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ExperimentcontrolpanelUIFigure)
        end
    end
end