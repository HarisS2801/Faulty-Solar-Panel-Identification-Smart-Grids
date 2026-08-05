%% =========================================================
% PV FAULT DETECTION (3S2P) - GROUND FAULT + IRRADIANCE CHANGE
% Output only:
%   - Healthy condition, or
%   - Which string has fault
%   - Which module(s) are faulty
%
% Notes:
%   - No fault type is displayed
%   - Consecutive abnormal modules are grouped, and the first one
%     in that region is reported as the faulty module
%   - getScalar() is fixed to avoid field-name warnings
%% =========================================================

clc;

%% ---------- 1) Read signals from out ----------
V1 = out.V1; V2 = out.V2; V3 = out.V3;
V4 = out.V4; V5 = out.V5; V6 = out.V6;

if ~isprop(out,'I1') || ~isprop(out,'I2')
    error(['I1 and/or I2 not found inside out. Add To Workspace blocks for I1 and I2 ' ...
           '(Save format = Array, Variable name = I1/I2, Output = out).']);
end

IA = out.I1;         % String A current
IT = out.I2;         % Total current
IB = IT - IA;        % String B current

N = length(V1);
assert(all([length(V2),length(V3),length(V4),length(V5),length(V6),length(IA),length(IT)] == N), ...
    'Signal length mismatch. Ensure all logged signals have same length.');

%% ---------- 2) Compute string voltages and powers ----------
VA = V1 + V2 + V3;
VB = V4 + V5 + V6;

PA = VA .* IA;
PB = VB .* IB;

%% ---------- 3) Use steady-state portion ----------
idx0 = max(1, floor(0.80*N));   % last 20%
ss = idx0:N;
med = @(x) median(x(ss));

VmodsA = [med(V1), med(V2), med(V3)];
VmodsB = [med(V4), med(V5), med(V6)];

IAs = med(IA);
IBs = med(IB);
ITs = med(IT);

PAs = med(PA);
PBs = med(PB);

%% ---------- 4) Read irradiance signals ----------
% IMPORTANT:
% Use the exact names saved inside out.
% These candidate names are checked safely without warnings.
%
% If needed, run:
%   fieldnames(out)
% and update these names to exactly match your SimulationOutput fields.

G1 = getScalar(out, {'Irradiance','Ir','Ir1','G1'}, 1000);
G2 = getScalar(out, {'Irradiance1','Ir1','Ir2','G2'}, 1000);
G3 = getScalar(out, {'Irradiance2','Ir2','Ir3','G3'}, 1000);
G4 = getScalar(out, {'Irradiance3','Ir3','Ir4','G4'}, 1000);
G5 = getScalar(out, {'Irradiance4','Ir4','Ir5','G5'}, 1000);
G6 = getScalar(out, {'Irradiance5','Ir5','Ir6','G6'}, 1000);

GmodsA = [G1, G2, G3];
GmodsB = [G4, G5, G6];

%% ---------- 5) Thresholds ----------
I_zero_th      = 0.05;   % A
V_low_th       = 1.0;    % V
V_equal_eps    = 0.5;    % small spread threshold
Vdev_ratio_th  = 0.08;   % relative voltage deviation threshold
Vminor_drop_th = 1.0;    % absolute voltage drop threshold
Gdev_ratio_th  = 0.10;   % irradiance deviation threshold (10%)

%% ---------- 6) Initialize result ----------
result = struct();
result.faultFlag = false;

result.stringA.fault = false;
result.stringA.modules = [];

result.stringB.fault = false;
result.stringB.modules = [];

%% ---------- 7) Electrical summary ----------
meanVA = mean(VmodsA);
meanVB = mean(VmodsB);

spreadA = max(VmodsA) - min(VmodsA);
spreadB = max(VmodsB) - min(VmodsB);

meanGA = mean(GmodsA);
meanGB = mean(GmodsB);

%% ---------- 8) Hard fault masks ----------
lowA = VmodsA < V_low_th;
lowB = VmodsB < V_low_th;

%% ---------- 9) Voltage abnormal masks ----------
abnVA = false(1,3);
abnVB = false(1,3);

if spreadA > V_equal_eps || any((meanVA - VmodsA) > Vminor_drop_th)
    abnVA = (VmodsA < (1 - Vdev_ratio_th)*meanVA) | ((meanVA - VmodsA) > Vminor_drop_th);
end

