function test_suite=test_matRad_generateStfPDO
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;

function testMockStfGeneration()
import matlab.mock.TestCase
import matlab.mock.actions.AssignOutputs;
import matlab.mock.constraints.WasCalled;


load TG119.mat


testCase = TestCase.forInteractiveUse;
[stubPDO, PDOBehavior] = createMock(testCase,?matRad_patientData);
methods(stubPDO)

when(withAnyInputs(PDOBehavior.get_cst),AssignOutputs(cst));
when(withAnyInputs(PDOBehavior.get_ct),AssignOutputs(ct));
when(withAnyInputs(PDOBehavior.get_pln),AssignOutputs(create_pln(ct, cst)));

stf = matRad_generateStfPDO(stubPDO);

testCase.verifyCalled(withAnyInputs(PDOBehavior.get_cst()))
testCase.verifyCalled(withAnyInputs(PDOBehavior.get_ct()))
testCase.verifyCalled(withAnyInputs(PDOBehavior.get_pln()))

function pln = create_pln(ct, cst)
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
%!!!! Copied from matRad.m !!!!%
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
% meta information for treatment plan

pln.radiationMode   = 'photons';     % either photons / protons / carbon
pln.machine         = 'Generic';

pln.numOfFractions  = 30;

% beam geometry settings
pln.propStf.bixelWidth      = 5; % [mm] / also corresponds to lateral spot spacing for particles
pln.propStf.gantryAngles    = [0:72:359]; % [?]
pln.propStf.couchAngles     = [0 0 0 0 0]; % [?]
pln.propStf.numOfBeams      = numel(pln.propStf.gantryAngles);
pln.propStf.isoCenter       = ones(pln.propStf.numOfBeams,1) * matRad_getIsoCenter(cst,ct,0);

% dose calculation settings
pln.propDoseCalc.doseGrid.resolution.x = 5; % [mm]
pln.propDoseCalc.doseGrid.resolution.y = 5; % [mm]
pln.propDoseCalc.doseGrid.resolution.z = 5; % [mm]

% optimization settings
pln.propOpt.optimizer       = 'IPOPT';
pln.propOpt.bioOptimization = 'none'; % none: physical optimization;             const_RBExD; constant RBE of 1.1;
                                      % LEMIV_effect: effect-based optimization; LEMIV_RBExD: optimization of RBE-weighted dose
pln.propOpt.runDAO          = false;  % 1/true: run DAO, 0/false: don't / will be ignored for particles
pln.propOpt.runSequencing   = false;  % 1/true: run sequencing, 0/false: don't / will be ignored for particles and also triggered by runDAO below

