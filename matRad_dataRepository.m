classdef matRad_dataRepository < matRad_AbstractDataRepository
    properties(Access=private)
        patientData = dictionary;
        config;
    end

    methods
        function obj = matRad_dataRepository(obj)
            obj.config = MatRad_Config.instance();
        end

        function [cst, ct] = getPatientDataByName(obj, name)

            try
                data = obj.patientData(name);
                cst = data.cst;
                ct = data.ct;
            catch
                MException(" " + name + " was not found.")
            end

        end

        function loadPatientData(obj, name)

            try
                obj.getPatientDataByName(name)
            catch
                try
                    patientDataStruct = load(name);
                    obj.patientData(name) = patientDataStruct;
                catch e
                   obj.config.logWithCustomLogType("error", e.message);
                end
            end
        end


        %% Die folgenden Methoden, zur Umsetzung von CRUD sind nicht
        % sinnvoll implementiert, weil es hier noch keinen praktischen
        % Use-Case gibt. MatRad soll keine persitenten Daten ändern.

        function createPatientData(obj, data)
            obj.config.logWithCustomLogType("info", "created");
        end

        function updatePatientData(obj, data)
            obj.config.logWithCustomLogType("info", "updated");
        end

        function deletePatientData(obj, name)
            obj.config.logWithCustomLogType("info", "deleted");
        end


    end


end