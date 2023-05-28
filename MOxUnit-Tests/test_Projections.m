function test_suite=test_Projections
    % Initialization of dose influence structure
    nVox = 3;
    nB = 2;
    dij.ax= 0.1*ones(nVox,1);
    dij.bx=0.05*ones(nVox,1);
    dij.gamma=dij.ax./(2*dij.bx);
    dij.physicalDose{1} = rand(nVox,nB);
    dij.mAlphaDose{1} = rand(nVox,nB);
    dij.mLetDose{1} = rand(nVox, nB);
    dij.mSqrtBetaDose{1} = rand(nVox, nB);
    dij.ixDose = dij.bx~=0;
    dij.doseGrid.numOfVoxels = nVox;
    dij.fixedCurrent = 300;
    dij.RBE = 1.1;

    % Weights during optimization
    w = ones(nB,1);

    test_functions = {};

    % Needs relative path
    MyFolderInfo = dir('../optimization/projections');

    for i=1:length(MyFolderInfo)
      if (MyFolderInfo(i).name(1)~='.' && ~contains(MyFolderInfo(i).name(1), ".asv"))
       if not(isequal(MyFolderInfo(i).name, 'matRad_BackProjection.m'))
        test_functions{end+1} = eval( ...
            ['@() testProjection(''' MyFolderInfo(i).name ''', dij, w )']);
       end
      end
    end
    test_functions = test_functions';
    initTestSuite;

    % Tests classes ConstantRBEProjection, DoseProjection, EffectProjection
    % and VariableRBEProjection

function testProjection(fileName,dij,w)
    % Building Constructor using the file name.
    constructorOfProjection = str2func(fileName(1:end-2));

    % Calls Constructor
    proj = constructorOfProjection();

    % Number of voxels
    nVox = dij.doseGrid.numOfVoxels;

    % Number of weights
    nB = numel(w);

    % Fails for matRad_VariableRBEProjection..
    % Gradient of Scenario
    g = proj.projectSingleScenarioGradient(dij,{ones(nVox,1)},1,w);
    
    % Estimated jacobian
    [jacobEst,err] = jacobianest(@(x) proj.computeSingleScenario(dij,1,x'),w');

    % Sums each row of the matrix(jacobEst)
    gEst = sum(jacobEst)';

    % 1x2 vector
    err = sum(err);

    assertEqual(size(g), size(w));
    assertEqual(size(g), size(gEst));
    assertEqual(length(g), nB);
    assertElementsAlmostEqual(g, gEst, 'absolute', max(err));
    assertTrue(isreal(g));
    assertNotEqual(g, NaN);
    assertNotEqual(g, Inf);
    assertNotEqual(g, -Inf);
