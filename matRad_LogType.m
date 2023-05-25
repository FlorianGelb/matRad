classdef matRad_LogType < handle
    properties
        logLevel;
        name;
        modifiedMessage;
        action;
    end
    methods
        function obj = matRad_LogType(logLevel, name, modifiedMessage, action)
            obj.logLevel = logLevel;
            obj.name = name;
            obj.modifiedMessage = modifiedMessage;
            obj.action = action;
        end

        function logLevel = get.logLevel(obj)
            logLevel = obj.logLevel;
        end

        function name = get.name(obj)
            name = obj.name;
        end

        function modifiedMessage = get.modifiedMessage(obj)
            modifiedMessage = obj.modifiedMessage;
        end

        function action = get.action(obj)
            action = obj.action;
        end
    end
end