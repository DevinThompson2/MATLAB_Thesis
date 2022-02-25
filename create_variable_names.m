function [variableList] = create_variable_names(table)
%UNTITLED4 Summary of this function goes here
% Creates a list specified by the string vector below


%variableList = ["hipRot";"trunkRot";"hipVel";"trunkVel"];
if table == 1
    variableList = {'BatAngVel';'BatECAPAcc';'BatECAPVel';'BatSSAcc';'BatSSVel';'HipRot';'HipRotVel';'LElbowFlex';'LElbowVel';'LKneeFlex';'LKneeVel';'RElbowFlex';'RElbowVel';'RKneeFlex';'RKneeVel';'ShouldAbd';'TrunkFlex';'TrunkLatFlex';'TrunkRot';'TrunkVel'};
elseif table == 2
    variableList = {'maxHipRotVel';'maxTrunkRotVel';'maxLeadElbowVel';'maxRearElbowVel';'maxLeadKneeVel';'maxRearKneeVel';'maxHipRotation';'maxTrunkRotation';'maxTrunkFlexion';'maxTrunkLateralFlexion';'maxShoulderAbd';'maxLeadKneeFlexion';'maxLeadElbowFlexion';'maxRearKneeFlexion';'maxRearElbowFlexion'};
elseif table == 3
    variableList = {'leadElbowAngles';'leadElbowVel';'leadKneeAngles';'leadKneeVel';'rearElbowAngles';'rearElbowVel';'rearKneeAngles';'rearKneeVel';'batECAPAcc';'batECAPVel';'batSSAcc';'batSSVel';'headFlexion';'headLateralFlexion';'headRotation';'hipRotation';'hipRotationVel';'leadArmAngVel';'leadHandAngVel';'leadWristAcc';'leadWristVel';'batAngVel';'rearShoulderAbduction';'trunkFlexion';'trunkLateralFlexion';'trunkRotation';'trunkRotationVel'};
end
disp(variableList)
%variableList = {'Fun_BatAngVel';'Fun_BatECAPAcc';'Fun_BatECAPVel';'Fun_BatSSAcc';'Fun_BatSSVel';'Fun_HipRot';'Fun_HipRotVel';'Fun_LElbowFlex';'Fun_LElbowVel';'Fun_LKneeFlex';'Fun_LKneeVel';'Fun_RElbowFlex';'Fun_RElbowVel';'Fun_RKneeFlex';'Fun_RKneeVel';'Fun_ShouldAbd';'Fun_TrunkFlex';'Fun_TrunkLatFlex';'Fun_TrunkRot';'Fun_TrunkVel'};
end

