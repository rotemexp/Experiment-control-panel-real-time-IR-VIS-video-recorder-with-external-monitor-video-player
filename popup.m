classdef popup < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        PleaseanswerthefollowingUIFigure  matlab.ui.Figure
        ChooseButtonGroup              matlab.ui.container.ButtonGroup
        Button                         matlab.ui.control.RadioButton
        Button_2                       matlab.ui.control.RadioButton
        Button_3                       matlab.ui.control.RadioButton
        Button_4                       matlab.ui.control.RadioButton
        Button_5                       matlab.ui.control.RadioButton
        OKButton                       matlab.ui.control.Button
        PleaseselectemotionlevelLabel  matlab.ui.control.Label
    end

    
    properties (Access = private)
        %Property % stores the answers
    end
    
    properties (Access = public)
        Property % Description
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            global glb;
            
            try
                app.PleaseanswerthefollowingUIFigure.Position = str2num(glb.pos);    
            catch
                app.PleaseanswerthefollowingUIFigure.Position = [400,500,200,300];
            end
            
        end

        % Button pushed function: OKButton
        function OKButtonPushed(app, event)
            if app.Button.Value == 1
                app.Property.level = 1;
            end
            
            if app.Button_2.Value == 1
                app.Property.level = 2;
            end
                
            if app.Button_3.Value == 1
                app.Property.level = 3;
            end   
            
            if app.Button_4.Value == 1
                app.Property.level = 4;
            end
            
            if app.Button_5.Value == 1
                app.Property.level = 5;
            end
            
            global glb;
            glb.lvl = app.Property.level;
            
            closereq
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create PleaseanswerthefollowingUIFigure
            app.PleaseanswerthefollowingUIFigure = uifigure;
            app.PleaseanswerthefollowingUIFigure.Position = [400 500 200 300];
            app.PleaseanswerthefollowingUIFigure.Name = 'Please answer the following:';

            % Create ChooseButtonGroup
            app.ChooseButtonGroup = uibuttongroup(app.PleaseanswerthefollowingUIFigure);
            app.ChooseButtonGroup.Title = 'Choose';
            app.ChooseButtonGroup.Position = [46 106 100 139];

            % Create Button
            app.Button = uiradiobutton(app.ChooseButtonGroup);
            app.Button.Text = '1';
            app.Button.Position = [11 93 58 22];
            app.Button.Value = true;

            % Create Button_2
            app.Button_2 = uiradiobutton(app.ChooseButtonGroup);
            app.Button_2.Text = '2';
            app.Button_2.Position = [11 71 65 22];

            % Create Button_3
            app.Button_3 = uiradiobutton(app.ChooseButtonGroup);
            app.Button_3.Text = '3';
            app.Button_3.Position = [11 49 65 22];

            % Create Button_4
            app.Button_4 = uiradiobutton(app.ChooseButtonGroup);
            app.Button_4.Text = '4';
            app.Button_4.Position = [11 28 65 22];

            % Create Button_5
            app.Button_5 = uiradiobutton(app.ChooseButtonGroup);
            app.Button_5.Text = '5';
            app.Button_5.Position = [11 7 65 22];

            % Create OKButton
            app.OKButton = uibutton(app.PleaseanswerthefollowingUIFigure, 'push');
            app.OKButton.ButtonPushedFcn = createCallbackFcn(app, @OKButtonPushed, true);
            app.OKButton.Position = [46 57 100 22];
            app.OKButton.Text = 'OK';

            % Create PleaseselectemotionlevelLabel
            app.PleaseselectemotionlevelLabel = uilabel(app.PleaseanswerthefollowingUIFigure);
            app.PleaseselectemotionlevelLabel.Position = [24 261 154 22];
            app.PleaseselectemotionlevelLabel.Text = 'Please select emotion level:';
        end
    end

    methods (Access = public)

        % Construct app
        function app = popup

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.PleaseanswerthefollowingUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.PleaseanswerthefollowingUIFigure)
        end
    end
end