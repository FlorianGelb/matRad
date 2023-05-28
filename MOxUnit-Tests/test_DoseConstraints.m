function test_suite=test_DoseConstraints
test_functions = {};

% Needs relative path
MyFolderInfo = dir('../optimization/+DoseConstraints');

for i=1:length(MyFolderInfo)
    if (MyFolderInfo(i).name(1)~='.' && ~contains(MyFolderInfo(i).name(1), ".asv"))
        if not(isequal(MyFolderInfo(i).name, 'matRad_DoseConstraint.m'))

            % 'eval(...)' term to show in console which object failed.
            % To have object name labeled in function name.
            test_functions{end+1} = eval(['@() testComputeDoseConstraintJacobian(''' MyFolderInfo(i).name ''')']);
            test_functions{end+1} = eval(['@() testComputeDoseConstraintFunction(''' MyFolderInfo(i).name ''')']);
        end
    end
end
test_functions = test_functions';
initTestSuite;

% Beide Tests werden für matRad_MinMaxDose, matRad_MinMaxDVH,
% matRad_MinMaxEUD und matRad_MinMaxMeanDose ausgeführt.

function testComputeDoseConstraintJacobian(fileName)
    % Building Constructor using the file name.
    constructorOffConstraint = str2func(strcat('DoseConstraints.', fileName(1:end-2)));

    dose = [10 20 30 40 50 60]';

    % Calls Constructor
    obj = constructorOffConstraint();
    doseConstraintJacobian=obj.computeDoseConstraintJacobian(dose);
    [jac,err] = jacobianest(@(x) obj.computeDoseConstraintFunction(x'), dose');
    epsilon = obj.maxDerivativeError + max(err);

    % nth root problem. 
    assertTrue(isreal(doseConstraintJacobian));

    % Just accepts verctors | Add err + errImp
    assertVectorsAlmostEqual(jac', doseConstraintJacobian, 'relative', epsilon);

    assertEqual(size(doseConstraintJacobian), size(dose));
    assertNotEqual(doseConstraintJacobian, NaN);
    assertNotEqual(doseConstraintJacobian, Inf);
    assertNotEqual(doseConstraintJacobian, -Inf);

function testComputeDoseConstraintFunction(fileName)
    % Building Constructor using the file name.
    constructorOffConstraint = str2func(strcat('DoseConstraints.', fileName(1:end-2)));

    dose = [10 20 30 40 50 60];
    
    % Calls Constructor
    obj = constructorOffConstraint();

    f = obj.computeDoseConstraintFunction(dose);
    [r,c] = size(f);
    assertTrue(isreal(f));
    assertGreaterThan(f, zeros(r,c) - eps);
    assertNotEqual(f, NaN);
    assertNotEqual(f, Inf);
    assertNotEqual(f, -Inf);