classdef MatRad_LogTypeRegistry < handle
    properties
        RegisteredLogTypes;
    end

    methods(Access = private)

        function obj = MatRad_LogTypeRegistry()
            obj.RegisteredLogTypes = {};
        end
    end
    methods
        function set.RegisteredLogTypes(obj, logType)
            obj.RegisteredLogTypes{end+1} = logType;
        end

        function logType = getRegisteredLogTypeByName(obj, name)
            index = find(equals([obj.RegisteredLogTypes{:}.name], name));
            logType = obj.RegisteredLogTypes(index);
        end

    end

    methods(Static)


        function obj = instance()
            % Copied from MatRad_Config
            % Singelton Implementation

            persistent uniqueInstance;

            if isempty(uniqueInstance)
                obj = MatRad_LogTypeRegistry();
                uniqueInstance = obj;
            else
                obj = uniqueInstance;
            end
        end
    end
end