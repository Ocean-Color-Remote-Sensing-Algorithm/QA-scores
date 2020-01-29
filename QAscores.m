function [maxCos, cos, clusterID, totScore] = QAscores(test_Rrs, test_lambda)
% Quality assurance system for Rrs spectra (version 1)
%
% Author: Jianwei Wei, University of Massachusetts Boston
% Email: Jianwei.Wei@umb.edu
% Nov-01-2016
%
% ------------------------------------------------------------------------------
% KNOWN VARIABLES :   ref_nRrs   -- Normalized Rrs spectra per-determined from water clustering (23x9 matrix)  
%                     ref_lambda -- Wavelengths for ref_nRrs (1x9 matrix)
%                     upB        -- Upper boundary (23x9 matrix)
%                     lowB       -- Lower boundary (23x9 matrix)
%
% INPUTS:            test_Rrs   -- Rrs spectra for testing (units: sr^-1); a row vector
%                    test_lambda-- Wavelengths for test_Rrs
%
% OUTPUTS:  maxCos     -- maximum cosine values
%           cos        -- cosine values for every ref_nRrs spectra
%           clusterID  -- idenfification of water types (from 1-23)
%           totScore   -- total score assigned to test_Rrs
% ------------------------------------------------------------------------------
% 
% NOTE:
%         1) Nine wavelengths (412, 443, 488, 510, 531, 547, 555, 667, 678nm) are assumed in the model
%         2) If your Rrs data were measured at other wavelength, e.g. 440nm, you may want to change 440 to 443 before the model run;
%             or modify the code below to find a cloest wavelength from the nine bands.
%         3) The latest version may be found online at HTTP://oceanoptics.umb.edu/score_metric
%
% Reference:
%         Wei, Jianwei; Lee, Zhongping; Shang, Shaoling (2016). A system
%         to measure the data quality of spectral remote sensing
%         reflectance of aquatic environments. Journal of Geophysical Research, 
%         121, doi:10.1002/2016JC012126
%         
%
%% 
ref_lambda = [... 
4.1200000e+02   4.4300000e+02   4.8800000e+02   5.1000000e+02   5.3100000e+02   5.4700000e+02   5.5500000e+02   6.6700000e+02   6.7800000e+02];

ref_nRrs = [...
7.3796683e-01   5.3537883e-01   3.3492125e-01   1.6941114e-01   1.1182662e-01   8.4361643e-02   7.2175090e-02   7.2722859e-03   7.0353728e-03
6.7701882e-01   5.3387929e-01   3.9394438e-01   2.2455653e-01   1.5599408e-01   1.2008708e-01   1.0354070e-01   1.0933735e-02   1.0455480e-02
6.0833086e-01   5.2121439e-01   4.3584243e-01   2.7962783e-01   2.0377847e-01   1.6110758e-01   1.4032775e-01   1.6391579e-02   1.6652716e-02
5.0963646e-01   4.7791625e-01   4.6164394e-01   3.4802439e-01   2.7862610e-01   2.3009577e-01   2.0608914e-01   2.8730802e-02   3.1444642e-02
4.2964691e-01   4.3556598e-01   4.7152369e-01   3.8584748e-01   3.2599050e-01   2.7815421e-01   2.5272485e-01   3.7857754e-02   4.0848963e-02
3.6333623e-01   3.8706313e-01   4.5815748e-01   4.0800274e-01   3.6779296e-01   3.2800639e-01   3.0440341e-01   4.2053379e-02   4.6881488e-02
3.0946099e-01   3.5491575e-01   4.5120901e-01   4.1874143e-01   3.9159654e-01   3.5624518e-01   3.3479154e-01   4.7772121e-02   5.2270007e-02
2.7592997e-01   3.1479809e-01   4.1544764e-01   4.1498609e-01   4.1372468e-01   3.9362850e-01   3.7826076e-01   6.1949978e-02   6.7485875e-02
3.4894221e-01   3.3506487e-01   3.9141989e-01   3.8562158e-01   3.8741043e-01   3.8162021e-01   3.7750529e-01   9.0297871e-02   1.1765683e-01
2.2772731e-01   2.7529725e-01   3.8286839e-01   4.0702216e-01   4.2986184e-01   4.2741518e-01   4.2034636e-01   7.8973961e-02   8.2281945e-02
2.9144133e-01   2.7609677e-01   3.4217459e-01   3.6720207e-01   4.0137560e-01   4.2429030e-01   4.3706779e-01   1.2861174e-01   1.8141021e-01
1.8746813e-01   2.4076435e-01   3.4198541e-01   3.8187091e-01   4.2690383e-01   4.5020436e-01   4.6108232e-01   1.4677497e-01   1.5051459e-01
1.7255536e-01   2.2029128e-01   3.4230960e-01   3.9321173e-01   4.4659383e-01   4.6240583e-01   4.6390040e-01   9.2807580e-02   9.5738816e-02
1.8841854e-01   2.3450346e-01   3.1896860e-01   3.6310347e-01   4.1160987e-01   4.4466363e-01   4.6280653e-01   2.1459148e-01   2.1401522e-01
1.4302269e-01   1.9142029e-01   3.0575515e-01   3.6501150e-01   4.3375853e-01   4.7213469e-01   4.9178025e-01   1.6955637e-01   1.7983785e-01
1.8122161e-01   2.0034662e-01   2.6123587e-01   3.0652476e-01   3.6505277e-01   4.1049611e-01   4.3692672e-01   3.5885777e-01   3.7375096e-01
1.7376760e-01   2.0335076e-01   2.8260384e-01   3.3433902e-01   3.9927549e-01   4.4616335e-01   4.7240007e-01   2.7161480e-01   2.8030883e-01
1.4172683e-01   1.6884314e-01   2.7937007e-01   3.4856431e-01   4.3857605e-01   4.9800156e-01   5.2526881e-01   1.2057525e-01   1.3119104e-01
4.9762118e-02   1.2646476e-01   2.1885211e-01   2.7695980e-01   3.3962502e-01   3.9232585e-01   4.2293225e-01   4.5168610e-01   4.4940869e-01
1.1664824e-01   1.5255979e-01   2.5801235e-01   3.2411839e-01   4.1170366e-01   4.7713532e-01   5.1451309e-01   2.4308012e-01   2.5948949e-01
1.6300080e-01   1.7545808e-01   2.4907066e-01   3.0835049e-01   4.0042169e-01   4.9006514e-01   5.4422570e-01   1.8971850e-01   2.1691957e-01
1.1144977e-01   1.3489716e-01   2.2644205e-01   2.9215646e-01   3.8536483e-01   4.6326561e-01   5.1087974e-01   3.0960602e-01   3.2932847e-01
1.4502528e-01   1.3256756e-01   1.7550282e-01   2.1469996e-01   2.8639896e-01   4.2323996e-01   5.4785581e-01   3.4123619e-01   4.4889669e-01];