if spreadB > V_equal_eps || any((meanVB - VmodsB) > Vminor_drop_th)
    abnVB = (VmodsB < (1 - Vdev_ratio_th)*meanVB) | ((meanVB - VmodsB) > Vminor_drop_th);
end

%% ---------- 10) Irradiance abnormal masks ----------
abnGA = false(1,3);
abnGB = false(1,3);

if meanGA > 0
    abnGA = GmodsA < (1 - Gdev_ratio_th)*meanGA;
end

if meanGB > 0
    abnGB = GmodsB < (1 - Gdev_ratio_th)*meanGB;
end

%% ---------- 11) Final candidate masks ----------
% Detect module as abnormal if:
%   - module voltage is near zero, OR
%   - module voltage deviates from same-string modules, OR
%   - module irradiance deviates from same-string modules
candA = lowA | abnVA | abnGA;
candB = lowB | abnVB | abnGB;

%% ---------- 12) Group consecutive abnormal modules ----------
% String A
k = 1;
while k <= 3
    if candA(k)
        result.stringA.fault = true;
        result.stringA.modules(end+1) = k;

        j = k + 1;
        while j <= 3 && candA(j)
            j = j + 1;
        end
        k = j;
    else
        k = k + 1;
    end
end

% String B
k = 1;
while k <= 3
    if candB(k)
        result.stringB.fault = true;
        result.stringB.modules(end+1) = k + 3;

        j = k + 1;
        while j <= 3 && candB(j)
            j = j + 1;
        end
        k = j;
    else
        k = k + 1;
    end
end

%% ---------- 13) Remove duplicates ----------
result.stringA.modules = unique(result.stringA.modules, 'stable');
result.stringB.modules = unique(result.stringB.modules, 'stable');

%% ---------- 14) Zero-current healthy condition ----------
% Only call healthy if there is:
%   - no detected abnormal module
%   - all currents near zero
%   - and all module voltages are healthy enough

allModuleVoltages = [VmodsA VmodsB];

if isempty(result.stringA.modules) && isempty(result.stringB.modules) && ...
   abs(IAs) < I_zero_th && abs(IBs) < I_zero_th && abs(ITs) < I_zero_th && ...
   all(allModuleVoltages > V_low_th)

    result.faultFlag = false;
else
    result.faultFlag = result.stringA.fault || result.stringB.fault;
end

%% ---------- 15) Print output ----------
disp("========= PV FAULT DETECTION =========")
disp("IA = " + num2str(IAs,'%.3f') + " | IB = " + num2str(IBs,'%.3f') + " | IT = " + num2str(ITs,'%.3f'))
disp("VmodsA = [" + num2str(VmodsA(1),'%.2f') + ", " + num2str(VmodsA(2),'%.2f') + ", " + num2str(VmodsA(3),'%.2f') + "]")
disp("VmodsB = [" + num2str(VmodsB(1),'%.2f') + ", " + num2str(VmodsB(2),'%.2f') + ", " + num2str(VmodsB(3),'%.2f') + "]")
disp("GmodsA = [" + num2str(GmodsA(1),'%.1f') + ", " + num2str(GmodsA(2),'%.1f') + ", " + num2str(GmodsA(3),'%.1f') + "]")
disp("GmodsB = [" + num2str(GmodsB(1),'%.1f') + ", " + num2str(GmodsB(2),'%.1f') + ", " + num2str(GmodsB(3),'%.1f') + "]")

if ~result.faultFlag
    disp("SYSTEM HEALTHY ✅")
else
    disp("FAULT DETECTED ✅")

    if result.stringA.fault && ~isempty(result.stringA.modules)
        modulesA = "PV" + string(result.stringA.modules);
        disp("String A : " + strjoin(cellstr(modulesA), ", "))
    end

    if result.stringB.fault && ~isempty(result.stringB.modules)
        modulesB = "PV" + string(result.stringB.modules);
        disp("String B : " + strjoin(cellstr(modulesB), ", "))
    end
end

%% ---------- helper function ----------
function val = getScalar(outObj, names, defaultVal)
val = NaN;

% Use existing field list first to avoid warnings
fields = fieldnames(outObj);

for k = 1:numel(names)
    nm = names{k};

    if ismember(nm, fields)
        v = outObj.(nm);

        if isa(v, 'timeseries')
            v = v.Data;
        end

        if isnumeric(v) && ~isempty(v)
            if isscalar(v)
                val = double(v);
            else
                val = double(v(end));
            end
            return;
        end
    end
end

if isnan(val)
    val = defaultVal;
end
end