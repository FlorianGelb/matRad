classdef matRad_OptimizerFunctionPlotter

    properties
        qCallbackSet = false;
        optimizerObject;
    end
    properties(Access=protected)
        axesHandle;
        plotHandle;
        env;
    end



    methods
        function obj = matRad_OptimizerFunctionPlotter(optimizerObject)
            matRad_cfg = MatRad_Config.instance();
            matRad_cfg.dispInfo("Plotter Object invoked");
            obj.optimizerObject = optimizerObject;
            obj.axesHandle = [];
            obj.env = matRad_getEnvironment();
            if ~isdeployed % only if _not_ running as standalone
                switch obj.env
                    case 'MATLAB'
                        try
                            % get handle to Matlab command window
                            mde         = com.mathworks.mde.desk.MLDesktop.getInstance;
                            cw          = mde.getClient('Command Window');
                            xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);
                            h_cw        = handle(xCmdWndView,'CallbackProperties');

                            % set Key Pressed Callback of Matlab command window
                            set(h_cw, 'KeyPressedCallback', @(h,event) obj.abortCallbackKey(h,event));
                            fprintf('Press q to terminate the optimization...\n');
                            obj.qCallbackSet = true;
                        catch
                            matRad_cfg.dispInfo('Manual termination with q not possible due to failing callback setup.\n');
                        end
                end
            end
        end

        function obj = plotFunction(obj, y)
            % plot objective function output
            x = 1:numel(y);

            if isempty(obj.axesHandle) || ~isgraphics(obj.axesHandle,'axes')
                %Create new Fiure and store axes handle
                hFig = figure('Name','Progress of IPOPT Optimization','NumberTitle','off','Color',[.5 .5 .5]);
                hAx = axes(hFig);
                hold(hAx,'on');
                grid(hAx,'on');
                grid(hAx,'minor');
                set(hAx,'YScale','log');

                %Add a Stop button with callback to change abort flag
                c = uicontrol;
                cPos = get(c,'Position');
                cPos(1) = 5;
                cPos(2) = 5;
                set(c,  'String','Stop',...
                    'Position',cPos,...
                    'Callback',@(~,~) abortCallbackButton(obj));

                %Set up the axes scaling & labels
                defaultFontSize = 14;
                set(hAx,'YScale','log');
                title(hAx,'Progress of Optimization','LineWidth',defaultFontSize);
                xlabel(hAx,'# iterations','Fontsize',defaultFontSize),ylabel(hAx,'objective function value','Fontsize',defaultFontSize);

                %Create plot handle and link to data for faster update
                hPlot = plot(hAx,x,y,'xb','LineWidth',1.5,'XDataSource','x','YDataSource','y');
                obj.plotHandle = hPlot;
                obj.axesHandle = hAx;

            else %Figure already exists, retreive from axes handle
                hFig = get(obj.axesHandle,'Parent');
                hAx = obj.axesHandle;
                hPlot = obj.plotHandle;
            end

            % draw updated axes by refreshing data of the plot handle (which is linked to y and y)
            % in the caller workspace. Octave needs and works on figure handles, which
            % is substantially (factor 10) slower, thus we check explicitly
            switch obj.env
                case 'OCTAVE'
                    refreshdata(hFig,'caller');
                otherwise
                    refreshdata(hPlot,'caller');
            end
            drawnow;

            % ensure to bring optimization window to front
            figure(hFig);
        end

        function abortCallbackButton(obj,~,~,~)
            obj.optimizerObject.abortRequested = true;
        end

        function abortCallbackKey(obj,~,KeyEvent)
            % check if user pressed q
            if  get(KeyEvent,'keyCode') == 81
                obj.optimizerObject.abortRequested = true;
                % unset Key Pressed Callback of Matlab command window
                if obj.qCallbackSet
                    set(h_cw, 'KeyPressedCallback',' ');
                end
            end

        end

    end

end