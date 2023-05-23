import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoberturaFormat
suite = testsuite("test_interp1");
runner = testrunner("textoutput");
sourceCodeFile = "../matRad_interp1.m";
reportFile = "coverageReport.xml";
reportFormat = CoberturaFormat(reportFile);
p = CodeCoveragePlugin.forFile(sourceCodeFile,"Producing",reportFormat);
runner.addPlugin(p)
results = runner.run(suite);