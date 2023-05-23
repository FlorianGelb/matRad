classdef test_interp1 < matlab.unittest.TestCase
    methods(Test)
        function testInterp1Extrapolation(testCase)
            xi = [100, 150, 200, 250, 300, 400, 500];
            yi = [2506.7, 2582.8, 2658.1, 2733.7, 2810.4, 2967.9, 3131.6]';
            x = 650;
            matRad_interp1_solution = matRad_interp1(xi, yi, x);
            interp1_solution = interp1(xi, yi, x);
            testCase.verifyEqual(matRad_interp1_solution,interp1_solution)
        end

        function testInterp1Extrapolation2Point(testCase)
            xi = [100, 150, 200, 250, 300, 400, 500];
            yi = [2506.7, 2582.8, 2658.1, 2733.7, 2810.4, 2967.9, 3131.6]';
            x = [650 651].';
            matRad_interp1_solution = matRad_interp1(xi, yi, x);
            interp1_solution = interp1(xi, yi, x);
            testCase.verifyEqual(matRad_interp1_solution,interp1_solution)
        end
    
        function testInterp1Interpolation(testCase)
            xi = [100, 150, 200, 250, 300, 400, 500];
            yi = [2506.7, 2582.8, 2658.1, 2733.7, 2810.4, 2967.9, 3131.6]';
            x = 222;
            matRad_interp1_solution = matRad_interp1(xi, yi, x);
            interp1_solution = interp1(xi, yi, x);
            testCase.verifyEqual(matRad_interp1_solution,interp1_solution)
        end

        function testInterp1InterpolationPointInXi(testCase)
            xi = [100, 150, 200, 222, 250 300, 400, 500];
            yi = [2506.7, 2582.8, 2658.1, 2.6914e+03, 2733.7, 2810.4, 2967.9, 3131.6]';
            x = 222;
            matRad_interp1_solution = matRad_interp1(xi, yi, x);
            interp1_solution = interp1(xi, yi, x);
            testCase.verifyEqual(matRad_interp1_solution,interp1_solution)
        end

        function testInterp1Interpolation2point(testCase)
            xi = [100, 150, 200, 250, 300, 400, 500];
            yi = [2506.7, 2582.8, 2658.1, 2733.7, 2810.4, 2967.9, 3131.6]';
            x = [222 223].';
            matRad_interp1_solution = matRad_interp1(xi, yi, x);
            interp1_solution = interp1(xi, yi, x);
            testCase.verifyEqual(matRad_interp1_solution,interp1_solution)
        end
    
        function testFalseInput(testCase)
            xi = [100, 150, 200, 300, 400, 500]; % xi.length < yi.length => false input
            yi = [2506.7, 2582.8, 2658.1, 2733.7, 2810.4, 2967.9, 3131.6]';
            x = 2680.78;
            testCase.verifyError(@()interp1(xi, yi, x), 'MATLAB:interp1:YVectorInvalidNumRows');
        end    
    end
end