upB = [...
7.7969936e-01   5.5909264e-01   3.6692096e-01   2.0292753e-01   1.3779175e-01   1.0873357e-01   9.5895728e-02   4.5695335e-02   4.6623543e-02
7.1135851e-01   5.5483793e-01   4.2431975e-01   2.5442939e-01   1.8182569e-01   1.4088103e-01   1.2594384e-01   2.7945457e-02   2.7482701e-02
6.4636996e-01   5.4024177e-01   4.7082785e-01   3.2199848e-01   2.4284402e-01   1.9718059e-01   1.7318334e-01   6.7007986e-02   6.1761903e-02
5.6956355e-01   5.1481217e-01   5.2762943e-01   3.7374247e-01   3.1163845e-01   2.6467090e-01   2.3993224e-01   6.1840977e-02   6.1595171e-02
4.7766327e-01   4.8771143e-01   5.4753295e-01   4.1775156e-01   3.5180203e-01   3.1410390e-01   3.0074757e-01   9.8916601e-02   9.8223557e-02
4.2349058e-01   4.1629204e-01   5.0574462e-01   4.2702700e-01   3.8954221e-01   3.5793655e-01   3.4536165e-01   6.5299946e-02   7.0929396e-02
3.6203259e-01   3.8603916e-01   4.8546366e-01   4.3877038e-01   4.1263302e-01   3.7826776e-01   3.6026748e-01   8.9755079e-02   9.6484956e-02
3.2810264e-01   3.4343461e-01   4.6353434e-01   4.4890674e-01   4.4108569e-01   4.1758379e-01   4.1232286e-01   9.4401188e-02   1.4021177e-01
4.2855883e-01   3.6912183e-01   4.3403075e-01   4.1270429e-01   4.1160816e-01   4.0289362e-01   4.1035327e-01   1.6615177e-01   1.7528681e-01
2.8324712e-01   3.1754972e-01   4.7084893e-01   4.5098695e-01   4.5149446e-01   4.5357177e-01   4.5236036e-01   1.2816675e-01   1.2540729e-01
3.5991344e-01   3.1914376e-01   3.7307732e-01   3.9984107e-01   4.2745720e-01   4.5149720e-01   4.7720363e-01   1.6995977e-01   2.8445448e-01
2.5323148e-01   2.8678090e-01   3.7399254e-01   4.0526187e-01   4.3921995e-01   4.7516031e-01   5.0687105e-01   1.8317200e-01   1.8818901e-01
2.3499754e-01   2.5303395e-01   3.9213672e-01   4.2364082e-01   4.7335481e-01   4.8597037e-01   4.8826847e-01   1.2800547e-01   1.3376144e-01
2.6334872e-01   2.6326210e-01   3.4983739e-01   3.8201315e-01   4.2907348e-01   4.6056025e-01   5.0704621e-01   2.6195191e-01   2.7603537e-01
2.0165686e-01   2.1944496e-01   3.3293904e-01   3.8081387e-01   4.4757827e-01   4.9268537e-01   5.2092931e-01   2.0348242e-01   2.2378780e-01
2.2950692e-01   2.2362822e-01   2.9607108e-01   3.3929798e-01   3.8191277e-01   4.3237136e-01   4.6462834e-01   3.9304042e-01   4.1905293e-01
2.3208516e-01   2.4386127e-01   3.1588427e-01   3.5480624e-01   4.1530756e-01   4.6339021e-01   5.0286163e-01   3.0237661e-01   3.1290136e-01
2.0171262e-01   2.0441871e-01   3.0892189e-01   3.7634368e-01   4.5467828e-01   5.2197132e-01   5.6041815e-01   1.6311236e-01   1.6976942e-01
6.5661340e-02   1.4690487e-01   2.3551261e-01   2.9595427e-01   3.6727210e-01   4.1473807e-01   4.3942630e-01   4.7896558e-01   4.9313138e-01
1.5923700e-01   1.8447802e-01   2.9637570e-01   3.5554446e-01   4.2928965e-01   5.0010046e-01   5.7076206e-01   2.9044526e-01   2.9315569e-01
2.3467705e-01   2.3694940e-01   2.9291331e-01   3.3603937e-01   4.4272385e-01   5.1506755e-01   6.0505783e-01   2.4064496e-01   2.8576387e-01
1.5917155e-01   1.6716117e-01   2.5081075e-01   3.1848061e-01   4.0755621e-01   4.8220009e-01   5.7294813e-01   3.5104257e-01   3.8328993e-01
1.8025311e-01   1.6668715e-01   1.9757519e-01   2.3256976e-01   3.0993604e-01   4.5188827e-01   5.7836256e-01   3.7903370e-01   5.0856220e-01];

