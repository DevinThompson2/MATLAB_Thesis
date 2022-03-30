function [out] = create_variable_names(table)
%UNTITLED4 Summary of this function goes here
% Creates a list specified by the string vector below


%variableList = ["hipRot";"trunkRot";"hipVel";"trunkVel"];
if table == 1
    variableList = {'BatAngVel';'BatECAPAcc';'BatECAPVel';'BatSSAcc';'BatSSVel';'HipRot';'HipRotVel';'LElbowFlex';'LElbowVel';'LKneeFlex';'LKneeVel';'RElbowFlex';'RElbowVel';'RKneeFlex';'RKneeVel';'ShouldAbd';'TrunkFlex';'TrunkLatFlex';'TrunkRot';'TrunkVel'};
elseif table == 2
    variableList = {'maxHipRotVel';'maxTrunkRotVel';'maxLeadElbowVel';'maxRearElbowVel';'maxLeadKneeVel';'maxRearKneeVel';'maxHipRotation';'maxTrunkRotation';'maxTrunkFlexion';'maxTrunkLateralFlexion';'maxShoulderAbd';'maxLeadKneeFlexion';'maxLeadElbowFlexion';'maxRearKneeFlexion';'maxRearElbowFlexion'};
elseif table == 3
    variableList = ["leadElbowAngles";"leadElbowVel";"leadKneeAngles";"leadKneeVel";"rearElbowAngles";"rearElbowVel";"rearKneeAngles";"rearKneeVel";"batECAPAcc";"batECAPVel";"batSSAcc";"batSSVel";"headFlexion";"headLateralFlexion";"headRotation";"hipRotation";"hipRotationVel";"leadArmAngVel";"leadHandAngVel";"leadWristAcc";"leadWristVel";"batAngVel";"rearShoulderAbduction";"trunkFlexion";"trunkLateralFlexion";"trunkRotation";"trunkRotationVel"];
    graphingVars = ["Lead Elbow Flexion/Extension"; "Lead Elbow Flexion/Extension Velocity"; "Lead Knee Flexion/Extension"; "Lead Knee Flexion/Extension Velocity"; "Rear Elbow Flexion/Extension"; "Rear Elbow Flexion/Extension Velocity"; "Rear Knee Flexion/Extension"; "Rear Knee Flexion/Extension Velocity"; "Bat ECAP Acceleration"; "Bat ECAP Velocity"; "Bat Sweet Spot Acceleration"; "Bat Sweet Spot Velocity"; "Head Flexion"; "Head Lateral Flexion"; "Head Rotation"; "Pelvis Rotation"; "Pelvis Rotational Velocity"; "Lead Arm Angular Velocity"; "Lead Hand Angular Velocity"; "Lead Wrist Acceleration"; "Lead Wrist Velocity"; "Bat Angular Velocity"; "Rear Shoulder Abduction"; "Trunk Flexion"; "Trunk Lateral Flexion"; "Trunk Rotation"; "Trunk Rotational Velocity"];
    out = [variableList graphingVars];
end
disp(variableList)
%variableList = {'Fun_BatAngVel';'Fun_BatECAPAcc';'Fun_BatECAPVel';'Fun_BatSSAcc';'Fun_BatSSVel';'Fun_HipRot';'Fun_HipRotVel';'Fun_LElbowFlex';'Fun_LElbowVel';'Fun_LKneeFlex';'Fun_LKneeVel';'Fun_RElbowFlex';'Fun_RElbowVel';'Fun_RKneeFlex';'Fun_RKneeVel';'Fun_ShouldAbd';'Fun_TrunkFlex';'Fun_TrunkLatFlex';'Fun_TrunkRot';'Fun_TrunkVel'};
end

