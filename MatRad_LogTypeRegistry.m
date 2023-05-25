classdef MatRad_LogTypeRegistry < handle
    properties
        RegisteredLogTypes;
    end

    methods(Access = private)

    end

    methods
        function set.RegisteredLogTypes(obj, logType)
            exists = false;
            try
                obj.getRegisteredLogTypeByName(logType.name);
                exists = true;
            catch ME
                exists = false;
            end
            if ~exists
                if numel(obj.RegisteredLogTypes) == 0
                    obj.RegisteredLogTypes = {logType};
                else
                    obj.RegisteredLogTypes{end+1} = logType;
                end
                
            end
        end

        function logType = getRegisteredLogTypeByName(obj, typeName)
            index = 0;
            for i = 1:numel(obj.RegisteredLogTypes)
                if obj.RegisteredLogTypes{i}.name == typeName
                    index = i;
                    break;
                end
            end

            if index == 0
                exception = MException("Log type " + typeName + " not registered");
                throw(exception);
            end
            logType = obj.RegisteredLogTypes{index};
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