lowB = [...
7.0944028e-01   5.1166101e-01   2.7132138e-01   1.1925057e-01   7.3117696e-02   5.2517151e-02   4.4424250e-02   2.3244358e-03   1.7280789e-03
6.3840139e-01   5.0883522e-01   3.6351047e-01   1.9833316e-01   1.3181697e-01   1.0045892e-01   8.4327293e-02   2.7526552e-03   3.0136510e-03
5.5332832e-01   4.9738169e-01   4.1160489e-01   2.4634336e-01   1.7860486e-01   1.3952599e-01   1.1925864e-01   7.1624892e-03   6.7813256e-03
4.3575142e-01   4.3822012e-01   4.1917290e-01   3.1017788e-01   2.4134878e-01   1.9276253e-01   1.6873340e-01   1.0336969e-02   1.0575256e-02
3.6482973e-01   3.9039153e-01   4.1720917e-01   3.6595976e-01   2.8660924e-01   2.3234012e-01   2.0247522e-01   1.5868207e-02   1.5286574e-02
3.0704995e-01   3.6020020e-01   4.0499850e-01   3.8743491e-01   3.4744031e-01   2.9691113e-01   2.7164222e-01   2.8723854e-02   2.8095758e-02
2.5106498e-01   3.1479600e-01   4.1503769e-01   4.0334518e-01   3.7325697e-01   3.3395352e-01   3.0649812e-01   1.6409266e-02   2.1277292e-02
1.9524320e-01   2.6645927e-01   3.7459566e-01   3.8648689e-01   3.8966056e-01   3.7107656e-01   3.4536957e-01   2.3468373e-02   2.5248160e-02
2.9510963e-01   3.1603431e-01   3.6697675e-01   3.6241475e-01   3.5891532e-01   3.5210964e-01   3.4139078e-01   5.8341191e-02   6.6080536e-02
1.3127870e-01   2.3383370e-01   3.3563122e-01   3.8054666e-01   4.0677434e-01   3.8957954e-01   3.7636462e-01   2.1549732e-02   3.2454227e-02
2.4706327e-01   2.4040986e-01   3.1094797e-01   3.4504382e-01   3.6604542e-01   3.6960554e-01   3.7735013e-01   8.4929835e-02   1.1753899e-01
1.4757789e-01   2.0726071e-01   3.0160822e-01   3.3610868e-01   4.0871602e-01   4.2488320e-01   4.2659628e-01   1.0951814e-01   1.1484183e-01
9.1742158e-02   1.6100841e-01   3.1322179e-01   3.7490499e-01   4.2297563e-01   4.3757985e-01   4.3639722e-01   2.4259065e-02   2.3478356e-02
1.5838339e-01   1.9960855e-01   2.6513370e-01   3.1086089e-01   3.8179041e-01   4.2671191e-01   4.3813226e-01   1.5437250e-01   1.7919256e-01
6.5751115e-02   1.4872663e-01   2.7329740e-01   3.3440351e-01   4.1829544e-01   4.5463364e-01   4.6632118e-01   1.3489346e-01   1.4272407e-01
1.5596873e-01   1.6063788e-01   2.2583023e-01   2.8187737e-01   3.5551812e-01   3.9392236e-01   4.1661845e-01   3.2762330e-01   3.3207209e-01
1.3658524e-01   1.7620400e-01   2.5184514e-01   3.0981985e-01   3.8772491e-01   4.1841560e-01   4.3663895e-01   2.4409767e-01   2.4335830e-01
5.7943169e-02   1.1577971e-01   2.4910978e-01   3.2064774e-01   4.1928998e-01   4.8032887e-01   4.9879067e-01   4.9669377e-02   5.4213979e-02
3.2114597e-02   7.9563157e-02   1.8250239e-01   2.4567895e-01   3.2360944e-01   3.7846671e-01   4.1099745e-01   4.1683471e-01   4.0913583e-01
3.5790266e-02   9.6338446e-02   2.1754001e-01   2.9267040e-01   3.9487537e-01   4.6406111e-01   4.9047457e-01   2.0439610e-01   2.1684389e-01
1.0724044e-01   1.4052739e-01   1.9880290e-01   2.4646929e-01   3.4713330e-01   4.6406216e-01   5.0762214e-01   1.4872355e-01   1.7132289e-01
7.3193803e-02   9.8029772e-02   2.0015322e-01   2.4913266e-01   3.3016201e-01   4.5041635e-01   4.8460783e-01   2.6383395e-01   2.9161859e-01
9.3197327e-02   9.4502428e-02   1.4641494e-01   1.9385761e-01   2.6497912e-01   3.8223376e-01   4.8516910e-01   3.0135913e-01   3.8303801e-01];
    

