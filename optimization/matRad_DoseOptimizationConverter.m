classdef matRad_DoseOptimizationConverter
    methods(Static)
        function s = convertOldOptimizationStruct(old_s)
            %Converts old version obejctives to current format
            switch old_s.type
                %Objectives
                case 'square deviation'
                    s.className = 'DoseObjectives.matRad_SquaredDeviation';
                    s.penalty = old_s.penalty;
                    s.parameters{1} = old_s.dose;

                case 'square overdosing'
                    s.className = 'DoseObjectives.matRad_SquaredOverdosing';
                    s.penalty = old_s.penalty;
                    s.parameters{1} = old_s.dose;

                case 'square underdosing'
                    s.className = 'DoseObjectives.matRad_SquaredUnderdosing';
                    s.penalty = old_s.penalty;
                    s.parameters{1} = old_s.dose;

                case 'min DVH objective'
                    s.className = 'DoseObjectives.matRad_MinDVH';
                    s.parameters{1} = old_s.dose;
                    s.parameters{2} = old_s.volume;

                case 'max DVH objective'
                    s.className = 'DoseObjectives.matRad_MaxDVH';
                    s.parameters{1} = old_s.dose;
                    s.parameters{2} = old_s.volume;

                case 'mean'
                    s.className = 'DoseObjectives.matRad_MeanDose';
                    s.parameters{1} = old_s.dose;

                case 'EUD'
                    s.className = 'DoseObjectives.matRad_EUD';
                    s.parameters{1} = old_s.dose;
                    s.parameters{2} = old_s.EUD;

                    %Constraints
                case  'max dose constraint'
                    s.className = 'DoseConstraints.matRad_MinMaxDose';
                    s.parameters{1} = 0;
                    s.parameters{2} = old_s.dose;

                case  'min dose constraint'
                    s.className = 'DoseConstraints.matRad_MinMaxDose';
                    s.parameters{1} = old_s.dose;
                    s.parameters{2} = Inf;

                case  'min mean dose constraint'
                    s.className = 'DoseConstraints.matRad_MinMaxMeanDose';
                    s.parameters{1} = old_s.dose;
                    s.parameters{2} = Inf;

                case  'max mean dose constraint'
                    s.className = 'DoseConstraints.matRad_MinMaxMeanDose';
                    s.parameters{1} = 0;
                    s.parameters{2} = old_s.dose;


                case  'min EUD constraint'
                    s.className = 'DoseConstraints.matRad_MinMaxEUD';
                    s.parameters{1} = old_s.EUD;
                    s.parameters{2} = old_s.dose;
                    s.parameters{3} = Inf;

                case  'max EUD constraint'
                    s.className = 'DoseConstraints.matRad_MinMaxEUD';
                    S.parameters{1} = old_s.EUD;
                    s.parameters{2} = 0;
                    s.parameters{3} = old_s.dose;

                case  'max DVH constraint'
                    s.className = 'DoseConstraints.matRad_MinMaxDVH';
                    s.parameters{1} = old_s.dose;
                    s.parameters{2} = 0;
                    s.parameters{3} = old_s.volume;

                case  'min DVH constraint'
                    s.className = 'DoseConstraints.matRad_MinMaxDVH';
                    s.parameters{1} = old_s.dose;
                    s.parameters{2} = old_s.volume;
                    s.parameters{3} = 100;
                otherwise
                    ME = MException('optimization:ObjectCreationFailed','Old versioned input struct / parameter invalid for creation of optimization function!');
                    throw(ME);
            end
        end
    end
end