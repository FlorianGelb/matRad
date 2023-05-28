function test_suite=test_DoseObjectives
    test_functions = {};

    % Needs relative path
    MyFolderInfo = dir('../optimization/+DoseObjectives');

    for i=1:length(MyFolderInfo)
      if (MyFolderInfo(i).name(1)~='.' && ~contains(MyFolderInfo(i).name(1), ".asv"))
       if not(isequal(MyFolderInfo(i).name, 'matRad_DoseObjective.m'))

        % 'eval(...)' term to show in console which object failed.
        % To have object name labeled in function name.
        test_functions{end+1} = eval(['@() testDoseGrad(''' MyFolderInfo(i).name ''')']);
        test_functions{end+1} = eval(['@() testDoseObjectiveFunction(''' MyFolderInfo(i).name ''')']);

       end
      end
    end
    test_functions = test_functions';
    initTestSuite;
    
    % Beide Tests werden für matRad_MinMaxDose, matRad_MinMaxDVH,
    % matRad_MinMaxEUD und matRad_MinMaxMeanDose ausgeführt.

function testDoseGrad(fileName)
    % Building Constructor using the file name.
    constructorOffObjective = str2func(strcat('DoseObjectives.', fileName(1:end-2)));

    % Dose initialization
    dose = [10 20 30 40 50 60]';

    % Calls Constructor
    obj = constructorOffObjective();

    doseGrad=obj.computeDoseObjectiveGradient(dose);

    % nth root problem (Problem based on complex values of EUD)
    % Fails for EUD
    assertTrue(isreal(doseGrad));

    [grad,err,finaldelta]=gradest(@(x) obj.computeDoseObjectiveFunction(x'), dose');
    epsilon = doseGrad*obj.maxDerivativeError + err';

    % Accepts vectors and matrices | Accepts vectors as epsilon
    assertElementsAlmostEqual(grad', doseGrad, 'absolute', max(epsilon));

    % Just accepts verctors | Add err + errImp
    assertVectorsAlmostEqual(grad', doseGrad, 'absolute', max(epsilon));

    assertEqual(size(doseGrad), size(dose));
    assertNotEqual(doseGrad, NaN);
    assertNotEqual(doseGrad, Inf);
    assertNotEqual(doseGrad, -Inf);

function testDoseObjectiveFunction(fileName)
    % Building Constructor using the file name.
    constructorOffObjective = str2func(strcat('DoseObjectives.', fileName(1:end-2)));

    dose = [10 20 30 40 50 60];

    % Calls Constructor
    obj = constructorOffObjective();

    f = obj.computeDoseObjectiveFunction(dose);
    [r,c] = size(f);
    assertTrue(isreal(f));
    assertGreaterThan(f, zeros(r,c) - eps);
    assertNotEqual(f, NaN);
    assertNotEqual(f, Inf);
    assertNotEqual(f, -Inf);