%% match the ref_lambda and test_lambda
idx0 = []; % for ref_lambda 
idx1 = []; % for test_lambda

for i = 1 : length(test_lambda)
    pos = find(ref_lambda==test_lambda(i));
    if isempty(pos)
        idx1(i) = NaN;
    else
        idx0(i) = pos;
        idx1(i) = i;
    end
end

pos = isnan(idx1);  idx1(pos) = [];

test_lambda = test_lambda(idx1); test_Rrs = test_Rrs(idx1);
ref_lambda = ref_lambda(idx0); ref_nRrs = ref_nRrs(:,idx0); 
upB = upB(:,idx0); lowB = lowB(:,idx0); 


%% match the ref_nRrs and test_Rrs
pos = isnan(test_Rrs); 
test_lambda(pos) = []; test_Rrs(pos) = [];
ref_lambda(pos) = []; ref_nRrs(:,pos) = []; upB(:,pos) = []; lowB(:,pos) = []; 
   
%% nromalization
nRrs = test_Rrs./sqrt(nansum(test_Rrs.^2));  

%% adjust the ref_nRrs, according to the matched wavebands
[row, ~] = size(ref_nRrs);

%%%% re-normalize the ref_adjusted
for i = 1 : row
    ref_nRrs_corr(i,:) = ref_nRrs(i,:)./sqrt(nansum(ref_nRrs(i,:).^2));  
end

%% Classification 
%%%% calculate the Spectral angle mapper
for i = 1 : row    
    cos(i,1) = nansum(ref_nRrs_corr(i,:).*nRrs)/...
                sqrt(nansum((ref_nRrs_corr(i,:)).^2) *nansum(nRrs.^2));    
end
    
maxCos = max(cos);

if isnan(cos)
    clusterID = NaN;
else
    clusterID = find(cos==maxCos);
end

%% scoring
C = [];
[row, col] = size(ref_nRrs);

%%% re-normalzation
for i = 1 : row
    upB_corr(i,:) = upB(i,:)./sqrt(nansum(ref_nRrs(i,:).^2)); 
    lowB_corr(i,:) = lowB(i,:)./sqrt(nansum(ref_nRrs(i,:).^2)); 
end

%% comparison
for i = 1 : col
    if nRrs(i)> upB_corr(clusterID,i)*(1+0.005) || ...
                nRrs(i)< lowB_corr(clusterID,i)*(1-0.005)
        C(i,1) = 0;
    else
        C(i,1) = 1;
    end 
end

totScore = nanmean(C) ;   




