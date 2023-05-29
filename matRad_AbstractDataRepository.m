classdef (Abstract) matRad_AbstractDataRepository < handle
    properties(Access=private)
        patientData = dictionary;
    end

    methods(Abstract)
        [cst, ct] = getPatientDataByName(obj, name)

        loadPatientData(obj, name)
        
        createPatientData(obj, data)
        
        updatePatientData(obj, data)

        deletePatientData(obj, name)

    end
end