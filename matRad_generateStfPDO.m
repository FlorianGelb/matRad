
function stf = matRad_generateStfPDO(patientData)

matRad_cfg = MatRad_Config.instance();
matRad_cfg.dispInfo('matRad: Generating stf struct... ');

ct = patientData.get_ct();
cst = patientData.get_cst();
pln = patientData.get_pln();

stf = matRad_generateStf(ct,cst,pln);

end
