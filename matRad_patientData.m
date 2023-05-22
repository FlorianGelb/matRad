classdef matRad_patientData
    properties 
        ct;
        cst;
        pln;
    end

    methods 
        function obj = matRad_patientData(obj,args)
            matRad_cfg = MatRad_Config.instance();
            matRad_cfg.dispInfo("New patient data object created \n");
        end

        function ct = get_ct(obj)
            ct = obj.ct;
        end

        function cst = get_cst(obj)
            cst = obj.cst;
        end

        function pln = get_pln(obj)
            pln = obj.pln;
        end


        function obj = set.ct(obj, ct)
            obj.ct = ct;
        end

        function obj = set.cst(obj, cst)
            obj.cst = cst;
        end

        function obj = set.pln(obj, pln)
            obj.pln = pln;
        end

    end
end
