classdef matRad_DoseOptimizationBuilder
    methods (Static)
        % creates an optimization function from a struct
        function obj = createInstanceFromStruct(s)
            try
                %Check vor old version of cst objectives / cosntraints and
                %convert if necessary
                if isfield(s,'type')
                    s = matRad_DoseOptimizationConverter.convertOldOptimizationStruct(s);
                end

                %Create objective / constraint from class name
                obj = eval([s.className '(s)']);

                env = matRad_getEnvironment();

                %Workaround for Octave which has a problem assigning
                %properties in superclass
                if strcmp(env,'OCTAVE')
                    obj = assignCommonPropertiesFromStruct(obj,s);
                end

            catch ME
                error(['Could not instantiate Optimization Function: ' ME.message]);
            end
        end


    end
end